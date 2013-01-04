//
//  PDAppDelegate.m
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import "PDAppDelegate.h"
#import "PDSettings.h"
#import "PDStreamParser.h"
#import "PDRepository.h"

#import <CFNetwork/CFSocketStream.h>
#import <sys/socket.h>
#import <arpa/inet.h>


NSString * const TCPServerErrorDomain = @"TCPServerErrorDomain";

typedef enum {
    kTCPServerCouldNotBindToIPv4Address = 1,
    kTCPServerNoSocketsAvailable = 2,
    kTCPServerStreamError = 3
} TCPServerErrorCode;


@interface PDAppDelegate () <NSStreamDelegate, NSURLConnectionDelegate> {
    CFSocketRef _socket;
    NSMutableData* _recievedBytes;
    int _statusCode;
}

-(void)openPortStartListening;
-(void)closePortStopListening;
-(void)didConnect:(NSInputStream *)readStream;
-(void)connectionFailedWith:(NSError *)error;
-(void)safeClose:(NSStream *)readStream;

@end


@implementation PDAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self openPortStartListening];
    return YES;
}


-(void)applicationWillTerminate:(UIApplication *)application
{
    [self closePortStopListening];
}



#pragma mark - Instance Methods

-(void)openPortStartListening
{
    NSError *error = nil;
    PDSettings * appSettings = [[PDSettings alloc] init];
    
    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&acceptCallBack, &socketCtxt);
    if (_socket == NULL) {
#ifdef DEBUG
        NSLog(@"An error occured setting the socket options");
#endif // DEBUG
        error = [[NSError alloc] initWithDomain:TCPServerErrorDomain code:kTCPServerNoSocketsAvailable userInfo:nil];
        [self connectionFailedWith:error];
        return;
    }
	
    int yes = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
    
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(appSettings.listeningPort);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    
    NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, (__bridge CFDataRef)address4)) {
        CFRelease(_socket);
        _socket = nil;
        
        error = [[NSError alloc] initWithDomain:TCPServerErrorDomain code:kTCPServerCouldNotBindToIPv4Address userInfo:nil];
        [self connectionFailedWith:error];
    } else {
        CFRunLoopRef cfrl = CFRunLoopGetCurrent();
        CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        CFRunLoopAddSource(cfrl, source, kCFRunLoopCommonModes);
        CFRelease(source);
    }
}

-(void)closePortStopListening
{
    if (_socket) {
        CFSocketInvalidate(_socket);
        CFRelease(_socket);
        _socket = nil;
    }
}

-(void)didConnect:(NSInputStream *)readStream
{
    [readStream setDelegate:self];
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [readStream open];
}

-(void)connectionFailedWith:(NSError *)error
{
    switch (error.code) {
        case kTCPServerCouldNotBindToIPv4Address:
        case kTCPServerNoSocketsAvailable:
            [[NSNotificationCenter defaultCenter] postNotificationName:PDNotificationOpenConnectionFailure object:nil];
            break;
            
        case kTCPServerStreamError:
            [[NSNotificationCenter defaultCenter] postNotificationName:PDNotificationRecieveDataFailure object:nil];
            break;
            
        default:
#ifdef DEBUG
            NSLog(@"Failed to handle error: %@", error);
#endif //DEBUG
            break;
    }
}


-(void)safeClose:(NSInputStream *)readStream
{
    if (readStream) {
        [readStream close];
        [readStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        readStream = nil;
    }
}



#pragma mark - NSStream Delegate Methods

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            if (!_recievedBytes) {
                _recievedBytes = [NSMutableData data];
            }
            
            NSInputStream * input = (NSInputStream *)aStream;
            uint8_t buffer[512];
            unsigned int len = 0;
            
            bzero(buffer, sizeof(buffer));
            len = [input read:buffer maxLength:512];
            if (len) [_recievedBytes appendBytes:buffer length:len];
            
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            if (_recievedBytes.length > 0) {
                id parsedData = [PDStreamParser parse:_recievedBytes];
                [[PDRepository sharedInstance] insertNotification:parsedData];
            }
            
            [self safeClose:aStream];
            _recievedBytes = nil;
            break;
        }
            
        case NSStreamEventErrorOccurred:
        {
#ifdef  DEBUG
            NSLog(@"Streaming error occured: %@", [aStream streamError]);
#endif //DEBUG
            NSError * error = [NSError errorWithDomain:TCPServerErrorDomain code:kTCPServerStreamError userInfo:nil];
            [self connectionFailedWith:error];
            [self safeClose:aStream];
            _recievedBytes = nil;
            
            break;
        }
            
        default:break;
    }
}


static void
acceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    
    if (kCFSocketAcceptCallBack == type) {
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        CFReadStreamRef readStream = NULL;
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, NULL);
        if (readStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanFalse);
            [(__bridge PDAppDelegate *)info performSelector:@selector(didConnect:) withObject:(__bridge NSInputStream *)readStream];
        } else {
            close(nativeSocketHandle);
            [(__bridge PDAppDelegate *)info performSelector:@selector(connectionFailedWith:) withObject:nil];
        }
        
        if (readStream) CFRelease(readStream);
    }
}


@end

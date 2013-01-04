//
//  PDSettings.m
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import "PDSettings.h"

#include <ifaddrs.h>
#include <arpa/inet.h>


@implementation PDSettings

-(NSString *)listeningIPAddress
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        struct ifaddrs *temp_addr =  interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(NSInteger)listeningPort
{
    /* Hardcode for now this will change */
    return 8500;
}


@end

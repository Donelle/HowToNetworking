//
//  PDStreamParser.m
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//


@interface NSData (C7NSDataExtension)

- (NSString *)stringFromData;
- (UIImage *)imageFromData;

@end

@implementation NSData (C7NSDataExtension)

- (NSString *)stringFromData
{
    int32_t blockSize = sizeof(int32_t);
    NSUInteger textLength = 0;
    NSRange textLengthRange = { 0, blockSize };
    
    [self getBytes:&textLength range:textLengthRange];
    textLengthRange.location += blockSize;
    textLengthRange.length = textLength;
    
    return [NSString stringWithUTF8String:(const char *)
            [[self subdataWithRange:textLengthRange] bytes]];
    
}

- (UIImage *)imageFromData
{
    int32_t blockSize = sizeof(int32_t);
    NSUInteger imageLength = 0;
    NSRange imageRange = { 0, blockSize };

    [self getBytes:&imageLength range:imageRange];
    imageRange.location += blockSize;
    imageRange.length = imageLength;
    
    return [UIImage imageWithData:[self subdataWithRange:imageRange]];
}

@end


#import "PDStreamParser.h"

@implementation PDStreamParser

+ (id)parse:(NSData *)data
{
    int32_t blockSize = sizeof(int32_t);
    
    NSUInteger formatType = 0;
    NSRange formatRange = { 0, blockSize };
    [data getBytes:&formatType range:formatRange];

    NSRange contentRange = { blockSize, data.length - blockSize };
    NSData * content = [data subdataWithRange:contentRange];
    
    id resultSet = nil;
    switch (formatType) {
        case PDFormatTypeImage:
        {
            resultSet = [content imageFromData]; 
            break;
        }
            
        case PDFormatTypeText:
        {
            resultSet = [content stringFromData];
            break;
        }
            
        case PDFormatTypeBoth:
            NSLog(@"We're not going to implement PDFormatTypeBoth in this tutorial!");
            break;
            
        default:
            NSLog(@"ERROR: Unknown format type %u", formatType);
            break;
    }
    
    return resultSet;
}

+ (NSString *)stringFromData:(NSData *)data
{
    return [NSString stringWithUTF8String:(const char *) [data bytes]];
}

+ (UIImage *)imageFromData:(NSData *)data
{
    return [UIImage imageWithData:data];
}

@end

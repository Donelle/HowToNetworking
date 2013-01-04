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
    return [NSString stringWithUTF8String:(const char *) [self bytes]];
}

- (UIImage *)imageFromData
{
    return [UIImage imageWithData:[self bytes]];
}

@end


#import "PDStreamParser.h"

@implementation PDStreamParser

+ (id)parse:(NSData *)data
{
    uint32_t blockSize = sizeof(uint32_t);
    NSUInteger formatType = 0, contentSize = 0;
    NSRange formatRange = { 0, blockSize }, contentSizeRange = { blockSize, blockSize };
    
    [data getBytes:&formatType range:formatRange];
#ifdef DEBUG
    NSLog(@"Format Type: %u", formatType);
#endif //DEBUG
    
    [data getBytes:&contentSize range:contentSizeRange];
#ifdef DEBUG
    NSLog(@"Content Size: %u", contentSize);
#endif //DEBUG
    
    NSRange contentRange = { contentSizeRange.location + blockSize, contentSize };
    NSData * content = [data subdataWithRange:contentRange];
    
    id resultSet = nil;
    switch (formatType) {
        case PDFormatTypeImage:
            resultSet = [content imageFromData];
            break;
            
        case PDFormatTypeText:
            resultSet = [content stringFromData];
            break;
            
        case PDFormatTypeBoth:
            resultSet = content;
            break;
            
        default:
            NSLog(@"ERROR: Unknown format type %u", formatType);
            break;
    }
    
    return resultSet;
}

+ (NSString *)stringFromData:(NSData *)data
{
    return [data stringFromData];
}

+ (UIImage *)imageFromData:(NSData *)data
{
    return [data imageFromData];
}

+ (NSDictionary *)dictionaryFromData:(NSData *)data
{
    uint32_t blockSize = sizeof(uint32_t);
    NSUInteger textLength = 0;
    NSRange textLengthRange = { 0, blockSize };
    
    [data getBytes:&textLength range:textLengthRange];
    textLengthRange.location += blockSize;
    textLengthRange.length = textLength;
    NSString * text = [[data subdataWithRange:textLengthRange] stringFromData];
    
    NSRange imageRange = { textLengthRange.length + blockSize, 0 };
    imageRange.length = data.length - imageRange.location;
    UIImage * image = [[data subdataWithRange:imageRange] imageFromData];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:text, @"text", image, @"image", nil];
}

@end

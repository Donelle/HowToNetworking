//
//  PDStreamParser.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/* The format of the data being received */
typedef enum {
    PDFormatTypeText = 1,
    PDFormatTypeImage = 2,
    PDFormatTypeBoth = 3
} PDFormatType;


@interface PDStreamParser : NSObject

+ (id)parse:(NSData *)data;
+ (NSString *)stringFromData:(NSData *)data;
+ (UIImage *)imageFromData:(NSData *)data;
+ (NSDictionary *)dictionaryFromData:(NSData *)data;

@end

//
//  PDNotificationModel.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/3/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


typedef enum {
    PDNotificationTypeText = 100,
    PDNotificationTypeImage = 200,
    PDNotificationTypeBoth = 300
} PDNotificationType;


@interface PDNotificationModel : NSManagedObject

@property (nonatomic, retain) NSData * content;
@property (nonatomic) NSTimeInterval createDate;
@property (nonatomic) int16_t type;

@end

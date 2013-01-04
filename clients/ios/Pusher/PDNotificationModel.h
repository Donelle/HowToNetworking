//
//  PDNotificationModel.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
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

@property (nonatomic) int16_t type;
@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSDate * createDate;

@end

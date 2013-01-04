//
//  PDSettings.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PDNotificationOpenConnectionFailure @"OpenConnectionFailureNotification"
#define PDNotificationRecieveDataFailure  @"RecieveDataFailureNotification"


@interface PDSettings : NSObject

@property (readonly, nonatomic) NSString * listeningIPAddress;
@property (readonly, nonatomic) NSInteger listeningPort;


@end

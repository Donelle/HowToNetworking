//
//  PDRepository.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PDNotificationModel.h"

@interface PDRepository : NSObject

+ (PDRepository *)sharedInstance;

/*
 * Saves all the changes made to the repository
 */
- (BOOL)saveChanges;

/*
 * Responsible for storing data recieved from the server
 */
- (void)insertNotification:(id)notification;

/*
 * Responsible for deleting the notification
 */
- (void)deleteNotification:(PDNotificationModel *)notification;

/*
 * Creates a fetch controller
 */
- (NSFetchedResultsController *)createRepositoryController:(id<NSFetchedResultsControllerDelegate>)delegate;


@end

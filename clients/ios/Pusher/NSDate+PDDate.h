//
//  NSDate+PDDate.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/3/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PDDate)

/*
 * Formats the current date into a readable format string by Years,
 * Months, Weeks, Days, Hours, Minutes. i.e. 2yrs 10mos 1wk 4days 5hrs 17mins
 */
- (NSString *)formatDateByYearsMonthsWeeksDaysHoursMinutes;


@end

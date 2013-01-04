//
//  NSDate+PDDate.m
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/3/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import "NSDate+PDDate.h"

@implementation NSDate (PDDate)


- (NSString *)formatDateByYearsMonthsWeeksDaysHoursMinutes
{
    NSDate * dateSince1970 = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    NSDateComponents *components = [cal components:(units) fromDate:dateSince1970];
    
    NSMutableArray * formattedArray = [NSMutableArray array];
    if (components.year > 0) [formattedArray addObject:[NSString stringWithFormat:@"%iyrs", components.year]];
    if (components.month > 0) [formattedArray addObject:[NSString stringWithFormat:@"%imos", components.month]];
    if (components.week > 0) [formattedArray addObject:[NSString stringWithFormat:@"%iwks", components.week]];
    if (components.day > 0) [formattedArray addObject:[NSString stringWithFormat:@"%idays", components.day]];
    if (components.hour > 0) [formattedArray addObject:[NSString stringWithFormat:@"%ihrs", components.hour]];
    if (components.minute > 0) [formattedArray addObject:[NSString stringWithFormat:@"%imins", components.minute]];
    
    return [formattedArray componentsJoinedByString:@" "];
}


@end

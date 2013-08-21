//
//  NSDate+NSStringFormatting.h
//  Vibe-It
//
//  Created by Alexei on 08.02.13.
//  Copyright (c) 2013 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NAMAdditions)
- (NSString *)stringFromDateUsingFormat:(NSString *)dateFormat;
- (NSDateComponents *)datesDifferenceInUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date;
- (NSInteger)dayOfWeekInCalendar:(NSCalendar *)calendar;
- (NSDate *)dateWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes
            usingCalendar:(NSCalendar *)calendar;
- (BOOL)laterThen:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays;
- (NSDate *)zuluDateWithTimeString:(NSString *)timeString;
@end
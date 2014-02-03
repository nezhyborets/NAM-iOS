//
//  NSDate+NSStringFormatting.h
//  Vibe-It
//
//  Created by Alexei on 08.02.13.
//  Copyright (c) 2013 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kDefaultDateFormatIntervals;
FOUNDATION_EXPORT NSString *const kDefaultUSDateFormat;

@interface NSDate (NAMAdditions)
- (NSString *)stringUsingFormat:(NSString *)dateFormat;
- (NSString *)stringUsingFormat:(NSString *)dateFormat timeZoneAbbreviation:(NSString *)abbreviation;
- (NSDateComponents *)datesDifferenceInUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date;
- (NSInteger)dayOfWeekInCalendar:(NSCalendar *)calendar;
- (NSDate *)dateWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes
            usingCalendar:(NSCalendar *)calendar;
- (BOOL)laterThen:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)zuluDateWithTimeString:(NSString *)timeString;
@end
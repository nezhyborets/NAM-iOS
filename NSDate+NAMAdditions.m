//
//  NSDate+NSStringFormatting.m
//  Vibe-It
//
//  Created by Alexei on 08.02.13.
//  Copyright (c) 2013 Ora Interactive. All rights reserved.
//

#import "NSDate+NAMAdditions.h"

static NSDateFormatter *dateFormatter = nil;

@implementation NSDate (NAMAdditions)

- (NSString *)stringFromDateUsingFormat:(NSString *)dateFormat {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:self];
}

- (NSDateComponents *)datesDifferenceInUnit:(NSCalendarUnit)calendarUnit withDate:(NSDate *)date {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:calendarUnit startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:calendarUnit startDate:&toDate
                 interval:NULL forDate:date];
    
    NSDateComponents *difference = [calendar components:calendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return difference;
}

- (NSInteger)dayOfWeekInCalendar:(NSCalendar *)calendar {
    NSDateComponents *weekdayComponents =[calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSInteger weekday = [weekdayComponents weekday];
    return weekday;
}

- (NSDate *)zuluDateWithTimeString:(NSString *)timeString {
    NSString *hours = [timeString substringToIndex:2];
    NSString *minutes = [timeString substringFromIndex:2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    return [self dateWithHours:hours.integerValue minutes:minutes.integerValue usingCalendar:calendar];
}

- (NSDate *)dateWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes
            usingCalendar:(NSCalendar *)calendar {
    
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *dateComponents = [calendar components:NSUIntegerMax fromDate:self];
    
    dateComponents.hour = hours;
    dateComponents.minute = minutes;
    
    NSDate *returnDate = [calendar dateFromComponents:dateComponents];
    return returnDate;
}

- (BOOL)laterThen:(NSDate *)date {    
    return [self compare:date] == NSOrderedDescending;
}

- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponenets = [calendar components:NSUIntegerMax fromDate:self];
    dateComponenets.day += numberOfDays;
    return [calendar dateFromComponents:dateComponenets];
}
@end
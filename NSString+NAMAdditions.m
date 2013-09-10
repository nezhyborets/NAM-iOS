//
//  NSString+NAMAdditions.m
//  FlightLog
//
//  Created by Alexei on 31.05.13.
//
//

#import "NSString+NAMAdditions.h"

@implementation NSString (NAMAdditions)
- (NSString *)dateStringInFormat:(NSString *)newFormat currentFormat:(NSString *)currentFormat {
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.dateFormat = currentFormat;
    NSDate *date = [dateFormatter dateFromString:self];
    
    dateFormatter.dateFormat = newFormat;
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbers].location == NSNotFound);
}

- (BOOL)isFilled {
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ![trimmedString isEqualToString:@""];
}
@end

//
//  NSString+NAMAdditions.m
//  FlightLog
//
//  Created by Alexei on 31.05.13.
//
//

#import "NSString+NAMAdditions.h"

@implementation NSString (NAMAdditions)

static NSDateFormatter *dateFormatter;

- (BOOL)hasLetters {
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    return [self rangeOfCharacterFromSet:letterSet].location != NSNotFound;
}

- (BOOL)containsLettersOnly {
    BOOL lettersOnly = [[self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] isEqualToString:@""];
    return lettersOnly;
}

- (BOOL)containsDigitsOnly {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    BOOL digitsOnly = [[self stringByTrimmingCharactersInSet:characterSet] isEqualToString:@""];
    return digitsOnly;
}

- (NSDate *)dateUsingFormat:(NSString *)format {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }

    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:self];

    return date;
}

- (NSString *)dateStringInFormat:(NSString *)newFormat currentFormat:(NSString *)currentFormat {
    NSDate *date = [self dateUsingFormat:currentFormat];

    dateFormatter.dateFormat = newFormat;
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL)isFilled {
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ![trimmedString isEqualToString:@""];
}

- (CGFloat)compatibleHeightWithFont:(UIFont *)font width:(CGFloat)width {
    CGFloat height = 0;
    CGSize maxSize = CGSizeMake(width, 9999);
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil];
        height = rect.size.height;
    } else {
        CGSize size = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        height = size.height;
    }
    
    return ceilf(height);
}
@end

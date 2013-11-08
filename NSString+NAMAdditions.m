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
    
    NSLog(@"height %f",height);
    return ceilf(height);
}
@end

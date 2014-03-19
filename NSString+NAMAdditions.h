//
//  NSString+NAMAdditions.h
//  FlightLog
//
//  Created by Alexei on 31.05.13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (NAMAdditions)
- (BOOL)hasLetters;
- (BOOL)containsLettersOnly;
- (BOOL)containsDigitsOnly;
- (NSDate *)dateUsingFormat:(NSString *)format;
- (NSString *)dateStringInFormat:(NSString *)newFormat currentFormat:(NSString *)currentFormat;
- (BOOL)isFilled;
- (CGFloat)compatibleHeightWithFont:(UIFont *)font width:(CGFloat)width;
@end
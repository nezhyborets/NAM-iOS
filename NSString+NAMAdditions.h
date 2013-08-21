//
//  NSString+NAMAdditions.h
//  FlightLog
//
//  Created by Alexei on 31.05.13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (NAMAdditions)
- (NSString *)dateStringInFormat:(NSString *)newFormat currentFormat:(NSString *)currentFormat;
@end
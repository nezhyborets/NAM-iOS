//
//  NAMHelper.h
//  Vibe-It
//
//  Created by Alexei on 13.09.12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILabel+NAMAdditions.h"

typedef enum {
    NAMCheckStringReturnTypeNil,
    NAMCheckStringReturnTypeEmptyString
} NAMCheckStringReturnType;

typedef void (^nam_voidCompletionBlock)(void);
typedef void (^nam_integerCompletionBlock)(NSInteger intValue);

@interface NAMHelper : NSObject

#warning DEBUG
#define DEBUG 1

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


//Paths
NSString* documentsPath();

//String
NSString* nam_trimString (NSString *inputStr);
NSString *nam_checkString (id object);
NSString* nam_checkStringWithType (NSString *string, NAMCheckStringReturnType returnType);
NSString* nam_stringExistsAndFilled (id object);
BOOL nam_stringExistsAndFilledBool (id object);
+ (NSString *)addressWithCity:(NSString *)city state:(NSString *)state zip:(NSString *)zip;

//Dispatching
void nam_dispatchOnQueue (NSString *queueName, void (^block)(void));

//Color
UIColor* nam_colorWithRGBA (CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

//Date
+ (NSString *)formattedDateStringFromString:(NSString *)inputString oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat;
+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)dateFormatInString;
+ (NSString *)stringFromDate:(NSDate *)date usingFormatString:(NSString *)formatString;

//Network
+ (NSDictionary *)dictionaryByUrlParams:(NSURL *)url;
+ (NSURL *)urlByCheckingPrefix:(NSString *)originalUrlString baseUrl:(NSString *)baseUrl;

//Validation
BOOL emailIsValid (NSString *candidate);
+ (BOOL) validateDigits:(NSString *)candidate numberOfDigits:(NSUInteger)numberOfDigits;
+ (BOOL)passwordIsValid:(NSString *)password minimumLenght:(NSUInteger)minimumLenght;

//Array
+ (NSArray *)safelyAddObject:(id)object toArray:(NSArray *)array;
+ (NSArray *)nonRepeatingFirstLettersArrayFromStringsArray:(NSArray *)array;
+ (NSArray *)alphabeticallySortedArray:(NSArray *)array ascending:(BOOL)ascending key:(NSString *)key;

//Label
+ (UILabel *)adjustLabel:(UILabel *)label forString:(NSString *)string width:(CGFloat)width;

//Views
+ (CGRect)frameForAddingViewBelowView:(UIView *)topView toView:(UIView *)superview;

//Keyboard
+ (CGRect)keyboardFrameForNotification:(NSNotification *)notification forView:(UIView *)view;
@end
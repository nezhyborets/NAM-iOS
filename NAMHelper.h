//
//  NAMHelper.h
//  Vibe-It
//
//  Created by Alexei on 13.09.12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NAMCheckStringReturnTypeNil,
    NAMCheckStringReturnTypeEmptyString
} NAMCheckStringReturnType;

typedef void (^nam_voidCompletionBlock)(void);
typedef void (^nam_integerCompletionBlock)(NSInteger intValue);
typedef void (^ArrayRequestCompletion)(NSArray *items, NSError *error);
typedef void (^ImageDownloadBlock)(UIImage *image, NSError *error);
typedef void (^ErrorCompletion)(NSError *error);

FOUNDATION_EXPORT NSString *const kUserNotAuthorizedErrorNotification;
FOUNDATION_EXPORT NSString *const kNotificationErrorKey;
FOUNDATION_EXPORT NSString *const kNotificationDataKey;
FOUNDATION_EXPORT NSString *const NAMErrorStatusCode;
FOUNDATION_EXPORT NSString *const NAMErrorCustomCode;

typedef NS_ENUM(NSUInteger, ShapeType) {
    CECodeDataFormat = 1,
    CECodeNotLoggedIn,
    CECodeStoredApiKey,
    CECodeEmailAlreadyTaken,
    CECodeWrongPassword,
    CECodeFacebookPermissions,
    CECodeFacebookCancelled,
    CECodeChangeIsNotMade,
    CECodeObjectNotFound,
    CECodeAccountSuspended,
    CECodeUserFeedback
};

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface NAMHelper : NSObject

#ifdef DEBUG
#define DLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

NSString *appErrorDomain(void);
NSString *namErrorDomain(void);
void errorAlert(NSString *text);
void errorAlertOverKeyboard(NSString *text);
void errorAlertInController(NSString *text, UIViewController *controller);
+ (void)errorAlert:(NSString *)text;
void infoAlert(NSString *text);
NSError *nam_unknownError(NSString *someExplanation);
NSDictionary *nam_userInfoWithError(NSError *error);


BOOL smallScreen(void);
BOOL mediumScreen(void);
BOOL iOS8(void);

//UIView
void nam_setViewEnabled(UIView *view, BOOL enabled);

//String
NSString *nam_addS(NSString *string, NSInteger count);
NSString *nam_trimString(NSString *inputStr);
NSString *nam_checkString(id object);
NSString *nam_checkStringWithType(id object, NAMCheckStringReturnType returnType);
NSString *nam_stringExistsAndFilled(id object);
BOOL nam_stringExistsAndFilledBool(id object);

+ (NSString *)fullNameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
+ (NSString *)addressWithCity:(NSString *)city state:(NSString *)state zip:(NSString *)zip;

//Paths
NSString *documentsPath(void);

//Dispatching
void nam_dispatchOnQueue(NSString *queueName, void (^block)(void));
void nam_dispatchAfter(double seconds, dispatch_block_t block);

//Color
UIColor *nam_colorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

//Date
+ (NSString *)formattedDateStringFromString:(NSString *)inputString oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat;
+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)dateFormatInString;
+ (NSString *)stringFromDate:(NSDate *)date usingFormatString:(NSString *)formatString;

//Network
+ (NSDictionary *)dictionaryByUrlParams:(NSURL *)url;
+ (NSURL *)urlByCheckingPrefix:(NSString *)originalUrlString baseUrl:(NSString *)baseUrl;

//Validation
BOOL emailIsValid(NSString *candidate);
+ (BOOL)validateDigits:(NSString *)candidate numberOfDigits:(NSUInteger)numberOfDigits;
+ (BOOL)validateDigits:(NSString *)candidate;
+ (BOOL)passwordIsValid:(NSString *)password minimumLenght:(NSUInteger)minimumLenght;

+ (NSArray *)arrayByAddingObject:(id)object toArray:(NSArray *)array;
+ (NSArray *)arrayByRemovingObject:(id)object fromArray:(NSArray *)array;
//Array
+ (NSArray *)nonRepeatingFirstLettersArrayFromStringsArray:(NSArray *)array;
+ (NSArray *)alphabeticallySortedArray:(NSArray *)array ascending:(BOOL)ascending key:(NSString *)key;

//Views
+ (CGRect)frameForAddingViewBelowView:(UIView *)topView toView:(UIView *)superview;

//Keyboard
+ (CGRect)keyboardFrameForNotification:(NSNotification *)notification forView:(UIView *)view;

+ (void)reloadTableHeaderOrFooterViewWithDynamicHeight:(UIView *)view width:(CGFloat)width;
@end

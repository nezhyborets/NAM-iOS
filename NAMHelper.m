//
//  NAMHelper.m
//  Vibe-It
//
//  Created by Alexei on 13.09.12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import "NAMHelper.h"

NSString *const kUserNotAuthorizedErrorNotification = @"kUserNotAuthorizedErrorNotification";
NSString *const kNotificationErrorKey = @"kNotificationErrorKey";
NSString *const kNotificationDataKey = @"kNotificationDataKey";
NSString *const NAMErrorStatusCode = @"kErrorStatusCode";
NSString *const NAMErrorCustomCode = @"kErrorCustomCode";

@implementation NAMHelper

#pragma mark - Misc

NSError *nam_unknownError(NSString *someExplanation) {
    return [NSError errorWithDomain:appErrorDomain() code:CECodeDataFormat userInfo:@{NSLocalizedDescriptionKey : someExplanation}];
}

NSDictionary *nam_userInfoWithError(NSError *error) {
    NSDictionary *dict = nil;
    if (error) {
        dict = @{kNotificationErrorKey : error};
    }

    return dict;
};

void nam_setViewEnabled(UIView *view, BOOL enabled) {
    view.alpha = enabled ? 1 : 0.5;
    view.userInteractionEnabled = enabled;
};

NSString *appErrorDomain() {
    return [[NSBundle mainBundle] bundleIdentifier] ?: @"defaultDomain";
}

NSString *namErrorDomain() {
    return @"NAMCustomErrorDomain";
}

NSString *nam_addS(NSString *string, NSInteger count) {
    if (count != 1) {
        string = [string stringByAppendingString:@"s"];
    }

    return string;
};

NSMutableArray *_displayedErrors;

void errorAlert(NSString *text) {
    if (!_displayedErrors) {
        _displayedErrors = [[NSMutableArray alloc] init];
    }

    if (text == nil) {
        text = @"Unknown error. errorAlert() function called without parameter";
    }

    if ([_displayedErrors containsObject:text]) {
        return;
    }

    [_displayedErrors addObject:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_displayedErrors removeObject:text];
    });

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)errorAlert:(NSString *)text {
    errorAlert(text);
}

NSString *_infoAlertTitle;
+ (void)setInfoAlertTitle:(NSString *)infoAlertTitle {
    _infoAlertTitle = infoAlertTitle;
}

void infoAlert(NSString *text) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_infoAlertTitle message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

BOOL iOS8() {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}

BOOL smallScreen() {
    return [UIScreen mainScreen].bounds.size.height < 500;
}

NSString *documentsPath(void) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = nil;
    documentsPath = paths[0];
    return documentsPath;
}

#pragma mark - Dispatching

void nam_dispatchOnQueue(NSString *queueName, void (^block)(void)) {
    dispatch_queue_t dispatchQueue = dispatch_queue_create([queueName UTF8String], NULL);
    dispatch_async(dispatchQueue, block);
}

void nam_dispatchAfter(double seconds, dispatch_block_t block) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (seconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - Colors

UIColor *nam_colorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

#pragma mark - Strings

NSString *nam_trimString(NSString *inputStr) {
    if ([inputStr isKindOfClass:[NSString class]]) {
        return [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return inputStr;
}

NSString *nam_checkString(id object) {
    return nam_stringExistsAndFilled(object);
}

NSString *nam_checkStringWithType(id object, NAMCheckStringReturnType returnType) {
    if (object && [object isKindOfClass:[NSString class]]) {
        NSString *returnValueIfFail = returnType == NAMCheckStringReturnTypeNil ? nil : @"";
        if ([nam_trimString((NSString *) object) isEqualToString:@""]) {
            return returnValueIfFail;
        }
        return object;
    }
    return nil;
}

NSString *nam_stringExistsAndFilled(id object) {
    if (object && [object isKindOfClass:[NSString class]]) {
        NSString *trimmedString = nam_trimString((NSString *) object);
        if ([trimmedString isEqualToString:@""]) {
            return nil;
        }
        
        return trimmedString;
    }
    return nil;
}

BOOL nam_stringExistsAndFilledBool(id object) {
    if (object && [object isKindOfClass:[NSString class]]) {
        if ([nam_trimString((NSString *) object) isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURL *)urlByCheckingPrefix:(NSString *)originalUrlString baseUrl:(NSString *)baseUrl {
    NSURL *url = nil;

    if ([originalUrlString hasPrefix:@"http://"]) {
        url = [NSURL URLWithString:originalUrlString];
    } else {
        NSString *newUrlString = [NSString stringWithFormat:@"%@%@", baseUrl, originalUrlString];
        url = [NSURL URLWithString:newUrlString];
    }

    return url;
}

+ (NSString *)addressWithCity:(NSString *)city state:(NSString *)state zip:(NSString *)zip {
    NSMutableString *string = nam_stringExistsAndFilled(city) ? [NSMutableString stringWithString:city] : [NSMutableString string];
    if (nam_stringExistsAndFilled(string) && (nam_stringExistsAndFilled(state) || nam_stringExistsAndFilled(zip))) {
        [string appendString:@", "];
    }

    if (nam_stringExistsAndFilled(state) && nam_stringExistsAndFilled(zip)) {
        [string appendFormat:@"%@ %@", state, zip];
    } else if (nam_stringExistsAndFilled(state)) {
        [string appendString:state];
    } else if (nam_stringExistsAndFilled(zip)) {
        [string appendString:zip];
    }

    return string;
}

+ (NSString *)fullNameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (firstName) {
        [array addObject:firstName];
    }
    
    if (lastName) {
        [array addObject:lastName];
    }
    
    return [array count] ? [array componentsJoinedByString:@" "] : nil;
}

#pragma mark - Date

+ (NSString *)formattedDateStringFromString:(NSString *)inputString oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:oldFormat];
    NSDate *date = [dateFormatter dateFromString:inputString];
    [dateFormatter setDateFormat:newFormat];
    NSString *formattedString = [dateFormatter stringFromDate:date];

    return formattedString;
}

+ (NSString *)stringFromDate:(NSDate *)date usingFormatString:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
};

+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)dateFormatInString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatInString];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

#pragma mark - Validation

BOOL emailIsValid(NSString *candidate) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validateDigits:(NSString *)candidate numberOfDigits:(NSUInteger)numberOfDigits {
    NSString *digitsRegex = [NSString stringWithFormat:@"[0-9]{%lu}", (unsigned long) numberOfDigits];
    NSPredicate *candidateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", digitsRegex];

    return [candidateTest evaluateWithObject:candidate];
}

+ (BOOL)validateDigits:(NSString *)candidate {
    NSString *digitsRegex = [NSString stringWithFormat:@"[0-9]"];
    NSPredicate *candidateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", digitsRegex];

    return [candidateTest evaluateWithObject:candidate];
}

+ (BOOL)passwordIsValid:(NSString *)password minimumLenght:(NSUInteger)minimumLenght {

    // 1. Upper case.
//    if (![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[password characterAtIndex:0]])
//        return NO;

    // 2. Length.
    if ([password length] < minimumLenght)
        return NO;

    // 3. Special characters.
    // Change the specialCharacters string to whatever matches your requirements.
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!#€%&/()[]=?$§*'"];

    if ([password rangeOfCharacterFromSet:set].location != NSNotFound) {
        return NO;
    }

    // 4. Numbers.
//    if ([[password componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2)
//        return NO;

    return YES;
}

#pragma mark - working with URL

+ (NSDictionary *)dictionaryByUrlParams:(NSURL *)url {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];

    NSString *urlString = [url absoluteString];

    NSString *tempKey;
    NSString *tempValue;

    NSScanner *scanner = [NSScanner scannerWithString:urlString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"?=&"]];
    [scanner scanUpToString:@"?" intoString:nil];       //ignore the beginning of the string and skip to the vars

    while ([scanner scanUpToString:@"=" intoString:&tempKey]) {
        [keys addObject:[tempKey copy]];

        if ([scanner scanUpToString:@"&" intoString:&tempValue]) {
            [values addObject:[tempValue copy]];
        } else {
            NSString *restOfString = [[scanner string] substringFromIndex:[scanner scanLocation]];
            [values addObject:restOfString];
        };
    }

    [scanner setScanLocation:0];

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    return dictionary;
}

#pragma mark - Arrays

+ (NSArray *)arrayByAddingObject:(id)object toArray:(NSArray *)array {
    NSMutableArray *mutableArray = [array mutableCopy];
    if (!mutableArray) {
        mutableArray = [[NSMutableArray alloc] init];
    }

    [mutableArray addObject:object];
    return [mutableArray copy];
}

+ (NSArray *)arrayByRemovingObject:(id)object fromArray:(NSArray *)array {
    NSMutableArray *mutableArray = [array mutableCopy];
    if (!mutableArray) {
        mutableArray = [[NSMutableArray alloc] init];
    }

    [mutableArray removeObject:object];
    return [mutableArray copy];
}

+ (NSArray *)nonRepeatingFirstLettersArrayFromStringsArray:(NSArray *)array {
    NSMutableArray *lettersArray = [[NSMutableArray alloc] init];

    for (NSString *string in array) {
        NSString *firstLetter = [string substringToIndex:1];

        if ([lettersArray indexOfObject:firstLetter] == NSNotFound) {
            [lettersArray addObject:firstLetter];
        }
    }

    return lettersArray;
}

+ (NSArray *)alphabeticallySortedArray:(NSArray *)array ascending:(BOOL)ascending key:(NSString *)key {
    NSArray *alphabeticallySortedArray = nil;

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    alphabeticallySortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];

    return alphabeticallySortedArray;
}

#pragma mark - Views
+ (CGRect)frameForAddingViewBelowView:(UIView *)topView toView:(UIView *)superview {
    CGFloat topViewLowestY = topView.frame.origin.y + topView.frame.size.height;
    return CGRectMake(0, topViewLowestY, superview.bounds.size.width, superview.bounds.size.height - topViewLowestY);
}

#pragma mark - Keyboard

+ (CGRect)keyboardFrameForNotification:(NSNotification *)notification forView:(UIView *)view {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGRect keyboardFrameConverted = [view convertRect:keyboardFrame fromView:window];
    return keyboardFrameConverted;
}

+ (void)reloadTableHeaderOrFooterViewWithDynamicHeight:(UIView *)view width:(CGFloat)width {
    NSParameterAssert(width);
    NSParameterAssert(view);
    
    view.frame = CGRectMake(0, 0, width, 10000);
    view.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    constraint.active = YES;

    [view setNeedsLayout];
    [view layoutIfNeeded];

    CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    constraint.active = NO;

    //update the header's frame and set it again
    CGRect headerFrame = view.frame;
    headerFrame.size.height = height;
    headerFrame.size.width = width;
    view.frame = headerFrame;

    view.translatesAutoresizingMaskIntoConstraints = YES;
}

@end
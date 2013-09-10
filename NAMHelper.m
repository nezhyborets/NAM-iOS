//
//  NAMHelper.m
//  Vibe-It
//
//  Created by Alexei on 13.09.12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import "NAMHelper.h"

@implementation NAMHelper

NSString *documentsPath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = nil;
    documentsPath = paths[0];
    return documentsPath;
}

#pragma mark - Dispatching
void nam_dispatchOnQueue (NSString *queueName, void (^block)(void)) {
    dispatch_queue_t dispatchQueue = dispatch_queue_create([queueName UTF8String], NULL);
    dispatch_async(dispatchQueue, block);
    dispatch_release(dispatchQueue);
}

#pragma mark - Colors
UIColor* nam_colorWithRGBA (CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

#pragma mark - Strings
NSString* nam_trimString (NSString *inputStr) {
    if ([inputStr isKindOfClass:[NSString class]]) {
        return [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return inputStr;
}

NSString *nam_checkString (id object) {
    return nam_stringExistsAndFilled(object);
}

NSString* nam_checkStringWithType (id object, NAMCheckStringReturnType returnType) {
    if (object && [object isKindOfClass:[NSString class]]) {
        NSString *returnValueIfFail = returnType == NAMCheckStringReturnTypeNil ? nil : @"";
        if ([nam_trimString((NSString *)object) isEqualToString:@""]) {
            return returnValueIfFail;
        }
        return object;
    }
    return nil;
}

NSString* nam_stringExistsAndFilled (id object) {
    if (object && [object isKindOfClass:[NSString class]]) {
        if ([nam_trimString((NSString *)object) isEqualToString:@""]) {
            return nil;
        }
        return object;
    }
    return nil;
}

BOOL nam_stringExistsAndFilledBool (id object) {
    if (object && [object isKindOfClass:[NSString class]]) {
        if ([nam_trimString((NSString *)object) isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURL *)urlByCheckingPrefix:(NSString *)originalUrlString baseUrl:(NSString *)baseUrl{
    NSURL *url = nil;
    
    if ([originalUrlString hasPrefix:@"http://"]){
        url = [NSURL URLWithString:originalUrlString];
    } else {
        NSString *newUrlString = [NSString stringWithFormat:@"%@%@",baseUrl,originalUrlString];
        url = [NSURL URLWithString:newUrlString];
    }
    
    return url;
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

+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)dateFormatInString  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatInString];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

#pragma mark - Validation
BOOL emailIsValid (NSString *candidate) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) validateDigits:(NSString *)candidate numberOfDigits:(NSUInteger)numberOfDigits {
    NSString *digitsRegex = [NSString stringWithFormat:@"[0-9]{%i}",numberOfDigits]; 
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
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"!#€%&/()[]=?$§*'"];
    
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
+ (NSArray *)safelyAddObject:(id)object toArray:(NSArray *)array {
    NSMutableArray *mutableArray = [array mutableCopy];
    [mutableArray addObject:object];
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

+ (NSArray *)alphabeticallySortedArray:(NSArray *)array ascending:(BOOL)ascending key:(NSString *)key{
    NSArray *alphabeticallySortedArray = nil;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    alphabeticallySortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    return alphabeticallySortedArray;
}

#pragma mark - Views
+ (UILabel *)adjustLabel:(UILabel *)label forString:(NSString *)string width:(CGFloat)width {
    CGSize maxSize = CGSizeMake(width, 9999);
    CGSize size = [string sizeWithFont:label.font constrainedToSize:maxSize];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = size.height;
    label.frame = newFrame;

    return label;
}

+ (CGRect)frameForAddingViewBelowView:(UIView *)topView toView:(UIView *)superview {
    return CGRectMake(0, topView.lowestY, superview.bounds.size.width, superview.bounds.size.height - topView.lowestY);
}

#pragma mark - Keyboard
+ (CGRect)keyboardFrameForNotification:(NSNotification *)notification forView:(UIView *)view {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    CGRect keyboardFrameConverted = [view convertRect:keyboardFrame fromView:window];
    return keyboardFrameConverted;
}

@end
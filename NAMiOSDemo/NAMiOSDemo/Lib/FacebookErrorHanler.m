//
//  FacebookErrorHanler.m
//  NewFacebook
//
//  Created by Evgeniy Gurtovoy on 9/13/12.
//  Copyright (c) 2012 Evgeniy Gurtovoy. All rights reserved.
//

#import "FacebookErrorHanler.h"

@interface FacebookErrorHanler()
- (void)showErrorMessageForFBErrorCode:(NSInteger)errorCode;
@end

@implementation FacebookErrorHanler

+ (FacebookErrorHanler *)sharedHandler
{
    static FacebookErrorHanler *_sharedHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHandler = [[FacebookErrorHanler alloc] init];
    });
    return _sharedHandler;
}

- (void)handleError:(NSError *)fbError {
    NSDictionary *errorInfo = fbError.userInfo;
    BOOL unknownError = YES;
    NSInteger errorCode = 0;
    if (errorInfo) {
        if ([errorInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]) {
            NSDictionary *JSONResponseKey = [errorInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"];
            if ([JSONResponseKey objectForKey:@"body"]) {
                NSDictionary *body = [JSONResponseKey objectForKey:@"body"];
                if (body) {
                    NSDictionary *error = [body objectForKey:@"error"];
                    errorCode = [[error objectForKey:@"code"] integerValue];
                    unknownError = NO;
                }
            }
        }
    }
    if (unknownError) {
        [self showErrorMessageForFBErrorCode:-1];
    } else {
        [self showErrorMessageForFBErrorCode:errorCode];
    }
}

- (void)showErrorMessageForFBErrorCode:(NSInteger)errorCode {
    NSString *message = nil;
    switch (errorCode) {
        case -1: {
            message = @"Error occurred...";
        }
            break;
        case 200: {
            message = @"The user hasn't authorized the application to perform this action.";
        }
            break;
        case 506: {
            message = @"Duplicate message.";
        }
            break;
        case 190: {
            message = @"User has not authorized application.";
        }
            break;
        default: {
            message = @"Error occurred...";
        }
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Error" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

@end

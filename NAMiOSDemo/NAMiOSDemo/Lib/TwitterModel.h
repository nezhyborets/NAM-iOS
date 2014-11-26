//
//  TwitterModel.h
//  Vibe-It
//
//  Created by Evgeniy Gurtovoy on 9/21/12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
@interface TwitterModel : NSObject
+ (void)sendTweetWithText:(NSString *)text icon:(UIImage *)anImage url:(NSString *)anUrl imageURL:(NSString *)imageURL presentFrom:(UIViewController *)vc;
+ (void)sendTweetWithText:(NSString *)text url:(NSString *)anUrl presentFrom:(UIViewController *)vc;
+ (void)getTwitterInfo:(void (^)(NSDictionary *resultDict, UIImage *profileImage))resultBlock;
+ (void)isUserLoggedIn:(void (^)(BOOL isLogged))resultBlock showUIMessage:(BOOL)showUIMessage;
+ (void)sendTweetWithOutUI:(NSString *)tweetMessage;
@end
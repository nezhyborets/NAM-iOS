//
//  TwitterModel.m
//  Vibe-It
//
//  Created by Evgeniy Gurtovoy on 9/21/12.
//  Copyright (c) 2012 Ora Interactive. All rights reserved.
//

#import "TwitterModel.h"


@implementation TwitterModel

#define kGetUserInfoURLFormat @"http://api.twitter.com/1.1/users/show.json?screen_name=%@&include_entities=false"
#define kUserImageURLFormat   @"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=original"
#define kTweetURLFormat       @"https://api.twitter.com/1/statuses/update.json"

+ (void)sendTweetWithText:(NSString *)text url:(NSString *)anUrl presentFrom:(UIViewController *)vc {
    [TwitterModel sendTweetWithText:text icon:nil url:anUrl imageURL:nil presentFrom:vc];
}

+ (void)sendTweetWithText:(NSString *)text icon:(UIImage *)anImage url:(NSString *)anUrl imageURL:(NSString *)imageURL presentFrom:(UIViewController *)vc {
        TWTweetComposeViewController *twitterVC = [[TWTweetComposeViewController alloc] init];
        
        if (anImage != nil) {
            [twitterVC addImage:anImage];
        } else if (imageURL != nil) {
            [twitterVC addURL:[NSURL URLWithString:imageURL]];
        }
        
        [twitterVC addURL:[NSURL URLWithString:anUrl]];
        [twitterVC setInitialText:text];
        
        [twitterVC setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    DLog(@"Twitter Result: canceled");
                    break;
                case TWTweetComposeViewControllerResultDone: {
                    DLog(@"Twitter Result: sent");
                    //[NotificationView showMessage:@"Tweet has been sent..." fromView: vc.view];
                }
                    break;
                default:
                    DLog(@"Twitter Result: default");
                    break;
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [vc presentViewController:twitterVC animated:YES completion:^{}];
}

+ (void)isUserLoggedIn:(void (^)(BOOL isLogged))resultBlock showUIMessage:(BOOL)showUIMessage {
    if (![TWTweetComposeViewController canSendTweet]){
        if (showUIMessage) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"There are currently no Twitter accounts configured. You can add or create a Twitter account in your device's settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            });
        }
        resultBlock(NO);
        return;
    }
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //Create block
    void (^completition)(BOOL, NSError*) = ^(BOOL granted, NSError *error) {
        if (!granted && showUIMessage) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Access to twitter accounts is blocked, please enable access in Settings to use this feature"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
                [alert show];
            });
        }
        resultBlock(granted);
    };
    [account requestAccessToAccountsWithType:accountType
                       withCompletionHandler:completition];
    
}

+ (void)sendTweetWithOutUI:(NSString *)tweetMessage {
    DLog(@"tweetMessage - %@", tweetMessage);
    if (!tweetMessage.length) return;
    
    if (![TWTweetComposeViewController canSendTweet]){
        
        dispatch_async(dispatch_get_main_queue(),^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts" message:@"There are no twitter accounts configured. You can add or create a Twitter account in Settings." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        });
        return;
    }
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //Create block
    void (^completition)(BOOL, NSError*) = ^(BOOL granted, NSError *error){
        if (granted == YES) {
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0) {
                //Get first avaliable account
                ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                
                //Create a request
                id request;
                NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:tweetMessage, @"status", nil];
                
                request=[[TWRequest alloc] initWithURL:[NSURL URLWithString:kTweetURLFormat] parameters:params requestMethod:TWRequestMethodPOST];
                [(TWRequest *)request setAccount:acct];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if ([urlResponse statusCode] == 200) {
                        //NSError *anError;
                        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&anError];
                        //NSLog(@"Twitter dict is %@", dict);
                        
                    } else {
                        DLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
                        DLog(@"%@",urlResponse);
                        DLog(@"Twitter error, %@", [error description]);
                        DLog(@"%@",error);
                        DLog(@"response %@",[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
                    }
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"No twitter accounts found, please signup for Twitter in Settings.app"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:nil];
                    [alert show];
                });
                
                DLog(@"NO accounts error");
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Access to twitter accounts is blocked, please enable access in Settings to use this feature"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
                [alert show];
                DLog(@"No right");
            });
            //Maybe return block here with null values?
            //Or other error block even better?
        }
    };
    
    if ([account respondsToSelector:@selector(requestAccessToAccountsWithType:withCompletionHandler:)]) {
        [account requestAccessToAccountsWithType:accountType
                           withCompletionHandler:completition];
    } else {
        DLog(@"Wrong iOS version");
    }
}



+ (void)getTwitterInfo:(void (^)(NSDictionary *resultDict, UIImage *profileImage))resultBlock {
    
    //depricated in ios6 but let's keept for now (ios5 way)
    if (![TWTweetComposeViewController canSendTweet]){
        
        dispatch_async(dispatch_get_main_queue(),^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts" message:@"There are no twitter accounts configured. You can add or create a Twitter account in Settings." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        });
        return;
    }
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //Create block
    void (^completition)(BOOL, NSError*) = ^(BOOL granted, NSError *error){
        if (granted == YES) {
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0) {
                //Get first avaliable account
                ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                
                //Generate request string
                NSString *requestString = [NSString stringWithFormat:kGetUserInfoURLFormat, acct.username];
                
                //Create a request
                id request;
                request=[[TWRequest alloc] initWithURL:[NSURL URLWithString:requestString] parameters:nil requestMethod:TWRequestMethodGET];
                [(TWRequest *)request setAccount:acct];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if ([urlResponse statusCode] == 200) {
                        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                        
                        NSError *anError;
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&anError];
                        
                        DLog(@"Twitter dict is %@", dict);
                        
                        if ([dict objectForKey:@"name"] && [[dict objectForKey:@"name"] isKindOfClass:[NSString class]])
                            [infoDict setObject:[dict objectForKey:@"name"] forKey:@"name"];
                        
                        if ([dict objectForKey:@"location"] && [[dict objectForKey:@"location"] isKindOfClass:[NSString class]]) {
                            [infoDict setObject:[dict objectForKey:@"location"] forKey:@"location"];
                        }
                        
                        //Update data and wait for image
                        resultBlock(infoDict, nil);
                        
                        NSString *photoURL = [NSString stringWithFormat:kUserImageURLFormat, acct.username];
                        NSString *imageUrl = [dict objectForKey:@"profile_image_url"];
                        if (imageUrl != nil && [imageUrl isKindOfClass:[NSString class]]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    resultBlock(infoDict, image);
                                });
                            });
                        }
                    } else {
                        DLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
                        DLog(@"Twitter error, %@", [error description]);
                        
                    }
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"No twitter accounts found, please signup for Twitter in Settings.app"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:nil];
                    [alert show];
                });
                
                DLog(@"NO accounts error");
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Access to twitter accounts is blocked, please enable access in Settings to use this feature"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
                [alert show];
                DLog(@"No right");
            });
            //Maybe return block here with null values?
            //Or other error block even better?
        }
    };
    
    if ([account respondsToSelector:@selector(requestAccessToAccountsWithType:withCompletionHandler:)]) {
        [account requestAccessToAccountsWithType:accountType
                           withCompletionHandler:completition];
    } else {
        DLog(@"Wrong iOS version");
    }
}

@end

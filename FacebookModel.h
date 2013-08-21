//
//
//  NewFacebook
//
//  Created by Evgeniy Gurtovoy on 9/13/12.
//  Copyright (c) 2012 Evgeniy Gurtovoy. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#define kFacebookNotLoggedInAlert_Tag 2
#define kFacebookDidLoginSuccessfullyAlert_Tag 3

typedef void (^FBLoginResultsHandler) (BOOL facebookDidLogin);
typedef void (^FBReauthorizeResultHandler) (BOOL facebookDidReauthorize, NSError *error);
typedef void (^FBUserDetailsProcessor) (NSDictionary *userDetails, NSError *error);
typedef void (^FBPostToWallResultsHandler) (BOOL facebookDidPosted);

@interface FacebookModel : NSObject

//Public API
+ (FacebookModel *)sharedModel;
- (void)logout;
- (NSString *)fbToken;
- (BOOL)isLoggedIn;
- (BOOL)isLoggedInAfterOpenAttempt;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)handleDidBecomeActive;
- (void)getReadyToWallPost:(void (^)(BOOL readyToPost, NSString *error))completionBlock;

- (void)attemptOpenWritePermissionsWithTryToRelogin:(BOOL)tryToRelogin completionBlock:(FBReauthorizeResultHandler)handler;
- (void)attemptLoginWithUI:(BOOL)allowLoginUI resultsHandler:(FBLoginResultsHandler)loginResultsHandler;
- (void)userDetailsProcessedBy:(FBUserDetailsProcessor)userDetailsProcessor;
- (void)postToWallWithResultsHandler:(FBPostToWallResultsHandler)postToWallHandler
                         andPostDict:(NSDictionary *)postDict;

+ (void)synchronizeSystemAndServerAccountsWithCompletionBlock:(nam_voidCompletionBlock)block;


@end
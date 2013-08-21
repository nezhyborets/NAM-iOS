//
//  FacebookModel.m
//  NewFacebook
//
//  Created by Evgeniy Gurtovoy on 9/13/12.
//  Copyright (c) 2012 Evgeniy Gurtovoy. All rights reserved.
//

#import "FacebookModel.h"
#import "FacebookErrorHanler.h"
#import <Accounts/Accounts.h>
#import "NAMAlertViewBlock.h"

@interface FacebookModel ()
@property (strong, nonatomic) FBRequestConnection *requestConnection;
@property (strong, nonatomic) FBLoginResultsHandler loginResultsHandler;
@property (strong, nonatomic) FBUserDetailsProcessor userDetailsProcessor;
@property (strong, nonatomic) FBPostToWallResultsHandler postToWallResultsHandler;

- (BOOL)isSessionStateEffectivelyLoggedIn:(FBSessionState)state;
@end

@implementation FacebookModel
+ (FacebookModel *)sharedModel
{
    static FacebookModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[FacebookModel alloc] init];
    });
    return _sharedModel;
}

#pragma mark - Public API

- (NSString *)fbToken {
    return FBSession.activeSession.accessTokenData.accessToken;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)handleDidBecomeActive {
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)getReadyToWallPost:(void (^)(BOOL readyToPost, NSString *error))completionBlock {
    void (^notLoggedInAlertCompletion)(BOOL, NSInteger) = ^(BOOL cancelled, NSInteger buttonIndex){
        if (buttonIndex == 1) {
            [[FacebookModel sharedModel] attemptLoginWithUI:YES resultsHandler:^(BOOL facebookDidLogin) {
                if (facebookDidLogin) {
                    void (^loggedInSuccesfullyAlertCompletion)(BOOL, NSInteger) = ^(BOOL cancelled, NSInteger buttonIndex) {
                        [[FacebookModel sharedModel] attemptOpenWritePermissionsWithTryToRelogin:YES completionBlock:^(BOOL didReauthorize, NSError *error){
                            if (completionBlock) {
                                if (!error) {
                                    completionBlock(didReauthorize, nil);
                                } else {
                                    completionBlock(NO,error.localizedDescription);
                                }
                            }
                        }];
                    };
                    
                    NAMAlertViewBlock *alert = [[NAMAlertViewBlock alloc] initWithTitle:kAppAlertTitle
                                                                                message:@"Logged in successfully."
                                                                             completion:loggedInSuccesfullyAlertCompletion
                                                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                } else {
                    if (completionBlock) {
                        completionBlock(NO, @"Login failed");
                    }
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(NO, nil);
            }
        }
    };
    if ([[FacebookModel sharedModel] isLoggedIn]) {
        [[FacebookModel sharedModel] attemptOpenWritePermissionsWithTryToRelogin:YES completionBlock:^(BOOL facebookDidReauthorize, NSError *error) {
            if (!facebookDidReauthorize) {
                [[FacebookModel sharedModel] logout];
                NAMAlertViewBlock *alertView = [[NAMAlertViewBlock alloc] initWithTitle:@"Facebook"
                                                                                message:@"Please reauthorize Facebook to perform this action."
                                                                             completion:notLoggedInAlertCompletion
                                                                      cancelButtonTitle:@"Cancel"
                                                                      otherButtonTitles:@"Reauthorize"];
                [alertView show];
            } else {
                if (completionBlock) {
                    if (!error) {
                        completionBlock(facebookDidReauthorize, nil);
                    } else {
                        completionBlock(NO,error.localizedDescription);
                    }
                }
            }
        }];
    } else {
        NAMAlertViewBlock *alertView = [[NAMAlertViewBlock alloc] initWithTitle:@"Facebook"
                                                                        message:@"There are currently no Facebook accounts configured. You can add or create a Facebook account in your device's settings."
                                                                     completion:notLoggedInAlertCompletion
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Log-in", nil];
        [alertView show];
    }
}

#pragma mark - Logout

- (void)logout {
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - Login

- (void)attemptLoginWithUI:(BOOL)allowLoginUI resultsHandler:(FBLoginResultsHandler)loginResultsHandler
{
    self.loginResultsHandler = loginResultsHandler;
    NSArray *permissions = [NSArray arrayWithObjects: @"read_stream", @"email", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
    }];
}

- (void)attemptOpenWritePermissionsWithTryToRelogin:(BOOL)tryToRelogin completionBlock:(FBReauthorizeResultHandler)handler {
    dispatch_async(dispatch_get_current_queue(), ^{
        if ([FBSession activeSession].isOpen) {
            NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", nil];
            [FBSession.activeSession requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                if (handler) {
                    if (!error) {
                        handler(YES,nil);
                    } else {
                        handler(NO,error);
                    }
                }
            }];
        } else {
            BOOL allowUI = ![self isSessionStateEffectivelyLoggedIn:[FBSession activeSession].state];
            [[FacebookModel sharedModel] attemptLoginWithUI:allowUI resultsHandler:^(BOOL facebookDidLogin) {
                [self attemptOpenWritePermissionsWithTryToRelogin:YES completionBlock:handler];
            }];
        };
    });
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    DLog(@"sessionStateChanged");
    switch (state) {
        case FBSessionStateOpen: {
            DLog(@"FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            [FBSession.activeSession closeAndClearTokenInformation];
            DLog(@"FBSessionStateClosed FBSessionStateClosedLoginFailed");
            break;
        default:
            break;
    }
    
    if (error) {
        [[self class] synchronizeSystemAndServerAccountsWithCompletionBlock:NULL];
        NSString *errorTitle = NSLocalizedString(@"Error", @"Facebook connect");
        NSString *errorMessage = [error localizedDescription];
        if (error.code == FBErrorLoginFailedOrCancelled) {
            errorTitle = NSLocalizedString(@"Facebook Login Failed", @"Facebook Connect");
            errorMessage = NSLocalizedString(@"Make sure you've allowed Vibe-It to use Facebook in Settings > Facebook and try again.", @"Facebook connect");
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"Facebook Connect")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    if (_loginResultsHandler) {
        _loginResultsHandler([self isLoggedIn]);
    }
    
    _loginResultsHandler = nil;
}


#pragma mark - User Details
- (void)userDetailsProcessedBy:(FBUserDetailsProcessor)userDetailsProcessor {
    self.userDetailsProcessor = userDetailsProcessor;
    if ([self isLoggedIn]) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             _userDetailsProcessor(user, error);
         }];
    } else {
        _userDetailsProcessor(nil, nil);
    }
}

#pragma mark - Post To Wall

- (void)postToWallWithResultsHandler:(FBPostToWallResultsHandler)postToWallHandler
                         andPostDict:(NSDictionary *)postDict {
    self.postToWallResultsHandler = postToWallHandler;
    if ([self isLoggedIn]) {
        // create the connection object
        FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
        // create a handler block to handle the results of the request for fbid's profile
        FBRequestHandler handler =
        ^(FBRequestConnection *connection, id result, NSError *error) {
            // output the results of the request
            [self requestCompleted:connection forFbID:@"me/feed" result:result error:error];
        };
        
        FBRequest *request=[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me/feed" parameters:postDict HTTPMethod:@"POST"];
        [newConnection addRequest:request completionHandler:handler];
        // if there's an outstanding connection, just cancel
        [self.requestConnection cancel];
        // keep track of our connection, and start it
        self.requestConnection = newConnection;
        [newConnection start];
    } else {
        if (_postToWallResultsHandler) {
            _postToWallResultsHandler(NO);
        }
    }
}

- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error
{
    // not the completion we were looking for...
    if (self.requestConnection &&
        connection != self.requestConnection)
    {
        if (_postToWallResultsHandler) {
            _postToWallResultsHandler(NO);
        }
        return;
    }
    // clean this up, for posterity
    self.requestConnection = nil;
    if (error) {
        if (_postToWallResultsHandler) {
            _postToWallResultsHandler(NO);
        }
        [[FacebookErrorHanler sharedHandler] handleError:error];
    } else {
        if (_postToWallResultsHandler) {
            _postToWallResultsHandler(YES);
        }
    }
}

#pragma mark - Privat API

#pragma mark - Authorization methods
- (BOOL)isSessionStateEffectivelyLoggedIn:(FBSessionState)state {
    BOOL effectivelyLoggedIn;
    
    switch (state) {
        case FBSessionStateOpen:
            DLog(@"Facebook session state: FBSessionStateOpen");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateCreatedTokenLoaded:
            DLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateOpenTokenExtended:
            DLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
            effectivelyLoggedIn = YES;
            break;
        default:
            DLog(@"Facebook session state: not of one of the open or openable types.");
            effectivelyLoggedIn = NO;
            break;
    }
    
    return effectivelyLoggedIn;
}

/**
 * Determines if the Facebook session has an authorized state. It might still need to be opened if it is a cached
 * token, but the purpose of this call is to determine if the user is authorized at least that they will not be
 * explicitly asked anything.
 */
- (BOOL)isLoggedIn {
    FBSession *activeSession = [FBSession activeSession];
    FBSessionState state = activeSession.state;
    
    BOOL isLoggedIn;
    
    if (activeSession && [self isSessionStateEffectivelyLoggedIn:state]) {
        isLoggedIn = YES;
    } else {
        isLoggedIn = NO;
    }
    
    return isLoggedIn;
}

/**
 * Attempts to silently open the Facebook session if we have a valid token loaded (that perhaps needs a behind the scenes refresh).
 * After that attempt, we defer to the basic concept of the session being in one of the valid authorized states.
 */

- (BOOL)isLoggedInAfterOpenAttempt {
    DLog(@"FBSession.activeSession: %@", FBSession.activeSession);
    
    // If we don't have a cached token, a call to open here would cause UX for login to
    // occur; we don't want that to happen unless the user clicks the login button over in Settings, and so
    // we check here to make sure we have a token before calling open
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        DLog(@"We have a cached token, so we're going to re-establish the login for the user.");
        // Even though we had a cached token, we need to login to make the session usable:
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            DLog(@"Finished opening login session, with state: %d", status);
        }];
    }
    else {
        DLog(@"Active session wasn't in state 'FBSessionStateCreatedTokenLoaded'. It has state: %d", FBSession.activeSession.state);
    }
    
    return [self isLoggedIn];
}

#pragma mark - Account Sync
+ (void)synchronizeSystemAndServerAccountsWithCompletionBlock:(nam_voidCompletionBlock)block {
    nam_dispatchOnQueue(@"accountQueue", ^{
        if (&ACAccountTypeIdentifierFacebook) {
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
            if (accountStore && accountTypeFB){
                
                NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
                id account;
                if (fbAccounts && [fbAccounts count] > 0 &&
                    (account = [fbAccounts objectAtIndex:0])){
                    
                    [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (block) block();
                        });
                    }];
                }
            }
        }
    });
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kFacebookDidLoginSuccessfullyAlert_Tag) {
        [[FacebookModel sharedModel] attemptOpenWritePermissionsWithTryToRelogin:YES completionBlock:^(BOOL facebookDidReauthorize, NSError *error) {
            
        }];
    }
}
@end

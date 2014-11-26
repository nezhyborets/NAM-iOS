//
//  FacebookErrorHanler.h
//  NewFacebook
//
//  Created by Evgeniy Gurtovoy on 9/13/12.
//  Copyright (c) 2012 Evgeniy Gurtovoy. All rights reserved.
//

@interface FacebookErrorHanler : NSObject
+ (FacebookErrorHanler *)sharedHandler;
- (void)handleError:(NSError *)fbError;
@end

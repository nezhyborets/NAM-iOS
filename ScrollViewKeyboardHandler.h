//
//  ScrollViewKeyboardHandler.h
//  WinePicker
//
//  Created by Alexei on 19.10.15.
//  Copyright © 2015 Onix-Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollViewKeyboardHandler : NSObject
@property (nonatomic, weak) UIScrollView *scrollView;

- (void)subscribe;
- (void)unsubscribe;
@end

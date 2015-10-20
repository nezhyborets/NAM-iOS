//
//  ScrollViewKeyboardHandler.h
//  WinePicker
//
//  Created by Alexei on 19.10.15.
//  Copyright © 2015 Onix-Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollViewKeyboardHandler : NSObject
@property (nonatomic, weak) UIView *viewForDismissTap;
@property (nonatomic, weak) UIScrollView *scrollView;

- (void)setViewToDim:(UIView *)view fromTextFieldEntry:(UITextField *)textField;

- (void)subscribe;
- (void)unsubscribe;
@end

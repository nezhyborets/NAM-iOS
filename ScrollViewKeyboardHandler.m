//
//  ScrollViewKeyboardHandler.m
//  WinePicker
//
//  Created by Alexei on 19.10.15.
//  Copyright © 2015 Onix-Systems. All rights reserved.
//

#import "ScrollViewKeyboardHandler.h"

@interface ScrollViewKeyboardHandler()
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation ScrollViewKeyboardHandler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        if (self.tapGestureRecognizer && [_scrollView.gestureRecognizers containsObject:self.tapGestureRecognizer]) {
            [_scrollView removeGestureRecognizer:self.tapGestureRecognizer];
            self.tapGestureRecognizer = nil;
        }
        
        _scrollView = scrollView;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        recognizer.cancelsTouchesInView = NO;
        [_scrollView addGestureRecognizer:recognizer];
    }
}

- (void)tap:(id)sender {
    [_scrollView.window endEditing:YES];
}

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //get the end position keyboard frame
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the scrollView it might be occluding
    keyboardFrame = [self.scrollView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, self.scrollView.bounds);
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on scrollView to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
        }];
    }
}

- (void) keyboardWillHide:  (NSNotification *) notification{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

@end

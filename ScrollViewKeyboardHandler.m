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
@property (nonatomic, weak) UIView *viewToDim;
@property (nonatomic, strong) NSArray *viewsToDim;
@property (nonatomic, weak) UIView *dimView;
@end

@implementation ScrollViewKeyboardHandler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setViewToDim:(UIView *)view fromTextFieldEntry:(UITextField *)textField {
    self.viewToDim = view;
    self.viewsToDim = nil;

    [self reloadTextFieldTarget:textField];
}

- (void)setViewsToDim:(NSArray *)views fromTextFieldEntry:(UITextField *)textField {
    self.viewToDim = nil;
    self.viewsToDim = views;

    [self reloadTextFieldTarget:textField];
}

- (void)reloadTextFieldTarget:(UITextField *)textField {
    [textField removeTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextChanged:(UITextField *)textField {
    if (textField.text.length) {
        [self removeDim];
    } else {
        [self addDim];
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

- (void)addDim {
    if (!self.dimView && (self.viewToDim || self.viewsToDim)) {
        UIControl *dimView = [[UIControl alloc] initWithFrame:CGRectZero];
        dimView.backgroundColor = [UIColor blackColor];
        dimView.alpha = 0;
        [dimView addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.dimView = dimView;

        if (self.viewToDim) {
            [self.viewToDim.superview addSubview:dimView];
            [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.viewToDim);
            }];
        } else {
            //Checking if superview is same on all views
            UIView *top = self.viewsToDim[0];
            UIView *right = self.viewsToDim[1];
            UIView *bottom = self.viewsToDim[2];
            UIView *left = self.viewsToDim[3];

            [top.superview addSubview:dimView];
            [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(top);
                make.trailing.equalTo(right);
                make.bottom.equalTo(bottom);
                make.leading.equalTo(left);
            }];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            dimView.alpha = 0.3;
        }];
    }
}

- (void)removeDim {
    if (self.dimView) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dimView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.dimView removeFromSuperview];
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //get the end position keyboard frame
    [self addDim];
    
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
    [self removeDim];
    
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

@end

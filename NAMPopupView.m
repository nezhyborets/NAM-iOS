//
//  UbkiPopup.m
//  UBKI
//
//  Created by Alexei on 01.10.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "NAMPopupView.h"

@implementation NAMPopupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
        [control addTarget:self action:@selector(backgroundTapAction:) forControlEvents:UIControlEventTouchUpInside];
        control.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:control];
    }
    
    return self;
}

- (IBAction)backgroundTapAction:(id)sender {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(dismissCalledOnPopup:)]) {
        [self.delegate dismissCalledOnPopup:self];
    } else {
        [self removeFromSuperview];
    }
}

+ (void)showSimpleTextFieldPopupInView:(UIView *)view withText:(NSString *)text {
    NAMPopupView *popup = [[NAMPopupView alloc] initWithFrame:view.bounds];
    popup.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    popup.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    CGFloat sizeDifference = 0.7f;
    CGFloat textFieldWidth = (popup.bounds.size.width * sizeDifference);
    CGFloat textFieldHeight = (popup.bounds.size.height * sizeDifference);
    
    CGRect textViewFrame = CGRectMake((int)(popup.bounds.size.width/2 - textFieldWidth/2),
                                      (int)(popup.bounds.size.height/2 - textFieldHeight/2),
                                      textFieldWidth,
                                      textFieldHeight);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.text = text;
    textView.editable = NO;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [popup addSubview:textView];

    [view addSubview:popup];
}

@end

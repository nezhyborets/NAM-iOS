//
//  UbkiPopup.m
//  UBKI
//
//  Created by Alexei on 01.10.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "UbkiPopup.h"

@implementation UbkiPopup

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

@end

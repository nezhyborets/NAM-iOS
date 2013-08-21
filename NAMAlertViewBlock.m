//
//  NAMAlertView.m
//  Vibe-It
//
//  Created by Alexei on 21.02.13.
//  Copyright (c) 2013 Ora Interactive. All rights reserved.
//

#import "NAMAlertViewBlock.h"

@interface NAMAlertViewBlock()
@property (copy, nonatomic) void (^completion)(BOOL, NSInteger);
@end

@implementation NAMAlertViewBlock
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    
    if (self) {
        _completion = completion;
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.completion(buttonIndex==self.cancelButtonIndex, buttonIndex);
}

@end

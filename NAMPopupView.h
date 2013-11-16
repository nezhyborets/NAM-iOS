//
//  UbkiPopup.h
//  UBKI
//
//  Created by Alexei on 01.10.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NAMPopupView;

@protocol NAMPopupDelegate <NSObject>
- (void)dismissCalledOnPopup:(NAMPopupView *)datePicker;
@optional
- (void)submitActionCalledOnPopup:(NAMPopupView *)datePicker;
@end

@interface NAMPopupView : UIView
@property (nonatomic, assign) id <NAMPopupDelegate> delegate;

+ (void)showSimpleTextFieldPopupInView:(UIView *)view withText:(NSString *)text;
@end
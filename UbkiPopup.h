//
//  UbkiPopup.h
//  UBKI
//
//  Created by Alexei on 01.10.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UbkiPopup;

@protocol UbkiPopupDelegate <NSObject>
- (void)dismissCalledOnPopup:(UbkiPopup *)datePicker;
@optional
- (void)submitActionCalledOnPopup:(UbkiPopup *)datePicker;
@end

@interface UbkiPopup : UIView
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

@property (nonatomic, assign) id <UbkiPopupDelegate> delegate;
@end
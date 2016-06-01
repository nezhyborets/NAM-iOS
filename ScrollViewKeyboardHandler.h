//
//  ScrollViewKeyboardHandler.h
//  WinePicker
//
//  Created by Alexei on 19.10.15.
//  Copyright © 2015 Onix-Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollViewKeyboardHandler : NSObject
//@property (nonatomic, weak) UIView *viewForDismissTap;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic) BOOL shouldAdjustScrollViewInsets; //Defaults to YES

- (void)bringDimViewToFront;
- (void)setViewToDim:(UIView *)view fromTextFieldEntry:(UITextField *)textField;

/* Same as setViewToDim, but for covering multiple sublings. These 2 methods are going to override each other.
 * @param views Must be and array of 4 views: top, right, bottom, left.
 */
- (void)setViewsToDim:(NSArray *)views fromTextFieldEntry:(UITextField *)textField;

- (void)subscribe;
- (void)unsubscribe;
@end

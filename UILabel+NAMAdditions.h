//
//  UILabel+NAMAdditions.h
//  Omer
//
//  Created by Alexei on 07.05.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NAMAdditions)
- (void)adjustHeight;
- (void)adjustHeightAndSetOriginY:(CGFloat)originY;
- (void)adjustHeightWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;
@end

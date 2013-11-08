//
//  UILabel+NAMAdditions.m
//  Omer
//
//  Created by Alexei on 07.05.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "UILabel+NAMAdditions.h"

@implementation UILabel (NAMAdditions)
- (void)adjustHeightAndSetOriginY:(CGFloat)originY {
    CGSize size = [self prepareToAdjustAndGetSize];
    CGRect newFrame = self.frame;
    newFrame.origin.y = originY;
    newFrame.size.height = size.height;
    self.frame = newFrame;
}

- (void)adjustHeight {
    CGSize size = [self prepareToAdjustAndGetSize];
    CGRect newFrame = self.frame;
    newFrame.size.height = size.height;
    self.frame = newFrame;
}

- (void)adjustHeightWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight {
    CGSize size = [self prepareToAdjustAndGetSize];
    CGFloat height = size.height;
    
    if (height < minHeight && minHeight != 0) {
        height = minHeight;
    }
    
    if (height > maxHeight && maxHeight != 0) {
        height = maxHeight;
    }
    
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGSize)prepareToAdjustAndGetSize {
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    
    CGSize size = CGSizeZero;
    CGSize maxSize = CGSizeMake(self.bounds.size.width, 9999);
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [self.text boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : self.font}
                                         context:nil];
        size = rect.size;
    } else {
        size = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}
@end

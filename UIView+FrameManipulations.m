//
//  UIView+FrameManipulations.
//
//  Created by Alexei Nezhyborets on 4/20/12.
//  Copyright (c) 2012 Onix-Systems. All rights reserved.
//

#import "UIView+FrameManipulations.h"

@implementation UIView (FrameManipulations)

- (void)offsetXBy:(float)offset
{
    self.frame = CGRectMake(self.frame.origin.x+offset, self.frame.origin.y, 
                            self.frame.size.width, self.frame.size.height);
}

- (void)offsetYBy:(float)offset
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+offset, 
                            self.frame.size.width, self.frame.size.height);
}

- (void)offsetXBy:(float)xOffset offsetYBy:(float)yOffset
{
    self.frame = CGRectMake(self.frame.origin.x+xOffset, self.frame.origin.y+yOffset, 
                            self.frame.size.width, self.frame.size.height);
}

- (void)changeHeightTo:(float)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, height);
}

- (void)changeHeightTo:(float)height addHeightTo:(UIViewHeightAddDirection)direction
{
    if (direction == UIViewHeightAddDirectionDefault || direction == UIViewHeightAddDirectionBottom) {
        [self changeHeightTo:height];
    } else if (direction == UIViewHeightAddDirectionTop) {
        //TODO
    } else if (direction == UIViewHeightAddDirectionBoth) {
        CGFloat heightDifference = height - self.frame.size.height;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - lroundf(heightDifference/2),
                                self.frame.size.width, height);
    }
}

- (void)changeWidthTo:(float)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            width, self.frame.size.height);
}

- (void)growHeightBy:(float)height
{
    [self changeHeightTo:self.frame.size.height+height];
}

- (void)setOriginYTo:(float)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, 
                            self.frame.size.width, self.frame.size.height);
}

- (void)setOriginXTo:(float)originX
{
    self.frame = CGRectMake(originX, self.frame.origin.y, 
                            self.frame.size.width, self.frame.size.height);
}

- (void)setOriginTo:(CGPoint)originPoint {
    self.frame = CGRectMake(originPoint.x, originPoint.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)lowestY {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)rightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)putToTheMiddleOfSuperviewWithType:(UIViewCustomCenterSettingType)type {
    CGFloat newOriginX = roundf(self.superview.frame.size.width/2 - self.frame.size.width/2);
    CGFloat newOriginY = roundf(self.superview.frame.size.height/2 - self.frame.size.height/2);
    
    if (type == UIViewCustomCenterSettingTypeHorizontal) {
        newOriginY = self.frame.origin.y;
    }
    
    if (type == UIViewCustomCenterSettingTypeVertical) {
        newOriginX = self.frame.origin.x;
    }
    
    self.frame = CGRectMake(newOriginX,
                            newOriginY,
                            self.frame.size.width,
                            self.frame.size.height);
}

@end
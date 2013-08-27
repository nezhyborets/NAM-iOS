//
//  UIView+FrameManipulations.
//
//  Created by Alexei Nezhyborets on 4/20/12.
//  Copyright (c) 2012 Onix-Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIViewHeightAddDirectionDefault,
    UIViewHeightAddDirectionBottom,
    UIViewHeightAddDirectionTop,
    UIViewHeightAddDirectionBoth
} UIViewHeightAddDirection;

enum {
    UIViewCustomCenterSettingTypeBoth = 0,
    UIViewCustomCenterSettingTypeHorizontal = 1,
    UIViewCustomCenterSettingTypeVertical = 2
};

typedef NSInteger UIViewCustomCenterSettingType;

@interface UIView (FrameManipulations)
@property (nonatomic, readonly) CGFloat lowestY;
@property (nonatomic, readonly) CGFloat rightX;

- (void)offsetXBy:(float)offset;
- (void)offsetYBy:(float)offset;
- (void)offsetXBy:(float)xOffset offsetYBy:(float)yOffset;
- (void)changeHeightTo:(float)height;
- (void)changeHeightTo:(float)height addHeightTo:(UIViewHeightAddDirection)direction;
- (void)changeWidthTo:(float)width;
- (void)growHeightBy:(float)height;
- (void)setOriginYTo:(float)originY;
- (void)setOriginXTo:(float)originX;
- (void)putToTheMiddleOfSuperviewWithType:(UIViewCustomCenterSettingType)type;
- (void)setOriginTo:(CGPoint)originPoint;
- (void)setFullAutoresizing;

- (CGFloat)rightX;
@end
//
//  NAMButtonsBar.m
//  UBKI
//
//  Created by Alexei on 21.08.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "NAMButtonsBar.h"
#import <QuartzCore/QuartzCore.h>

NSString *const kNAMButtonDefaultImageName = @"kNAMButtonDefaultImageName";
NSString *const kNAMButtonSelectedImageName = @"kNAMButtonSelectedImageName";
NSString *const kNAMButtonDefaultBackgroundColor = @"kNAMButtonDefaultBackgroundColor";
NSString *const kNAMButtonSelectedBackgroundColor = @"kNAMButtonSelectedBackgroundColor";

@interface NAMButtonsBar()
@property (nonatomic, strong) NSArray *buttonsArray;
@end

@implementation NAMButtonsBar

- (id)initWithFrame:(CGRect)frame
        titlesArray:(NSArray *)titlesArray
            options:(NSDictionary *)options
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithCapacity:titlesArray.count];
        
        for (NSString *title in titlesArray) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([options[kNAMButtonDefaultImageName] isKindOfClass:[NSString class]]) {
                UIImage *image = [UIImage imageNamed:options[kNAMButtonDefaultImageName]];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            } else if ([options[kNAMButtonDefaultBackgroundColor] isKindOfClass:[UIColor class]]) {
                UIColor *color = options[kNAMButtonDefaultBackgroundColor];
                [button setBackgroundColor:color];
            }
            
            if ([options[kNAMButtonSelectedImageName] isKindOfClass:[NSString class]]) {
                UIImage *image = [UIImage imageNamed:options[kNAMButtonSelectedImageName]];
                [button setBackgroundImage:image forState:UIControlStateSelected];
            } else if ([options[kNAMButtonSelectedBackgroundColor] isKindOfClass:[UIColor class]]) {
                UIColor *color = options[kNAMButtonSelectedBackgroundColor];
                UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
                colorView.backgroundColor = color;
                
                UIGraphicsBeginImageContext(colorView.bounds.size);
                [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [button setBackgroundImage:colorImage forState:UIControlStateSelected];
            }
            
            //default text attributes used
            if ([options[UITextAttributeTextColor] isKindOfClass:[UIColor class]]) {
                [button setTitleColor:options[UITextAttributeTextColor] forState:UIControlStateNormal];
            }
            
            if ([options[UITextAttributeFont] isKindOfClass:[UIFont class]]) {
                button.titleLabel.font = options[UITextAttributeFont];
            }
            
            if ([options[UITextAttributeTextShadowColor] isKindOfClass:[UIColor class]]) {
                button.titleLabel.shadowColor = options[UITextAttributeTextShadowColor];
            }
            
            if ([options[UITextAttributeTextShadowOffset] isKindOfClass:[NSValue class]]) {
                NSValue *value = options[UITextAttributeTextShadowOffset];
                button.titleLabel.shadowOffset = [value CGSizeValue];
                button.layer.shouldRasterize = YES;
                button.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            }
            
            
            [self addSubview:button];
            [buttonsArray addObject:button];
        }
        
        self.buttonsArray = buttonsArray;
        [self recountButtonsPosition];
        [self selectButtonAtIndex:0];
    }
    
    return self;
}

#pragma mark - Public API
- (void)selectButtonAtIndex:(NSUInteger)index {
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        button.selected = index == i;
    }
    
    self.selectedIndex = index;
}

#pragma mark - Private API
- (void)recountButtonsPosition {
    NSInteger numberOfButtons = self.buttonsArray.count;
    NSInteger buttonWidth = lroundf(self.bounds.size.width / numberOfButtons);
    
    for (int i = 0; i < numberOfButtons; i++) {
        UIButton *button = self.buttonsArray[i];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, self.bounds.size.height);
    }
}

- (void)buttonAction:(id)sender {
    NSUInteger index = [self.buttonsArray indexOfObject:sender];
    [self sendNotificationWithIndex:index];
}

- (void)sendNotificationWithIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(buttonsBar:buttonActionCalledAtIndex:)] &&
        index != NSNotFound &&
        index != self.selectedIndex)
    {
        [self.delegate buttonsBar:self buttonActionCalledAtIndex:index];
    }
}

@end
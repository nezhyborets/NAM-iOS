//
//  NAMButtonsBar.m
//  UBKI
//
//  Created by Alexei on 21.08.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "NAMButtonsBar.h"

@interface NAMButtonsBar()
@property (nonatomic, strong) NSArray *buttonsArray;
@end

@implementation NAMButtonsBar

- (id)initWithFrame:(CGRect)frame
        titlesArray:(NSArray *)titlesArray
   defaultImageName:(NSString *)defaultImageName
  selectedImageName:(NSString *)selectedImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithCapacity:titlesArray.count];
        
        for (NSString *title in titlesArray) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:defaultImageName] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            button.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.34];
            button.titleLabel.shadowOffset = CGSizeMake(0, -1);
            
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
    
    if ([self.delegate respondsToSelector:@selector(buttonsBar:buttonActionCalledAtIndex:)] && index != NSNotFound) {
        [self.delegate buttonsBar:self buttonActionCalledAtIndex:index];
    }
}

@end
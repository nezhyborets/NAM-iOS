//
//  NAMButtonsBar.h
//  UBKI
//
//  Created by Alexei on 21.08.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kNAMButtonDefaultImageName;
FOUNDATION_EXPORT NSString *const kNAMButtonSelectedImageName;
FOUNDATION_EXPORT NSString *const kNAMButtonDefaultBackgroundColor;
FOUNDATION_EXPORT NSString *const kNAMButtonSelectedBackgroundColor;

@class NAMButtonsBar;

@protocol NAMButtonsBarDelegate <NSObject>
- (void)buttonsBar:(NAMButtonsBar *)bar buttonActionCalledAtIndex:(NSUInteger)index;
@end

@interface NAMButtonsBar : UIView

@property (nonatomic, weak) id <NAMButtonsBarDelegate> delegate;
@property (nonatomic) NSUInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame
        titlesArray:(NSArray *)titlesArray
            options:(NSDictionary *)options;

- (void)selectButtonAtIndex:(NSUInteger)index;
@end
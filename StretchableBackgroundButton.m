//
//  ResizableLucidaButton.m
//  Omer
//
//  Created by Alexei on 16.03.13.
//  Copyright (c) 2013 Onix. All rights reserved.
//

#import "StretchableBackgroundButton.h"

@implementation StretchableBackgroundButton

- (id)initWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    UIImage *image = [self backgroundImageForState:UIControlStateNormal];
    UIImage *stretchableImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [self setBackgroundImage:stretchableImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

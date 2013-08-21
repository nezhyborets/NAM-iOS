//
//  StretchableImage.m
//  TexasBirds
//
//  Created by Alexei on 19.11.12.
//  Copyright (c) 2012 Nanurepatrol. All rights reserved.
//

#import "StretchableImageView.h"

@implementation StretchableImageView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    self = [super initWithImage:image];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    UIImage *image = self.image;
    self.image = [image stretchableImageWithLeftCapWidth:roundf(image.size.width/2) topCapHeight:roundf(image.size.height/2)];
}

- (void)setAndStretchImage:(UIImage *)image {
    self.image = image;
    [self setup];
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

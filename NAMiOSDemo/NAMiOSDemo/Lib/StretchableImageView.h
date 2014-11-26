//
//  StretchableImage.h
//  TexasBirds
//
//  Created by Alexei on 19.11.12.
//  Copyright (c) 2012 Nanurepatrol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StretchableImageView : UIImageView
- (void)setAndStretchImage:(UIImage *)image;
- (id)initWithImageName:(NSString *)imageName;
@end
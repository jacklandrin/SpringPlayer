//
//  UIImageView+ImageFill.m
//  SpringPlayer
//
//  Created by jack on 15/5/3.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "UIImageView+ImageFill.h"

@implementation UIImageView (ImageFill)

-(void)setImageFill{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

@end

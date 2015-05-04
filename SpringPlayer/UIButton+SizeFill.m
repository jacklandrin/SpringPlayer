//
//  UIButton+SizeFill.m
//  SpringPlayer
//
//  Created by jack on 15/5/4.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "UIButton+SizeFill.h"

@implementation UIButton (SizeFill)

-(void)setText:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.titleLabel.font.pointSize)];
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

@end

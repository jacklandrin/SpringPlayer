//
//  TrapeziumView.m
//  SpringPlayer
//
//  Created by jack on 15/5/6.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "TrapeziumView.h"

@implementation TrapeziumView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _color = UI_COLOR_FROM_RGBA(0xccc437,0.28);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 3);
    CGContextClosePath(context);
    [_color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

-(void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

@end

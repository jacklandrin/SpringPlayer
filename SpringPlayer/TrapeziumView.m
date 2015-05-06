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
//    CGContextSetRGBStrokeColor(context,0.7,0.5,0.3,1.0);
//    CGPoint sPoints[4];
//    sPoints[0] = CGPointMake(0, 0);
//    sPoints[1] = CGPointMake(0, rect.size.height);
//    sPoints[2] = CGPointMake(rect.size.width, rect.size.height);
//    sPoints[3] = CGPointMake(rect.size.width, rect.size.height / 3);
//    CGContextAddLines(context, sPoints, 4);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 3);
    CGContextClosePath(context);
    //CGContextSetStrokeColorWithColor(context, _color.CGColor);
    [_color setFill];
    CGContextDrawPath(context, kCGPathFill);
    //CGContextSetFillColorWithColor(context, _color.CGColor);
}

-(void)setColor:(UIColor *)color{
    _color = color;
    //self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

@end

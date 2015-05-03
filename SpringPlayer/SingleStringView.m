//
//  SingleStringView.m
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "SingleStringView.h"

@interface SingleStringView(){
    CGFloat _location;
}

@end

@implementation SingleStringView

-(instancetype)init{
    if (self = [super init]) {
        self.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    return self;
}

-(void)setText:(NSString *)labelText direction:(LabelDirection)labelDirection location:(CGFloat)location{
    NSLog(@"%d",labelDirection);
    self.transform = CGAffineTransformIdentity;
    self.text = labelText;
    _labelFontSize = RANDOMNUM(16, 35.0);
    [self setFont:[UIFont boldSystemFontOfSize:_labelFontSize]];
    CGRect newRect = self.frame;
    CGSize labelSize = [self sizeThatFits:CGSizeMake(MAXFLOAT, _labelFontSize)];
    self.labelDirection = labelDirection;
    switch (_labelDirection) {
        case UpType:
            self.transform = CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            newRect.size.height = labelSize.width;
            newRect.size.width = labelSize.height;
            newRect.origin.x = location;
            newRect.origin.y = WINDOW_HEIGHT;
            break;
        case DownType:
            self.transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
            newRect.size.height = labelSize.width;
            newRect.size.width = labelSize.height;
            newRect.origin.x = location;
            newRect.origin.y = -labelSize.height;
            break;
        case LeftType:
            newRect.size = labelSize;
            newRect.origin.y = location;
            newRect.origin.x = WINDOW_WIDTH;
            break;
        case RightType:
            newRect.size = labelSize;
            newRect.origin.y = location;
            newRect.origin.x = -labelSize.width;
            break;
        default:
            break;
    }
    //newRect.size = labelSize;
    self.frame = newRect;
}



@end

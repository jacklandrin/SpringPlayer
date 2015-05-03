//
//  SingleStringView.h
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    UpType = 0,
    DownType = 1,
    LeftType = 2,
    RightType = 3,
    LeftUpType = 4,
    RightUpType = 5,
    LeftDownType = 6,
    RightDownType = 7
}LabelDirection;

@interface SingleStringView : UILabel

@property (nonatomic,assign) LabelDirection labelDirection;
@property (nonatomic,readonly) CGFloat labelFontSize;
@property (nonatomic,readonly) CGFloat labelWidth;
@property (nonatomic,assign) BOOL isMoving;

-(void)setText:(NSString*)labelText direction:(LabelDirection)labelDirection location:(CGFloat)location;

@end

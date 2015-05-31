//
//  FMLrcView.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-30.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMLrcView : UIView
{
    UIScrollView * _scrollView;
    NSMutableArray * keyArr;
    NSMutableArray * titleArr;
    NSMutableArray * labels;
}
@property (nonatomic,strong) UIColor *highlightColor;
-(void)setLrcSourcePath:(NSString *)path;
-(void)scrollViewMoveLabelWith:(NSString *)string;
-(void)scrollViewClearSubView;
-(void)selfClearKeyAndTitle;
@end

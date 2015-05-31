//
//  FMLrcView.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-30.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMLrcView.h"
#import "UIView+Additions.h"
@implementation FMLrcView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        keyArr = [NSMutableArray new];
        titleArr = [NSMutableArray new];
        labels = [NSMutableArray new];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.userInteractionEnabled = NO;
        [self addSubview:_scrollView];        
    }
    return self;
}
-(void)setLrcSourcePath:(NSString *)path
{
    if ([keyArr count]!=0) {
        [keyArr removeAllObjects];
    }
    if ([titleArr count]!=0) {
        [titleArr removeAllObjects];
    }
    NSString * string =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    for (NSString * str in array) {
        if (!str || str.length <= 0)
            continue;
        [self parseLrcLine:str];
    }
    [self bubbleSort:keyArr];
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.size.width, [keyArr count]*25);
    [self addLabelForScrollView];
}
-(float)getNumberWith:(NSString *)string
{
    NSArray * array = [string componentsSeparatedByString:@":"];
    NSString * str = [NSString stringWithFormat:@"%@.%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    return [str floatValue];
}
- (void)bubbleSort:(NSMutableArray *)array
{
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            float  num1 = [self getNumberWith:[array objectAtIndex:y]];
            float num2 = [self getNumberWith:[array objectAtIndex:y-1]];
            if (num1 < num2) {
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                [titleArr exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}

-(void)selfClearKeyAndTitle
{
    if ([keyArr count]!=0) {
        [keyArr removeAllObjects];
    }
    if ([titleArr count]!=0) {
        [titleArr removeAllObjects];
    }

}
-(void)scrollViewClearSubView
{
    for (UIView * sub in  _scrollView.subviews) {
        [sub removeFromSuperview];
    }
    if ([labels count]!=0) {
        [labels removeAllObjects];
    }
}
-(void)addLabelForScrollView
{
    [self scrollViewClearSubView];
    
    for (int index = 0; index<[titleArr count]; index++) {
        NSString * title = [titleArr objectAtIndex:index];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25*index+(_scrollView.size.height/2), _scrollView.size.width, 25)];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:label];
        [labels addObject:label];
    }
}
-(void)scrollViewMoveLabelWith:(NSString *)string
{
    if ([keyArr count]!=0) {
        int index = 0;
        BOOL isFinded = NO;
        for (; index<[keyArr count]; index++) {
            NSString * key = [keyArr objectAtIndex:index];
            float  num1 = [self getNumberWith:key];
            float num2 = [self getNumberWith:string];
            if (num1 == num2) {
                isFinded = YES;
                break;
            }
        }
        if (isFinded) {
            UILabel * label = [labels objectAtIndex:index];
            label.textColor = _highlightColor;//[UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
            [_scrollView setContentOffset:CGPointMake(0, 25*index) animated:YES];
        }
    }

}
-(NSString*) parseLrcLine:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        return nil;
    NSArray *array = [sourceLineText componentsSeparatedByString:@"\n"];
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = [array objectAtIndex:i];
        NSArray *lineArray = [tempStr componentsSeparatedByString:@"]"];
        for (int j = 0; j < [lineArray count]-1; j ++) {
            
            if ([lineArray[j] length] > 8) {
                NSString *str1 = [tempStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [tempStr substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                    NSString *lrcStr = [lineArray lastObject];
                    NSString *timeStr = [[lineArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 8)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    [keyArr addObject:[timeStr substringToIndex:5]];
                    [titleArr addObject:lrcStr];
                }
            }
        }
    }
    return nil;
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

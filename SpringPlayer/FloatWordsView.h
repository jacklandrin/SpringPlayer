//
//  FloatWordsView.h
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//
#import "MusicModel.h"
@interface FloatWordsView : UIView

@property (nonatomic,strong) NSArray *wordsArray;

-(instancetype)initWithFrame:(CGRect)frame musicInfo:(MusicModel*)music;
-(void)playNewSong:(MusicModel*)music;
-(void)stopSong;
-(void)pauseSong;
-(void)resumeSong;
-(void)setTime:(NSString*)timeStr;
@end

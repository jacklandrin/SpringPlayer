//
//  MusicModel.h
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"
#import "LyricModel.h"

@interface MusicModel : NSObject<DOUAudioFile>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *artist;
@property (nonatomic,copy) NSString *playTime;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSURL *url;
@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,strong) LyricModel *lyric;

@end

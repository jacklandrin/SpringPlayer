//
//  MusicModel.m
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(instancetype)init{
    if (self = [super init]) {
        self.lyric = [[LyricModel alloc] init];
    }
    return self;
}

- (NSURL *)audioFileURL{
    return [self url];
}

@end

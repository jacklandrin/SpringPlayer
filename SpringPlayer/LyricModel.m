//
//  LyricModel.m
//  SpringPlayer
//
//  Created by jack on 15/5/31.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

-(instancetype)init{
    if (self = [super init]) {
        self.lyrics = [[NSArray alloc] init];
        self.count = 0;
        self.currentIndex = 0;
    }
    return self;
}

@end

//
//  LyricModel.h
//  SpringPlayer
//
//  Created by jack on 15/5/31.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

@property (nonatomic,strong) NSArray *lyrics;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger currentIndex;

@end

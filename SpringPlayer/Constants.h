//
//  Constants.h
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Constants : NSObject

/*** others ***/
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define RANDOMNUM(RANGE,ORIGIN) (arc4random()%RANGE + ORIGIN - RANGE / 2.0)

/*** layout ***/
#define WINDOW_HEIGHT (IOS_VERSION > 8.1 ? ([[UIScreen mainScreen] applicationFrame].size.height + 20) : [[UIScreen mainScreen] applicationFrame].size.height + 84)
#define WINDOW_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define VIEW_HEIGHT self.contentView.frame.size.height
#define VIEW_WIDTH self.contentView.frame.size.width
#define BOTTOM_BACKGROUND_SCALE (253.0/640.0)

/***colors***/
#define UI_COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UI_COLOR_FROM_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

#define DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define XDRED            UI_COLOR_FROM_RGB(0xFA595C)
#define XDLIGHTRED       UI_COLOR_FROM_RGB(0xEF9299)
#define XDGRAY           UI_COLOR_FROM_RGB(0x666666)
#define XDLIGHTGRAY      UI_COLOR_FROM_RGB(0xB3B3B3)
#define XDDARKGRAY       UI_COLOR_FROM_RGB(0x333333)
#define XDBACKGROUNDGRAY UI_COLOR_FROM_RGB(0xE6E6E6)
#define XDTOOLBARGRAY    UI_COLOR_FROM_RGB(0xF2F2F2)
#define XDBLACK          UI_COLOR_FROM_RGB(0x1A1A1A)
#define XDGREEN          UI_COLOR_FROM_RGB(0x89BD1F)
#define XDTABBARBLACK    UI_COLOR_FROM_RGB(0x191919)
#define XDTABBARRED      UI_COLOR_FROM_RGB(0xEA595C)

extern NSString *const TRACKS_URL;//频道中的歌曲列表
extern NSString *const PIC_URL;//歌曲大图
@end

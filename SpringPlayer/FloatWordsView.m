//
//  FloatWordsView.m
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "FloatWordsView.h"
#import "SingleStringView.h"

#define DIRECTION_NUM 2
#define MOVE_INTERVAL 0.03

@interface FloatWordsView(){
    MusicModel *_musicInfo;
    NSInteger _playSeconds;
    CGFloat _moveSeconds;
    NSTimer *_wordsMoveTimer;
    //NSTimer *_progressUpdateTimer;
    int _direction;
    BOOL _isStoping;
}

@end

@implementation FloatWordsView

-(instancetype)initWithFrame:(CGRect)frame musicInfo:(MusicModel *)music{
    if (self = [self initWithFrame:frame]) {
        _musicInfo = music;
        [self createStringView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _isStoping = NO;
        _playSeconds = 0;
        _moveSeconds = 0.0;
        
        SingleStringView *songNameView = [[SingleStringView alloc] init];
        [self addSubview:songNameView];
        
        SingleStringView *artistView = [[SingleStringView alloc] init];
        [self addSubview:artistView];
        
        SingleStringView *playTimeView = [[SingleStringView alloc] init];
        [self addSubview:playTimeView];
        
        self.wordsArray = @[songNameView,artistView,playTimeView];
        
        //[self creatStringView];
    }
    return self;
}

-(void)setTime:(NSString *)timeStr{
    SingleStringView *playTimeView = _wordsArray[2];
    [playTimeView setText:timeStr];
}

-(void)createStringView{
    _direction = arc4random() % DIRECTION_NUM;
    NSArray *locationArray;
    if (_direction == 0) {
        locationArray = @[[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_WIDTH / 3), WINDOW_WIDTH / 6)],[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_WIDTH / 3), WINDOW_WIDTH / 2)],[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_WIDTH / 3), WINDOW_WIDTH / 6 * 5 - 20)]];
    } else {
        locationArray = @[[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_HEIGHT / 3), WINDOW_HEIGHT / 6)],[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_HEIGHT / 3), WINDOW_HEIGHT / 2)],[NSNumber numberWithDouble:RANDOMNUM((int)(WINDOW_HEIGHT / 3), WINDOW_HEIGHT / 6 * 5 - 20)]];
    }
    SingleStringView *songNameView = _wordsArray[0];
    songNameView.isMoving = YES;
    songNameView.hidden = NO;
    songNameView.alpha = 1.0;
    [songNameView setText:_musicInfo.title direction:_direction * 2 location:[locationArray[0] floatValue]];
    
    SingleStringView *artistView = _wordsArray[1];
    artistView.isMoving = YES;
    artistView.hidden = NO;
    artistView.alpha = 1.0;
    [artistView setText:_musicInfo.artist direction:_direction * 2 + 1 location:[locationArray[1] floatValue]];
    [self addSubview:artistView];
    
    SingleStringView *playTimeView = _wordsArray[2];
    playTimeView.isMoving = YES;
    playTimeView.hidden = NO;
    playTimeView.alpha = 1.0;
    [playTimeView setText:@"00:00" direction:_direction * 2 location:[locationArray[2] floatValue]];
    [self addSubview:playTimeView];
    
    NSLog(@"location:%f   %f",[locationArray[0] floatValue],[locationArray[2] floatValue]);
    [_wordsMoveTimer invalidate];
    _wordsMoveTimer = [NSTimer scheduledTimerWithTimeInterval:MOVE_INTERVAL target:self selector:@selector(wordsMove:) userInfo:nil repeats:YES];
    //_progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDuration:) userInfo:nil repeats:YES];
}

-(void)wordsMove:(NSTimer*)timer{
    _moveSeconds += MOVE_INTERVAL;
    int staticNum = 0;
    for (SingleStringView *view in _wordsArray) {
        if (view.isMoving) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect newFrame = view.frame;
                if (view.labelDirection == 0) {
                    newFrame.origin.y--;
                    if (_moveSeconds / MOVE_INTERVAL > newFrame.size.height + WINDOW_HEIGHT) {
                        view.isMoving = NO;
                    }
                } else if (view.labelDirection == 1) {
                    newFrame.origin.y++;
                    if (_moveSeconds / MOVE_INTERVAL > newFrame.size.height + WINDOW_HEIGHT) {
                        view.isMoving = NO;
                    }
                } else if (view.labelDirection == 2) {
                    newFrame.origin.x--;
                    // NSLog(@"%f",newFrame.origin.x);
                    if (_moveSeconds / MOVE_INTERVAL > newFrame.size.width + WINDOW_WIDTH) {
                        view.isMoving = NO;
                    }
                } else if (view.labelDirection == 3) {
                    newFrame.origin.x++;
                    if (_moveSeconds / MOVE_INTERVAL > newFrame.size.width + WINDOW_WIDTH) {
                        view.isMoving = NO;
                    }
                }
                view.frame = newFrame;
            });
        } else {
            staticNum++;
        }
    }
    if (staticNum == 3) {
        _moveSeconds = 0.0f;
        [_wordsMoveTimer invalidate];
        //[_progressUpdateTimer invalidate];
        [self createStringView];
    }
}

-(void)timerDuration:(NSTimer*)timer{
    _playSeconds++;
    SingleStringView *playTimeView = _wordsArray[2];
    [playTimeView setText:[NSString stringWithFormat:@"%02d:%02d",(int)_playSeconds/60,(int)_playSeconds%60]];
}

-(void)playNewSong:(MusicModel *)music{
    _musicInfo = music;
//    if (_isStoping) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self performSelector:@selector(createStringView) withObject:nil afterDelay:MOVE_INTERVAL];
//        });
//        //[self performSelector:@selector(creatStringView) withObject:nil afterDelay:MOVE_INTERVAL];
//        //[self performSelectorOnMainThread:@selector(createStringView) withObject:nil afterDelay:MOVE_INTERVAL];
//    } else {
//        [self createStringView];
//    }
    [self createStringView];
}

-(void)stopSong{
//    __block int count = 0;
//    _isStoping = YES;
//    for (SingleStringView *view in _wordsArray) {
//        [UIView animateWithDuration:MOVE_INTERVAL animations:^{
//            view.alpha = 0;
//        } completion:^(BOOL finished) {
//            if (finished) {
//                count++;
//                view.hidden = YES;
//                if (count == 3) {
//                    _playSeconds = 0;
//                    _moveSeconds = 0.0f;
//                    [_wordsMoveTimer invalidate];
//                    //[_progressUpdateTimer invalidate];
//                    _isStoping = NO;
//                }
//            }
//        }];
//    }
    [_wordsMoveTimer invalidate];
}

-(void)pauseSong{
    //[_progressUpdateTimer invalidate];
}

-(void)resumeSong{
    //_progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDuration:) userInfo:nil repeats:YES];
}

@end

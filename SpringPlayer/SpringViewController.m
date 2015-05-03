//
//  ViewController.m
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "SpringViewController.h"
#import "FloatWordsView.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+ImageFill.h"

@interface SpringViewController (){
    //BOOL _isPlaying;
    FloatWordsView *_floatWordsView;
    UIImageView *_singerImageView;
    NSMutableDictionary *_songParams;
    NSMutableArray *_tracks;
    MusicModel *_music;
    UIButton *_likeButton;
    UIButton *_playButton;
    UIButton *_nextButton;
    DOUAudioStreamer *_streamer;
    NSInteger _currentIndex;
    //NSMutableDictionary *_artistPicParams;
}

@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _singerImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_singerImageView setImage:[UIImage imageNamed:@"artist_test"]];
    [self.view addSubview:_singerImageView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.frame];
    [grayView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
    [self.view addSubview:grayView];
    
    _floatWordsView = [[FloatWordsView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_floatWordsView];
    
    UIImageView *bottomBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,WINDOW_HEIGHT - WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE, WINDOW_WIDTH, WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE)];
    [bottomBackground setImage:[UIImage imageNamed:@"bottom_background"]];
    [self.view addSubview:bottomBackground];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 6 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_likeButton setImage:[UIImage imageNamed:@"dislike_button"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"like_bottom"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_likeButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 2 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 6 * 5 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_nextButton setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextSongAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    
    [self initAllValue];
//    MusicModel *music = [[MusicModel alloc] init];
//    music.title = @"七里香";
//    music.artist = @"周杰伦";
    
    
//    UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 90, 50, 30)];
//    [clickButton setTitle:@"click" forState:UIControlStateNormal];
//    [clickButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [clickButton setBackgroundColor:[UIColor whiteColor]];
//    [clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:clickButton];
    //_isPlaying = YES;
}

-(void)likeAction:(UIButton*)button{
    
}

-(void)playAction:(UIButton*)button{
    if ([_streamer status] == DOUAudioStreamerPaused || [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
        [_floatWordsView resumeSong];
        [_playButton setSelected:YES];
    } else {
        [_streamer pause];
        [_floatWordsView pauseSong];
        [_playButton setSelected:NO];
    }
}

-(void)nextSongAction:(UIButton*)button{
    [_likeButton setSelected:NO];
    if ([self reGetTracks]) {
        _currentIndex++;
        [_floatWordsView stopSong];
        [self loadTracks];
    }
}

-(void)initAllValue{
    _currentIndex=0;
    _songParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"n",@"type",@"4",@"channel",nil];
    //_artistPicParams = [@{@"user":@"DeviceUniqueId",@"prod":@"kwplayer_wp_2.8.9.0",@"source":@"kwplayer_wp_2.8.9.0_WinPhoneStore.xap",@"corp":@"kuwo",@"type":@"big_artist_pic",@"pictype":@"url",@"content":@"list",@"name":@"",@"width":@"720",@"height":@"1280"} mutableCopy];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressUpdate:) userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getTracks];
    });
}

-(void)progressUpdate:(NSTimer*)timer{
    if (_streamer.duration == 0.0) {
        [_floatWordsView setTime:@"00:00"];
    } else {
        [_floatWordsView setTime:[NSString stringWithFormat:@"%02d:%02d",(int)_streamer.currentTime/60,(int)_streamer.currentTime%60]];
    }
}

-(void)getTracks{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"current channel--->%@",[_songParams objectForKey:@"channel"]);
    [manager GET:TRACKS_URL parameters:_songParams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseSongs = [responseObject objectForKey:@"song"];
        if (_tracks != nil) {
            [_tracks removeAllObjects];
        }
        _tracks = [NSMutableArray array];
        for (NSDictionary *song in responseSongs) {
            MusicModel *music = [[MusicModel alloc] init];
            music.artist = [song objectForKey:@"artist"];
            music.title = [song objectForKey:@"title"];
            music.sid = [song objectForKey:@"sid"];
            music.url = [NSURL URLWithString:[song objectForKey:@"url"]];
            [_tracks addObject:music];
        }
        int a=0;
        for (MusicModel *temp in _tracks) {
            a++;
            NSLog(@"temp[%d]%@",a,temp.title);
        }
        //读取获得的Tracks
        [self loadTracks];
        NSLog(@"get Tracks success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[getTracks]Network connect failure:error--->%@",error);
    }];
}

-(void)loadTracks{
    [self removeObserverForStreamer];
    _music = [_tracks objectAtIndex:_currentIndex];
    _streamer=[DOUAudioStreamer streamerWithAudioFile:_music];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_floatWordsView playNewSong:_music];
    //[_artistPicParams setValue:_music.artist forKey:@"name"];
    NSURL *picUrl = [NSURL URLWithString:[[self picUrl:_music.artist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:picUrl];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *urlContent = operation.responseString;
        NSArray *urlArray = [urlContent componentsSeparatedByString:@"\r\n"];
        NSURL *singlePicUrl = [NSURL URLWithString:urlArray[0]];
        NSLog(@"%@   %@",urlContent,singlePicUrl);
        [_singerImageView setImageWithURL:singlePicUrl placeholderImage:[UIImage imageNamed:@"artist_test"]];
        [_singerImageView setImageFill];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pic url request error");
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [_playButton setSelected:YES];
    [_streamer play];
}

-(void)removeObserverForStreamer{
    if (_streamer != nil) {
        [_streamer removeObserver:self forKeyPath:@"status"];
        _streamer=nil;
    }
}

-(BOOL)reGetTracks{
    if (_currentIndex == [_tracks count]-1 ) {
        _currentIndex=0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self getTracks];
        });
        return NO;
    }else{
        return YES;
    }
}

//-(void)clickAction:(UIButton*)button{
//    if (_isPlaying) {
//        [_floatWordsView pauseSong];
//        _isPlaying = NO;
//    } else {
//        [_floatWordsView resumeSong];
//        _isPlaying = YES;
//    }
//}


#pragma mark - KVO delegate method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"] ) {
        if ([_streamer status] == DOUAudioStreamerFinished){
            [self performSelector:@selector(nextSongAction:)
                         onThread:[NSThread mainThread]
                       withObject:nil
                    waitUntilDone:NO];
        }
    }
}

-(NSString*)picUrl:(NSString*)artistName{
    return [NSString stringWithFormat:@"http://artistpicserver.kuwo.cn/pic.web?user=DeviceUniqueId&prod=kwplayer_wp_2.8.9.0&source=kwplayer_wp_2.8.9.0_WinPhoneStore.xap&corp=kuwo&type=big_artist_pic&pictype=url&content=list&name=%@&width=720&height=1280",artistName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

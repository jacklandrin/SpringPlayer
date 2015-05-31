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
#import "ChannelModel.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "UIButton+SizeFill.h"
#import "CCColorCube.h"
#import "TrapeziumView.h"
#import "FXBlurView.h"
#import "FMLrcView.h"

@interface SpringViewController (){
    //BOOL _isPlaying;
    FloatWordsView *_floatWordsView;
    
    NSMutableDictionary *_songParams;
    NSMutableDictionary *_loginParameters;
    NSMutableArray *_tracks;
    MusicModel *_music;
    UIButton *_likeButton;
    UIButton *_playButton;
    UIButton *_nextButton;
    DOUAudioStreamer *_streamer;
    NSInteger _currentIndex;
    UIView *_headerView;
    UITableView *_tableView;
    FXBlurView *_navigationView;
    FXBlurView *_lyricsBackgroundView;
    UIButton *_loginButton;
    NSMutableArray *_channels;
    ChannelModel *_channel;
    UILabel *_channelLabel;
    BOOL _isLogin;
    UserModel *_user;
    NSDictionary *_loginMess;
    UIView *_yellowView;
    TrapeziumView *_trapeziumView;
    UIScrollView *_scrollView;
    UIScrollView *_lyricsScrollView;
    FMLrcView *_lyricsView;
    UILabel *_noLyricLabel;
    UIView *_grayView;
    BOOL _islrc;
    //NSMutableDictionary *_artistPicParams;
}
@property (nonatomic,strong) UIImageView *singerImageView;
@property (nonatomic,strong) CCColorCube *colorCube;
@property (nonatomic,strong) UIColor *themeColor;
@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _singerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -20, self.view.frame.size.width + 40, self.view.frame.size.height + 40)];
    [_singerImageView setImage:[UIImage imageNamed:@"artist_test"]];
    [self registerEffectForView:_singerImageView depth:20];
    [self.view addSubview:_singerImageView];
    
    _grayView = [[UIView alloc] initWithFrame:self.view.frame];
    [_grayView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
    [self.view addSubview:_grayView];
    
    _floatWordsView = [[FloatWordsView alloc] initWithFrame:CGRectMake(-10, -10, self.view.frame.size.width + 20, self.view.frame.size.height + 20)];
    [self registerEffectForView:_floatWordsView depth:10];
    [self.view addSubview:_floatWordsView];
    
    _lyricsBackgroundView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
    [_lyricsBackgroundView setTintColor:UI_COLOR_FROM_RGB(0xccc437)];
    [_lyricsBackgroundView setBlurRadius:10];
    [_lyricsBackgroundView setAlpha:0];
    [self.view addSubview:_lyricsBackgroundView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(2 * WINDOW_WIDTH, WINDOW_HEIGHT)];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:_scrollView];
    
    
    
    //------------left view-------------
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT + 64)];
    
//    UIImageView *bottomBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,WINDOW_HEIGHT - WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE, WINDOW_WIDTH, WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE)];
//    [bottomBackground setImage:[UIImage imageNamed:@"bottom_background"]];
    _trapeziumView = [[TrapeziumView alloc] initWithFrame:CGRectMake(0,WINDOW_HEIGHT - WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE, WINDOW_WIDTH, WINDOW_WIDTH * BOTTOM_BACKGROUND_SCALE)];
    //[_trapeziumView setColor:[self themeColorWithAlpha:0.28]];
    [_headerView addSubview:_trapeziumView];
    
    _yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, WINDOW_HEIGHT, WINDOW_WIDTH, 64)];
    [_yellowView setBackgroundColor:[self themeColorWithAlpha:0.28]];
    [_headerView addSubview:_yellowView];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 6 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_likeButton setImage:[UIImage imageNamed:@"dislike_button"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"like_button"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_likeButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 2 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_playButton];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(WINDOW_WIDTH / 6 * 5 - 22, WINDOW_HEIGHT - 70, 44, 44)];
    [_nextButton setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextSongAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_nextButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pagingEnabled = YES;
    _tableView.tag = 1;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableHeaderView = _headerView;
    [_scrollView addSubview:_tableView];
    
    
//    FXBlurView *tableViewBackground = [[FXBlurView alloc] initWithFrame:self.view.frame];
//    [tableViewBackground setBlurRadius:20];
//    [_tableView setBackgroundView:tableViewBackground];
    
    _navigationView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
    [_navigationView setTintColor:UI_COLOR_FROM_RGB(0xccc437)];
    [_navigationView setBlurRadius:10];
    [_navigationView setClipsToBounds:NO];
    //[_navigationView setBackgroundColor:[self themeColorWithAlpha:0.35]];
    [self.view addSubview:_navigationView];
    [_navigationView setHidden:YES];
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, 5)];
    [shadowImageView setImage:[UIImage imageNamed:@"shadow_image"]];
    [shadowImageView setAlpha:0.3];
    [_navigationView addSubview:shadowImageView];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 60, 20)];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_loginButton setTintColor:[UIColor whiteColor]];
    [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_loginButton addTarget:self action:@selector(presentLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_loginButton];
    
    _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, WINDOW_WIDTH, 25)];
    [_channelLabel setText:@"频道"];
    [_channelLabel setTextColor:[UIColor whiteColor]];
    [_channelLabel setTextAlignment:NSTextAlignmentCenter];
    [_channelLabel setFont:[UIFont systemFontOfSize:25]];
    [_navigationView addSubview:_channelLabel];
    
    
    //---------------right view--------------
    _lyricsView = [[FMLrcView alloc] initWithFrame:CGRectMake(WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    [_scrollView addSubview:_lyricsView];
    
    _noLyricLabel = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_WIDTH, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 40)];
    [_noLyricLabel setTextColor:[UIColor whiteColor]];
    [_noLyricLabel setTextAlignment:NSTextAlignmentCenter];
    [_noLyricLabel setText:@"无歌词"];
    [_scrollView addSubview:_noLyricLabel];
    
    UIButton *changeLyricButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * WINDOW_WIDTH - 64, WINDOW_HEIGHT - 64, 44, 44)];
    [changeLyricButton setImage:[UIImage imageNamed:@"change_lyric"] forState:UIControlStateNormal];
    [changeLyricButton addTarget:self action:@selector(changeLyricAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:changeLyricButton];
    
    [self initAllValue];
}


- (void)registerEffectForView:(UIView *)aView depth:(CGFloat)depth;
{
    
    UIInterpolatingMotionEffect *effectY;
    effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.maximumRelativeValue = @(depth);
    effectY.minimumRelativeValue = @(-depth);
    [aView addMotionEffect:effectY];
    UIInterpolatingMotionEffect *effectX;
    effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.maximumRelativeValue = @(depth);
    effectX.minimumRelativeValue = @(-depth);
    
    
    [aView addMotionEffect:effectX];
    
}

-(void)presentLoginVC:(UIButton*)button{
    //if (!_isLogin) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [nvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:nvc animated:YES completion:nil];
    //}
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    ChannelModel *channel = _channels[indexPath.row];
    [cell.textLabel setText:channel.name];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    //[cell setBackgroundColor:UI_COLOR_FROM_RGBA(0xccc437, 0.28)];
    [cell setBackgroundColor:[self themeColorWithAlpha:0.28]];
    return cell;
}

-(UIColor*)themeColorWithAlpha:(CGFloat)aplha{
    if (self.themeColor == nil) {
        return UI_COLOR_FROM_RGBA(0xccc437,aplha);
    } else {
        return [self.themeColor colorWithAlphaComponent:aplha];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelModel *channel = _channels[indexPath.row];
    [_songParams setValue:channel.channelID forKey:@"channel"];
    [_channelLabel setText:channel.name];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getTracks];
    });
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) {
        NSLog(@"  000,%f,%f",scrollView.contentOffset.y,WINDOW_HEIGHT);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (scrollView.contentOffset.y == 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    _navigationView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [_navigationView setHidden:YES];
                    }
                }];
            } else if (scrollView.contentOffset.y == WINDOW_HEIGHT){
                [_navigationView setHidden:NO];
                [UIView animateWithDuration:0.3 animations:^{
                    _navigationView.alpha = 1.0;
                }];
            }
        });
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < WINDOW_HEIGHT + 1) {
        [scrollView setPagingEnabled:YES];
    } else {
        [scrollView setPagingEnabled:NO];
    }
}

-(void)likeAction:(UIButton*)button{
    NSString *loveURL=@"http://douban.fm/j/app/radio/people";
    NSMutableDictionary *loveParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"n",@"type",@"4",@"channel",nil];
    [loveParameters setObject:@"r" forKey:@"type"];
    [loveParameters setObject:_music.sid forKey:@"sid"];
    if (_loginMess != nil) {
        [loveParameters setObject:[_loginMess objectForKey:@"user_id"] forKey:@"user_id"];
        [loveParameters setObject:[_loginMess objectForKey:@"expire"] forKey:@"expire"];
        [loveParameters setObject:[_loginMess objectForKey:@"token"] forKey:@"token"];
    }
    AFHTTPSessionManager *loveManager=[AFHTTPSessionManager manager];
    [loveManager GET:loveURL parameters:loveParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self.unLove setTitle:@"Love" forState:UIControlStateNormal];
        [_likeButton setSelected:YES];
        NSLog(@"Love is success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error%@",error);
    }];
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
        [_lyricsView selfClearKeyAndTitle];
        [self loadTracks];
    }
}


-(void)initAllValue{
    _currentIndex = 0;
    _colorCube = [[CCColorCube alloc] init];
    [_singerImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _songParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"n",@"type",@"4",@"channel",nil];
    _loginParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name",
                     @"100",@"version", nil];
    //_artistPicParams = [@{@"user":@"DeviceUniqueId",@"prod":@"kwplayer_wp_2.8.9.0",@"source":@"kwplayer_wp_2.8.9.0_WinPhoneStore.xap",@"corp":@"kuwo",@"type":@"big_artist_pic",@"pictype":@"url",@"content":@"list",@"name":@"",@"width":@"720",@"height":@"1280"} mutableCopy];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressUpdate:) userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getTracks];
        [self getChannels];
    });
    _user = [[UserModel alloc] init];
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (_isLogin) {
        _user.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        _user.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        _user.nickName = [[NSUserDefaults standardUserDefaults] stringForKey:@"nickname"];
        [_loginParameters setObject:_user.username forKey:@"email"];
        [_loginParameters setObject:_user.password forKey:@"password"];
        //[_loginButton setTitle:_user.nickName forState:UIControlStateNormal];
        [_loginButton setText:_user.nickName];
    }
}

-(void)progressUpdate:(NSTimer*)timer{
    if (_streamer.duration == 0.0) {
        [_floatWordsView setTime:@"00:00"];
    } else {
        [_floatWordsView setTime:[NSString stringWithFormat:@"%02d:%02d",(int)_streamer.currentTime/60,(int)_streamer.currentTime%60]];
    }
    NSString *timeStr =[self TimeformatFromSeconds:_streamer.currentTime];
    if (_islrc) {
        [_lyricsView scrollViewMoveLabelWith:timeStr];
    }
}

-(NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h==0) {
        return  [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}


-(void)getChannels{
    NSString *url=@"http://douban.fm/j/app/radio/channels";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    if (_channels != nil) {
        _channels = nil;
    }
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseChannels=[responseObject objectForKey:@"channels"];
        _channels=[NSMutableArray array];
        for (NSDictionary *dicChannels in responseChannels) {
            //依次赋值给channel
            _channel=[[ChannelModel alloc] init];
            _channel.name=[dicChannels objectForKey:@"name"];
            _channel.channelID=[dicChannels objectForKey:@"channel_id"];
            [_channels addObject:_channel];
        }
        [_tableView reloadData];
        NSLog(@"get Channels success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[getChannels]Network connect failure:error--->%@",error);
    }];
}

-(void)getTracks{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"current channel--->%@",[_songParams objectForKey:@"channel"]);
    [manager GET:TRACKS_URL parameters:_songParams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"track:%@",responseObject);
        NSArray *responseSongs = [responseObject objectForKey:@"song"];
        if (_tracks != nil) {
            [_tracks removeAllObjects];
        }
        _tracks = [NSMutableArray array];
        for (int i = 0;i < responseSongs.count;i++) {
            NSDictionary *song = responseSongs[i];
            MusicModel *music = [[MusicModel alloc] init];
            music.artist = [song objectForKey:@"artist"];
            music.title = [song objectForKey:@"title"];
            music.sid = [song objectForKey:@"sid"];
            music.url = [NSURL URLWithString:[song objectForKey:@"url"]];
            music.isLike = [[song objectForKey:@"like"] boolValue];
            [_tracks addObject:music];
            
            [[AFHTTPSessionManager manager] GET:[self lrcUrl:music.title] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == 0 && [responseObject[@"count"] intValue] > 0) {
                    NSArray *resultArray = responseObject[@"result"];
                    music.lyric.count = [responseObject[@"count"] integerValue];
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < music.lyric.count; i++) {
                        [tempArray addObject:resultArray[i][@"lrc"]];
                    }
                    music.lyric.lyrics = tempArray;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:music.lyric.lyrics[0]]];
                        [data writeToFile:[DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",music.sid]] atomically:YES];
                        if (i == responseSongs.count - 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self loadLyric];
                            });
                        }
                    });
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"lrc download error");
            }];
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
    NSURLRequest *picRequest = [NSURLRequest requestWithURL:picUrl];
    AFHTTPRequestOperation *picOperation = [[AFHTTPRequestOperation alloc] initWithRequest:picRequest];
    [picOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *urlContent = operation.responseString;
        NSArray *urlArray = [urlContent componentsSeparatedByString:@"\r\n"];
        int imageIndex = arc4random()%urlArray.count;
        NSURL *singlePicUrl = [NSURL URLWithString:urlArray[imageIndex]];
        NSLog(@"%@   %@",urlContent,singlePicUrl);
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.singerImageView setImageWithURL:singlePicUrl placeholderImage:[UIImage imageNamed:@"artist_test"]];
            [weakSelf.singerImageView setImageFill];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pic url request error");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:picOperation];
    
    if (_currentIndex != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadLyric];
        });
    }

    [_playButton setSelected:YES];
    [_streamer play];
    [_likeButton setSelected:_music.isLike];
}

-(void)loadLyric{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *lrcStr = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",_music.sid]];
    [_lyricsView selfClearKeyAndTitle];
    if ([fileManager fileExistsAtPath:lrcStr]) {
        [_lyricsView setLrcSourcePath:lrcStr];
        _islrc = YES;
        [_noLyricLabel setHidden:YES];
    } else {
        _islrc = NO;
        [_noLyricLabel setHidden:NO];
    }
}

-(void)changeLyricAction:(UIButton*)button{
    if (_music.lyric.count > 0) {
        if (_music.lyric.currentIndex < _music.lyric.count - 1) {
            _music.lyric.currentIndex++;
        } else {
            _music.lyric.currentIndex = 0;
        }
        NSLog(@"num:%zd/%zd",_music.lyric.currentIndex,_music.lyric.count);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){
            NSLog(@"load lyric:%@",_music.lyric.lyrics[_music.lyric.currentIndex]);
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_music.lyric.lyrics[_music.lyric.currentIndex]]];
            [data writeToFile:[DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",_music.sid]] atomically:YES];

            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"歌词更新成功" dismissAfter:1 styleName:JDStatusBarStyleWarning];
                [self loadLyric];
            });
            
        });
    }
}

-(void)setThemeColor:(UIColor *)themeColor{
    _themeColor = themeColor;
    [_yellowView setBackgroundColor:[self themeColorWithAlpha:0.28]];
    [_navigationView setTintColor:self.themeColor];
    [_trapeziumView setColor:[self themeColorWithAlpha:0.28]];
    [_lyricsBackgroundView setTintColor:[self themeColorWithAlpha:0.28]];
    [_lyricsView setHighlightColor:self.themeColor];
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


-(void)getLogin:(LoginViewController *)controller{
    NSString *url=@"http://www.douban.com/j/app/login";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:url parameters:_loginParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        _loginMess=(NSDictionary *)responseObject;
        NSLog(@"login info:%@",_loginMess);
        if ( [[[_loginMess objectForKey:@"r"] stringValue] isEqualToString:@"0"] ) {
            //登陆成功
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [_songParams setObject:[_loginMess objectForKey:@"user_id"] forKey:@"user_id"];
            [_songParams setObject:[_loginMess objectForKey:@"expire"] forKey:@"expire"];
            [_songParams setObject:[_loginMess objectForKey:@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setValue:controller.usernameTextField.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:controller.passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:_loginMess[@"user_name"] forKey:@"nickname"];
            //[_loginButton setTitle:_loginMess[@"user_name"] forState:UIControlStateNormal];
            [_loginButton setText:_loginMess[@"user_name"]];
            _user.nickName = controller.usernameTextField.text;
            _user.password = controller.passwordTextField.text;
            _user.nickName = _loginMess[@"user_name"];
//            [self.navigationItem setTitle:[_loginMess objectForKey:@"user_name"]];
//            [self deleteCoreData];
//            [self insertCoreData];
            [controller dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"login success");
            
        }else if ( [[[_loginMess objectForKey:@"r"] stringValue] isEqualToString:@"1"] ){
            //登陆失败
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            //[self deleteCoreData];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Login failure" message:[NSString stringWithFormat:@"%@",[_loginMess objectForKey:@"err"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [controller.usernameTextField setText:@""];
            [controller.passwordTextField setText:@""];
            NSLog(@"login failure");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //网络连接失败
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        NSLog(@"[getLogin]Network connect failure:error--->%@",error);
    }];
}


-(void)loginViewControllerDidCancel:(LoginViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginViewControllerDidSave:(LoginViewController *)controller{
    if (controller.usernameTextField.text.length != 0 && controller.passwordTextField.text.length != 0) {
        [_loginParameters setObject:controller.usernameTextField.text forKey:@"email"];
        [_loginParameters setObject:controller.passwordTextField.text forKey:@"password"];
        [self getLogin:controller];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Login failure" message:@"Please enter the email address and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - KVO delegate method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"] ) {
        if ([_streamer status] == DOUAudioStreamerFinished){
            [self performSelector:@selector(nextSongAction:)
                         onThread:[NSThread mainThread]
                       withObject:nil
                    waitUntilDone:NO];
        }
    } else if ([keyPath isEqualToString:@"image"]) {
        NSLog(@"%@",change);
        UIImage *image = change[@"new"];
        NSArray *extractedColors = [self.colorCube extractBrightColorsFromImage:image avoidColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] count:1];
        self.themeColor = [extractedColors objectAtIndex:0];
        [_tableView reloadData];
    } else if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat alpha = [change[@"new"] CGPointValue].x / WINDOW_WIDTH;
        [_lyricsBackgroundView setAlpha:alpha];
        [_grayView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2 + alpha * 0.5]];
        //[_trapeziumView setAlpha:1.0 / alpha];
    }
}

-(NSString*)picUrl:(NSString*)artistName{
    return [NSString stringWithFormat:@"http://artistpicserver.kuwo.cn/pic.web?user=DeviceUniqueId&prod=kwplayer_wp_2.8.9.0&source=kwplayer_wp_2.8.9.0_WinPhoneStore.xap&corp=kuwo&type=big_artist_pic&pictype=url&content=list&name=%@&width=720&height=1280",artistName];
}

-(NSString*)lrcUrl:(NSString*)songName{
    return [[NSString stringWithFormat:@"http://geci.me/api/lyric/%@",songName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

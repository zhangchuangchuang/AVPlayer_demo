//
//  ViewController.m
//  play_demo
//
//  Created by 张闯闯 on 2020/4/1.
//  Copyright © 2020 张闯闯. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "playerView.h"
#import "popView.h"
@interface ViewController () {
    BOOL _played;
    NSString *_totalTime;
    NSDateFormatter *_dateFormatter;
}

@property (strong, nonatomic) AVPlayer *player;//播放器
@property (strong, nonatomic) AVPlayerItem *playerItem;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面
@property (nonatomic ,strong) IBOutlet playerView *playerView;
@property (strong, nonatomic) IBOutlet UIView *bottom_view;
@property (strong, nonatomic) IBOutlet UIButton *statu_btn;
@property (strong, nonatomic) IBOutlet UIProgressView *progress_view;
@property (strong, nonatomic) IBOutlet UILabel *time_lab;
@property (strong, nonatomic) popView *popView;
@property (nonatomic ,strong) id playbackTimeObserver;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//初始化界面

- (void)setUI{
    NSURL *videoUrl = [NSURL URLWithString:@"https://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4"];
      self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
      [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
      [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
      self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
      self.playerView.player = _player;
//      self.statu_btn.enabled = NO;
    // 添加视频播放结束通知
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    self.popView = [[popView alloc]initWithFrame:self.view.bounds];
    self.popView.backgroundColor = [UIColor redColor];
    
}
//按钮点击事件
- (IBAction)statuAction:(UIButton *)sender {
    if (!_played) {
           [self.playerView.player play];
           [self.statu_btn setTitle:@"Stop" forState:UIControlStateNormal];
       } else {
           [self.playerView.player pause];
           [self.statu_btn setTitle:@"Play" forState:UIControlStateNormal];
       }
       _played = !_played;
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    A
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//        [weakSelf.videoSlider setValue:currentSecond animated:YES];
        
        if(currentSecond ==5.00){
            [self.playerView.player pause];
            [self.statu_btn setTitle:@"Play" forState:UIControlStateNormal];
            [self.view addSubview:self.popView];
        }
        
//        [weakSelf.progress_view setProgress:currentSecond animated:YES];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        NSLog(@"=========%f",currentSecond);
        weakSelf.time_lab.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
    }];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.statu_btn.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
//            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
//        NSLog(@"Time Interval:%f",timeInterval);
//        CMTime duration = _playerItem.duration;
//        CGFloat totalDuration = CMTimeGetSeconds(duration);
    }
}


//- (void)customVideoSlider:(CMTime)duration {
//    self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
//    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
//    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
//    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
//}
//


//- (IBAction)videoSlierChangeValue:(id)sender {
//    UISlider *slider = (UISlider *)sender;
//    NSLog(@"value change:%f",slider.value);
//
//    if (slider.value == 0.000000) {
//        __weak typeof(self) weakSelf = self;
//        [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//            [weakSelf.playerView.player play];
//        }];
//    }
//}

//- (IBAction)videoSlierChangeValueEnd:(id)sender {
//    UISlider *slider = (UISlider *)sender;
//    NSLog(@"value end:%f",slider.value);
//    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
//
//    __weak typeof(self) weakSelf = self;
//    [self.playerView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
//        [weakSelf.playerView.player play];
//        [weakSelf.statu_btn setTitle:@"Stop" forState:UIControlStateNormal];
//    }];
//}

- (void)updateVideoSlider:(CGFloat)currentSecond {
//    [self.videoSlider setValue:currentSecond animated:YES];
    
}


- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak typeof(self) weakSelf = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.progress_view setProgress:0.0 animated:YES];
        [weakSelf.statu_btn setTitle:@"Play" forState:UIControlStateNormal];
    }];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

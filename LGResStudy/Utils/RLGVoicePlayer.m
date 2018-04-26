//
//  RLGVoicePlayer.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/18.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "RLGCommon.h"

@interface RLGVoicePlayer ()
{
    // 标记是否正在播放
    BOOL wIsPlaying;
    // 播放时间观察者
    id wTimeObserver;
}
@property (nonatomic,strong) AVPlayer *player;
@end
@implementation RLGVoicePlayer
#pragma mark public
- (void)play{
    wIsPlaying = YES;
    [self removeTimeObserver];
    [self.player play];
    [self addTimeObserVer];
}
- (void)pause{
    wIsPlaying = NO;
    [self.player pause];
}
- (void)stop{
    [self pause];
    [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)];
    [self removeTimeObserver];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}
- (void)seekToTime:(float)time isPlay:(BOOL) isPlay{
    [self pause];
    __weak typeof(self) weakSelf = self;
    CMTime cmTime = CMTimeMakeWithSeconds(time, self.player.currentTime.timescale);
    [self.player seekToTime:cmTime completionHandler:^(BOOL finished) {
        // 拖动结束后音乐重新播放
        if (finished) {
            if (weakSelf.SeekFinishBlock) {
                weakSelf.SeekFinishBlock();
            }
            if (isPlay) {
                [weakSelf play];
            }
        }
    }];
}
- (void)seekToTime:(float)time{
    [self seekToTime:time isPlay:YES];
}
- (BOOL)isPlaying{
    return wIsPlaying;
}
- (BOOL)isPlayingWithUrl:(NSString *)urlString{
    NSString *url = [(AVURLAsset *)self.player.currentItem.asset URL].absoluteString;
    BOOL isEqual = [url isEqualToString:urlString];
    return isEqual;
}
- (void)setPlayerWithUrlString:(NSString *)urlString{
    [self setplayerWithUrl:[NSURL URLWithString:urlString]];
}
- (void)setPlayerWithPath:(NSString *)path{
    [self setplayerWithUrl:[NSURL fileURLWithPath:path]];
}
- (void)setplayerWithUrl:(NSURL *) url{
    if (self.PlayStartBlock) {
        self.PlayStartBlock();
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    [self removeNotification];
    if (!RLG_IsEmpty([(AVURLAsset *)self.player.currentItem.asset URL].absoluteString)) {
        [self removeObserverFromPlayerItem:self.player.currentItem];
    }
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:url];
    [self addObserverToPlayerItem:currentItem];
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
    [self addNotification];
}
#pragma mark private
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:RLGStopPlayerNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RLGStopPlayerNotification object:nil];
}
- (void)applicationDidEnterBackground:(NSNotification *) noti{
    [self pause];
}
- (void)handleEndTimeNotification:(NSNotification *) noti{
    wIsPlaying = NO;
    if (self.PlayFinishBlock) {
        self.PlayFinishBlock();
    }
}
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [RLGVoicePlayer yj_addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil atObj:playerItem];
    //监控网络加载情况属性
    [RLGVoicePlayer yj_addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil atObj:playerItem];
    //播放已经消耗了所有缓冲的媒体和回放将停止或结束
    [RLGVoicePlayer yj_addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil atObj:playerItem];
    [RLGVoicePlayer yj_addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil atObj:playerItem];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [RLGVoicePlayer yj_removeObserver:self forKeyPath:@"status" atObj:playerItem];
    [RLGVoicePlayer yj_removeObserver:self forKeyPath:@"loadedTimeRanges" atObj:playerItem];
    [RLGVoicePlayer yj_removeObserver:self forKeyPath:@"playbackBufferEmpty" atObj:playerItem];
     [RLGVoicePlayer yj_removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" atObj:playerItem];
    [playerItem cancelPendingSeeks];
    [playerItem.asset cancelLoading];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if([keyPath isEqualToString:@"status"]){
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            //只有在播放状态才能获取视频时间长度
            NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
            if (self.TotalDurationBlock) {
                self.TotalDurationBlock(duration);
            }
        }else{// 失败
            wIsPlaying = NO;
            [self stop];
            if (self.PlayFailBlock) {
                self.PlayFailBlock();
            }
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        if (self.TotalBufferBlock) {
            self.TotalBufferBlock(totalBuffer);
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if (playerItem.playbackBufferEmpty) {
            NSLog(@"bufEmpty--YES");
        }else{
            NSLog(@"bufEmpty---NO");
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        if (playerItem.playbackLikelyToKeepUp) {
            NSLog(@"keepUp--YES");
        }else{
            NSLog(@"keepUp---NO");
        }
        if (self.PlaybackLikelyToKeepUpBlock) {
            self.PlaybackLikelyToKeepUpBlock(playerItem.playbackLikelyToKeepUp);
        }
    }
}

- (void)addTimeObserVer{
    __weak typeof(self) weakSelf = self;
    wTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        if (weakSelf.PlayProgressBlock) {
            weakSelf.PlayProgressBlock(currentTime);
        }
    }];
}
-(void)removeTimeObserver{
    if (wTimeObserver){
        [self.player removeTimeObserver:wTimeObserver];
        wTimeObserver = nil;
    }
}

// 交换后的方法
+ (void)yj_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath atObj:(NSObject *) obj{
    if ([self observerKeyPath:keyPath atObj:obj]) {
        [obj removeObserver:observer forKeyPath:keyPath];
    }
}
// 交换后的方法
+ (void)yj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context atObj:(NSObject *) obj{
    if (![self observerKeyPath:keyPath atObj:obj]) {
        [obj addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}
// 进行检索获取Key
+ (BOOL)observerKeyPath:(NSString *)key atObj:(NSObject *) obj{
    id info = obj.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark getter
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0;
    }
    return _player;
}
@end

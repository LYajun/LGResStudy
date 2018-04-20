//
//  DLGPlayer.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "DLGCommon.h"

@interface DLGPlayer ()
@property (nonatomic,strong) AVPlayer *player;
@end
@implementation DLGPlayer
+ (DLGPlayer *)shareInstance{
    static DLGPlayer * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[DLGPlayer alloc]init];
    });
    return macro;
}
- (instancetype)init{
    if (self = [super init]) {
       
    }
    return self;
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)applicationDidEnterBackground:(NSNotification *) noti{
    [self stop];
}
- (void)handleEndTimeNotification:(NSNotification *) noti{
    [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerDidFinishPlayNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)startPlayWithUrl:(NSString *)url{
    DLG_Log(url);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    [self removeNotification];
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
     [self addNotification];
}
- (void)play{
    [self.player play];
}
- (void)stop{
    [self.player pause];
    self.player = nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerDidFinishPlayNotification object:nil];
    [self removeNotification];
}
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0;
    }
    return _player;
}

@end

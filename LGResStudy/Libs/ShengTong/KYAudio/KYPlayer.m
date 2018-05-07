//
//  KYPlayer.m
//  KouyuDemo
//
//  Created by Attu on 2017/12/26.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "KYPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface KYPlayer ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation KYPlayer

- (void)playWithPath:(NSString *)wavPath {
    if ([wavPath length] == 0) {
        return;
    }
    
    NSURL *audioURL = [NSURL fileURLWithPath:wavPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    
    [self.player prepareToPlay];
    [self.player play];
}

@end

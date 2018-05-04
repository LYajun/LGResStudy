//
//  YJPlayModel.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJPlayModel.h"
#import <Masonry/Masonry.h>
#import <SGPlayer/SGPlayer.h>
@interface YJPlayModel ()
@property (nonatomic, strong) SGPlayer *player;
@end
@implementation YJPlayModel

#pragma mark - public action
- (void)setIsSilence:(BOOL)isSilence{
    _isSilence = isSilence;
    if (isSilence) {
        self.player.volume = 0;
    }else{
        self.player.volume = 1.0;
    }
}
- (void)startPlayWithUrl:(NSString *)url{
    [self.player replaceVideoWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
}
- (void)startPlayWithPath:(NSString *)path{
    [self.player replaceVideoWithURL:[NSURL fileURLWithPath:path]];
}
- (void)play{
    [self.player play];
}
- (void)pause{
    [self.player pause];
}
- (void)stop{
    [self.player stop];
}
- (void)playSlideSeekToTimeAtSlideValue:(CGFloat)slideValue{
    [self.player seekToTime:self.player.duration*slideValue];
}
#pragma mark - private action
- (void)stateAction:(NSNotification *)notification{
     SGState * state = [SGState stateFromUserInfo:notification.userInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerState:)]) {
        [self.delegate playerState:(YJPlayerState)state.current];
    }
}
- (void)progressAction:(NSNotification *)notification{
     SGProgress * progress = [SGProgress progressFromUserInfo:notification.userInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerProgress:)]) {
        [self.delegate playerProgress:progress.percent];
    }
}
- (void)playableAction:(NSNotification *)notification{
     SGPlayable * playable = [SGPlayable playableFromUserInfo:notification.userInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBufferValue:)]) {
        [self.delegate playerBufferValue:playable.current];
    }
}
- (void)errorAction:(NSNotification *)notification{
    SGError * error = [SGError errorFromUserInfo:notification.userInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerErrorInfo:)]) {
        [self.delegate playerErrorInfo:error.error.localizedDescription];
    }
}
#pragma mark - setter getter
- (CGFloat)duration{
   return self.player.duration;
}
- (void)setOwnView:(UIView *)ownView{
    _ownView = ownView;
    [ownView insertSubview:self.player.view atIndex:0];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ownView);
    }];
}
- (SGPlayer *)player{
    if (!_player) {
        _player = [SGPlayer player];
        _player.view.userInteractionEnabled = NO;
        [_player registerPlayerNotificationTarget:self
                                          stateAction:@selector(stateAction:)
                                       progressAction:@selector(progressAction:)
                                       playableAction:@selector(playableAction:)
                                          errorAction:@selector(errorAction:)];
//        [_player setViewTapAction:^(SGPlayer * _Nonnull player, SGPLFView * _Nonnull view) {
//            NSLog(@"player display view did click!");
//        }];
    }
    return _player;
}
@end

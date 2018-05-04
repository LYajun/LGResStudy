//
//  YJPlayModel.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 视频播放状态 */
typedef NS_ENUM(NSInteger,YJPlayerState) {
    YJPlayerStateNone,
    YJPlayerStateBuffering,
    YJPlayerStateReadyToPlay,
    YJPlayerStatePlaying,
    YJPlayerStateSuspend,
    YJPlayerStateFinished,
    YJPlayerStateFailed
};

@protocol YJPlayModelDelegate <NSObject>

@optional
/** 视频播放状态 */
- (void)playerState:(YJPlayerState) playerState;
/** 播放进度 */
- (void)playerProgress:(CGFloat) progress;
/** 缓存进度 */
- (void)playerBufferValue:(CGFloat) bufferValue;
/** 播放错误 */
- (void)playerErrorInfo:(NSString *) errorInfo;
@end

@interface YJPlayModel : NSObject
/** 空页面所在视图 */
@property (nonatomic,strong) UIView *ownView;
/** 是否静音 */
@property (nonatomic,assign) BOOL isSilence;
/** 播放代理 */
@property (nonatomic,assign) id<YJPlayModelDelegate> delegate;
- (void)startPlayWithUrl:(NSString *) url;
- (void)startPlayWithPath:(NSString *) path;
- (CGFloat)duration;
- (void)play;
- (void)pause;
- (void)stop;
/** 滑块拖动播放 */
- (void)playSlideSeekToTimeAtSlideValue:(CGFloat) slideValue;
@end

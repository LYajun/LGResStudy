//
//  RLGVoicePlayer.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/18.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RLGVoicePlayer : NSObject

@property (nonatomic,copy) void (^TotalDurationBlock) (CGFloat totalDuration);
@property (nonatomic,copy) void (^TotalBufferBlock) (CGFloat totalBuffer);
@property (nonatomic,copy) void (^PlayProgressBlock) (CGFloat progress);
@property (nonatomic,copy) void (^PlayFinishBlock) (void);
@property (nonatomic,copy) void (^SeekFinishBlock) (void);
@property (nonatomic,copy) void (^PlayFailBlock) (void);


/** 播放 */
- (void)play;
/** 暂停 */
- (void)pause;
/** 停止 */
- (void)stop;
/** 根据URL设置播放器 */
- (void)setPlayerWithUrlString:(NSString *) urlString;
- (void)setPlayerWithPath:(NSString *)path;
/** 在指定时间播放 */
- (void)seekToTime:(float) time;
/** 判断当前音乐是否正在播放 */
- (BOOL)isPlaying;
/** 判断是否正在播放指定的音乐 */
- (BOOL)isPlayingWithUrl:(NSString *)urlString;

+ (RLGVoicePlayer *)shareInstance;
@end

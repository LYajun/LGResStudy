//
//  YJPlayerView.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJBasePlayerView.h"
#import "RLGResModel.h"
@interface YJPlayerView : YJBasePlayerView
/** 标题 */
@property (nonatomic,copy) NSString *videoTitle;
/** 是否隐藏返回按钮 */
@property (nonatomic,assign) BOOL isHideBakcBtn;
/** 是否显示字幕 */
@property (nonatomic,assign) BOOL isShowDub;
/** 是否为配音模式 */
@property (nonatomic,assign) BOOL isDubMode;
/** 当前配音索引 */
@property (nonatomic,assign) NSInteger dubIndex;
/** 是否静音 */
@property (nonatomic,assign) BOOL isSilence;
/** 退出按钮点击事件回调 */
@property (nonatomic,copy) void (^BackClickBlock) (void);
/** 设置资料地址及是否马上播放 */
- (void)setVideoUrl:(NSString *) url isPlay:(BOOL) isPlay;
- (void)stop;
- (void)pause;
- (void)play;
/** 字幕数组模型 */
@property (nonatomic,assign) NSArray<RLGResVideoModel *> *subTitleModels;
@end




//
//  YJPlayerView.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJBasePlayerView.h"

@interface YJPlayerView : YJBasePlayerView
/** 标题 */
@property (nonatomic,copy) NSString *videoTitle;
/** 退出按钮点击事件回调 */
@property (nonatomic,copy) void (^BackClickBlock) (void);
/** 设置资料地址及是否马上播放 */
- (void)setVideoUrl:(NSString *) url isPlay:(BOOL) isPlay;
@end




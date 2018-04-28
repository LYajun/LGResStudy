//
//  YJPlayStatus.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJPlayStatus : NSObject
/** 空页面所在视图 */
@property (nonatomic,strong) UIView *ownView;
/** 开始播放 */
@property (nonatomic,copy) void (^StartPlayBlock) (void);
/** 播放完成点击重播 */
@property (nonatomic,copy) void (^AgainPlayBlock) (void);
/** 加载失败点击刷新 */
@property (nonatomic,copy) void (^LoadErrorUpdateBlock) (void);

+ (YJPlayStatus *)sharePlayStatus;
/** 开始播放 */
- (void)setViewPlayShow:(BOOL)show;
/** 暂停提示 */
- (void)showViewPause;
/** 播放完成 */
- (void)setViewFinishShow:(BOOL)show;
/** 发生错误 */
- (void)setViewLoadErrorShow:(BOOL)show;
/** 快进 */
- (void)setViewPlaySpeedShow:(BOOL)show;
/** 快退 */
- (void)setViewPlayBackShow:(BOOL)show;
@end

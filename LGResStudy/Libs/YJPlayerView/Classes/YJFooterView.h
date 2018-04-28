//
//  YJFooterView.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFooterViewDelegate <NSObject>
@optional
- (void)progressSliderDidTouchDown;
- (void)progressSliderDidTouchUpWithValue:(CGFloat) sliderValue;
- (void)playBtnDidClickWithIsPlayStatus:(BOOL) isPlayStatus;
- (void)fullBtnDidClick;
- (void)lockBtnDidClickWithIsLockStatus:(BOOL) isLockStatus;
@end
@interface YJFooterView : UIView

@property (nonatomic,assign) id<YJFooterViewDelegate> delegate;
/** 是否全屏模式 */
@property (nonatomic,assign) BOOL isFullScreen;
/** 总时间 */
@property (nonatomic,assign) NSInteger duration;
/** 当前时间 */
@property (nonatomic,assign) NSInteger currentTime;
/** 当前缓存进度 */
@property (nonatomic,assign) CGFloat bufferValue;
/** 播放进度 */
@property (nonatomic,assign) CGFloat playProgress;
/** 暂停/继续 */
@property (nonatomic,assign) BOOL isPause;

/** 是否正在显示 */
@property (nonatomic,assign) BOOL isShowing;
- (void)show;
- (void)hide;
@end

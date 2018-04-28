//
//  YJPlayerView.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJPlayerView.h"
#import "YJHeaderView.h"
#import "YJFooterView.h"
#import "YJBrightnessView.h"
#import <Masonry/Masonry.h>
#import "YJPlayStatus.h"

@interface YJPlayerView ()<YJPlayModelDelegate,YJFooterViewDelegate,YJHeaderViewDelegate>
@property (nonatomic, strong) YJHeaderView *headerView;
@property (nonatomic, strong) YJFooterView *footerView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
/** 滑块是否按下 */
@property (nonatomic, assign) BOOL progressSilderTouching;
/** 记录通过url赋值，是否立即开始播放 */
@property (nonatomic, assign) BOOL isImmediatelyPlay;
/** 记录播放状态 */
@property (nonatomic,assign) YJPlayerState playState;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign)PanDirection panDirection;
@property (nonatomic, copy)NSString *currentUrl;

@property(nonatomic,assign) CGFloat sumTime;
@property(nonatomic,assign) CGFloat currentTimeValue;
/** 音量调节 */
@property(nonatomic,assign) BOOL isVolume;
@end
@implementation YJPlayerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layoutUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    [YJPlayStatus sharePlayStatus].ownView = self;
    __weak typeof(self) weakSelf = self;
    // 播放失败
    [YJPlayStatus sharePlayStatus].LoadErrorUpdateBlock = ^{
        [weakSelf.playModel startPlayWithUrl:weakSelf.currentUrl];
    };
    // 开始播放
    [YJPlayStatus sharePlayStatus].StartPlayBlock = ^{
        weakSelf.isImmediatelyPlay = YES;
        if (weakSelf.footerView.duration > 0) {
            [weakSelf play];
        }else{
            [weakSelf.indicatorView startAnimating];
        }
    };
    // 重新播放
    [YJPlayStatus sharePlayStatus].AgainPlayBlock = ^{
        weakSelf.footerView.currentTime = 0;
        [weakSelf.playModel playSlideSeekToTimeAtSlideValue:0];
    };
    
    self.playModel = [[YJPlayModel alloc] init];
    self.playModel.ownView = self;
    self.playModel.delegate = self;
    
    
}
- (void)layoutUI{
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [YJBrightnessView showBrightnessViewAtView:self];
}
#pragma mark - public action
- (void)setVideoUrl:(NSString *)url isPlay:(BOOL)isPlay{
    self.currentUrl = url;
    self.isImmediatelyPlay = isPlay;
    if ([url.lowercaseString containsString:@"http"]) {
        [self.playModel startPlayWithUrl:url];
    }else{
        [self.playModel startPlayWithPath:url];
    }
    if (!isPlay) {
        [[YJPlayStatus sharePlayStatus] setViewPlayShow:YES];
        self.footerView.isPause = YES;
    }
}
- (void)destroyPlayer{
    [super destroyPlayer];
    self.playModel = nil;
    self.headerView = nil;
    self.footerView = nil;
}
#pragma mark - private action
- (void)play{
    self.footerView.isPause = NO;
    [self.playModel play];
}
- (void)pause{
    self.footerView.isPause = YES;
    [self.playModel pause];
}
- (void)stop{
    self.footerView.isPause = NO;
    [self.playModel stop];
}
#pragma mark - 通知方法
- (void)appDidEnterBackground:(NSNotification *)note{
    [self pause];
}
- (void)appDidEnterPlayground:(NSNotification *)note{
     [self play];
}
#pragma mark - 手势方法
- (void)singleTap:(UITapGestureRecognizer *)tap{
    if (self.headerView.isShowing) {
        [self.headerView hide];
    }else{
        [self.headerView show];
    }
    if (self.footerView.isShowing) {
        [self.footerView hide];
    }else{
        [self.footerView show];
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap{
    if (self.playState == YJPlayerStateSuspend) {
        [self play];
    }else{
        [self pause];
    }
}
- (void)panDirection:(UIPanGestureRecognizer *)pan{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                self.sumTime  = self.currentTimeValue * self.footerView.duration;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if (veloctyPoint.x > 0) {
                        [[YJPlayStatus sharePlayStatus] setViewPlaySpeedShow:YES];
                    }else{
                         [[YJPlayStatus sharePlayStatus] setViewPlayBackShow:YES];
                    }
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [[YJPlayStatus sharePlayStatus] setViewPlayBackShow:NO];
                    [[YJPlayStatus sharePlayStatus] setViewPlaySpeedShow:NO];
                    [self.playModel playSlideSeekToTimeAtSlideValue:self.sumTime/self.footerView.duration];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
/** 垂直移动的方法 */
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeValue -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
    
}
/** 水平移动的方法 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 150;
    // 需要限定sumTime的范围
    if (self.sumTime > self.footerView.duration) { self.sumTime = self.footerView.duration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    CGFloat  draggedValue  = (CGFloat)self.sumTime/(CGFloat)self.footerView.duration;
    self.footerView.playProgress = draggedValue;
    self.footerView.currentTime = self.sumTime;
    
    if (self.footerView.isPause) {
        [self play];
    }
}
#pragma mark - YJHeaderViewDelegate
- (void)backBtnDidClick{
    if (self.headerView.isFullScreen) {
        self.footerView.isFullScreen = NO;
        self.headerView.isFullScreen = NO;
        
        self.isFullScreenByUser = YES;
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreenByUser = NO;
    }else{
        if (self.BackClickBlock) {
            self.BackClickBlock();
        }
    }
}
#pragma mark - YJFooterViewDelegate
- (void)progressSliderDidTouchDown{
     self.progressSilderTouching = YES;
}
- (void)progressSliderDidTouchUpWithValue:(CGFloat)sliderValue{
    self.progressSilderTouching = NO;
    [self.playModel playSlideSeekToTimeAtSlideValue:sliderValue];
    self.footerView.isPause = NO;
    [self play];
    [[YJPlayStatus sharePlayStatus] setViewPlayShow:NO];
}
- (void)playBtnDidClickWithIsPlayStatus:(BOOL)isPlayStatus{
    [[YJPlayStatus sharePlayStatus] setViewPlayShow:NO];
    if (isPlayStatus) {
        [self play];
    }else{
        [self pause];
    }
}
- (void)fullBtnDidClick{
    self.footerView.isFullScreen = YES;
    self.headerView.isFullScreen = YES;
    self.isFullScreenByUser = YES;
    [self userRotationAction];
    self.isFullScreenByUser = NO;
}
- (void)lockBtnDidClickWithIsLockStatus:(BOOL)isLockStatus{
    self.autoRotationDisable = isLockStatus;
}
#pragma mark - YJPlayModelDelegate
- (void)playerState:(YJPlayerState)playerState{
    self.playState = playerState;
    NSString * text;
    switch (playerState) {
        case YJPlayerStateNone:
            text = @"None";
            break;
        case YJPlayerStateBuffering:
            [self.indicatorView startAnimating];
            text = @"Buffering...";
            break;
        case YJPlayerStateReadyToPlay:
            text = @"Prepare";
            self.footerView.duration = self.playModel.duration;
            [self.indicatorView stopAnimating];
            if (self.isImmediatelyPlay) {
                self.footerView.isPause = NO;
                [self play];
            }
            self.panEnable = YES;
            break;
        case YJPlayerStatePlaying:
            if (self.footerView.isShowing) {
                [self.footerView hide];
            }
            if (self.headerView.isShowing) {
                [self.headerView hide];
            }
            text = @"Playing";
            self.footerView.isPause = NO;
            [self.indicatorView stopAnimating];
            break;
        case YJPlayerStateSuspend:
            [self.indicatorView stopAnimating];
            text = @"Suspend";
            [[YJPlayStatus sharePlayStatus] showViewPause];
            break;
        case YJPlayerStateFinished:
            text = @"Finished";
            [[YJPlayStatus sharePlayStatus] setViewFinishShow:YES];
            [self.footerView hide];
            break;
        case YJPlayerStateFailed:
            text = @"Error";
            [self.indicatorView stopAnimating];
            [[YJPlayStatus sharePlayStatus] setViewLoadErrorShow:YES];
            [self.footerView hide];
            break;
    }
    NSLog(@"播放状态:%@",text);
}
- (void)playerProgress:(CGFloat)progress{
    if (!self.progressSilderTouching) {
        self.footerView.playProgress = progress;
    }
    self.currentTimeValue = progress;
    self.footerView.currentTime = progress*self.footerView.duration;
}
- (void)playerBufferValue:(CGFloat)bufferValue{
    self.footerView.bufferValue = bufferValue;
}
- (void)playerErrorInfo:(NSString *)errorInfo{
    [[YJPlayStatus sharePlayStatus] setViewLoadErrorShow:YES];
}
#pragma mark - setter getter
- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    self.headerView.videoTitle = videoTitle;
}
- (void)setIsFullScreen:(BOOL)isFullScreen{
    [super setIsFullScreen:isFullScreen];
    self.footerView.isFullScreen = isFullScreen;
    self.headerView.isFullScreen = isFullScreen;
}
- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}
- (YJHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YJHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (YJFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[YJFooterView alloc] initWithFrame:CGRectZero];
        _footerView.delegate = self;
    }
    return _footerView;
}
@end

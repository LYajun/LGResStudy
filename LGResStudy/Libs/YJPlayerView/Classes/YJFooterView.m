//
//  YJFooterView.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJFooterView.h"
#import <Masonry/Masonry.h>

@interface YJFooterView ()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *fullBtn;
@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIProgressView *progressBufView;
@property (nonatomic, strong) UILabel *currentTimeLab;
@property (nonatomic, strong) UILabel *totalTimeLab;
@property (nonatomic, assign) BOOL progressSilderTouching;
@end
@implementation YJFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layoutUI];
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.isShowing = YES;
}
- (void)layoutUI{
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(28, 38));
    }];
    
    [self addSubview:self.fullBtn];
    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self addSubview:self.lockBtn];
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.fullBtn);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    self.lockBtn.hidden = YES;
    
    [self addSubview:self.totalTimeLab];
    [self.totalTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.fullBtn.mas_left).offset(-5);
        make.width.mas_equalTo(45);
    }];
    
    [self addSubview:self.currentTimeLab];
    [self.currentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.width.mas_equalTo(45);
    }];
    
    [self addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.currentTimeLab.mas_right).offset(6);
        make.right.equalTo(self.totalTimeLab.mas_left).offset(-6);
    }];
    
    [self insertSubview:self.progressBufView belowSubview:self.progressSlider];
    [self.progressBufView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.equalTo(self.progressSlider);
    }];
}
#pragma mark public
- (void)show{
    self.isShowing = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.hidden = NO;
        [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
        }];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (weakSelf.isShowing) {
                [weakSelf hide];
            }
        });
    }];
}
- (void)hide{
    self.isShowing = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.hidden = YES;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }];
}
#pragma mark private action
- (CGFloat)stringWidthWithText:(NSString *)text font:(CGFloat) font{
    CGSize stringSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return stringSize.width+2;
}
- (NSString *)longTimeStringFromSeconds:(NSInteger)timeInterval{
    NSInteger hour = timeInterval / (60*60);
    NSInteger minute = timeInterval % (60*60) / 60;
    NSInteger second = timeInterval % (60*60) % 60;
    return [NSString stringWithFormat:@"%02li:%02li:%02li",hour,minute,second];
}
- (NSString *)shortTimeStringFromSeconds:(NSInteger)timeInterval{
    NSInteger minute = timeInterval / 60;
    NSInteger second = timeInterval % 60;
    return [NSString stringWithFormat:@"%02li:%02li",minute,second];
}
#pragma mark events
- (void)playClickEvent:(UIButton *) btn{
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playBtnDidClickWithIsPlayStatus:)]) {
        [self.delegate playBtnDidClickWithIsPlayStatus:!btn.selected];
    }
}
- (void)fullScreenClickEvent:(UIButton *) btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullBtnDidClick)]) {
        [self.delegate fullBtnDidClick];
    }
}
- (void)lockClickEvent:(UIButton *) btn{
     btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(lockBtnDidClickWithIsLockStatus:)]) {
        [self.delegate lockBtnDidClickWithIsLockStatus:btn.selected];
    }
}
- (void)progressSliderTouchDownEvent:(UISlider *) slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressSliderDidTouchDown)]) {
        [self.delegate progressSliderDidTouchDown];
    }
}
- (void)progressSliderTouchUpEvent:(UISlider *) slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressSliderDidTouchUpWithValue:)]) {
        [self.delegate progressSliderDidTouchUpWithValue:slider.value];
    }
}
#pragma mark setter
- (void)setBufferValue:(CGFloat)bufferValue{
    _bufferValue = bufferValue;
    self.progressBufView.progress = bufferValue;
}
- (void)setPlayProgress:(CGFloat)playProgress{
    _playProgress = playProgress;
    self.progressSlider.value = playProgress;
}
- (void)setIsPause:(BOOL)isPause{
    _isPause = isPause;
    self.playBtn.selected = isPause;
}
- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    self.fullBtn.hidden = isFullScreen;
    self.lockBtn.hidden = !isFullScreen;
}
- (void)setDuration:(NSInteger)duration{
    _duration = duration;
    if (duration >= 60*60) {
        self.totalTimeLab.text = [self longTimeStringFromSeconds:duration];
    }else{
        self.totalTimeLab.text = [self shortTimeStringFromSeconds:duration];
    }
    [self.totalTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self stringWidthWithText:self.totalTimeLab.text font:14]);
    }];
    [self setCurrentTime:self.currentTime];
}
- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
    if (self.duration >= 60*60) {
        self.currentTimeLab.text = [self longTimeStringFromSeconds:currentTime];
    }else{
        self.currentTimeLab.text = [self shortTimeStringFromSeconds:currentTime];
    }
    
    if (self.duration > 0) {
        [self.currentTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([self stringWidthWithText:self.currentTimeLab.text font:14]);
        }];
    }
}

#pragma mark getter
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_pause"]] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_play"]] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIButton *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_fullscreen"]] forState:UIControlStateNormal];
        [_fullBtn addTarget:self action:@selector(fullScreenClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}
- (UIButton *)lockBtn{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_unlock"]] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_lock"]] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}
- (UISlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_progressSlider setThumbImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_thumb"]] forState:UIControlStateNormal];
        _progressSlider.minimumTrackTintColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:233/255.0 alpha:1.0];
        _progressSlider.maximumTrackTintColor = [UIColor clearColor];
        _progressSlider.value = 0;
        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchCancel];
         [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
         [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpOutside];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _progressSlider;
}
- (UIProgressView *)progressBufView{
    if (!_progressBufView) {
         _progressBufView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressBufView.progressTintColor = [UIColor lightGrayColor];
        _progressBufView.trackTintColor = [UIColor darkGrayColor];
        _progressBufView.progress = 0;
    }
    return _progressBufView;
}
- (UILabel *)currentTimeLab{
    if (!_currentTimeLab) {
        _currentTimeLab = [UILabel new];
        _currentTimeLab.font = [UIFont systemFontOfSize:14];
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.textAlignment = NSTextAlignmentRight;
        _currentTimeLab.text = @"00:00";
    }
    return _currentTimeLab;
}
- (UILabel *)totalTimeLab{
    if (!_totalTimeLab) {
        _totalTimeLab = [UILabel new];
        _totalTimeLab.font = [UIFont systemFontOfSize:14];
        _totalTimeLab.textColor = [UIColor whiteColor];
        _totalTimeLab.text = @"00:00";
    }
    return _totalTimeLab;
}
#pragma mark - 获取bundle资源
- (NSString*)getResourceFromBundleFileName:(NSString *) filename{
    NSString * vodPlayerBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"YJPlayerView.bundle"] ;
    NSBundle *resoureBundle = [NSBundle bundleWithPath:vodPlayerBundle];
    
    if (resoureBundle && filename)
    {
        NSString * bundlePath = [[resoureBundle resourcePath ] stringByAppendingPathComponent:filename];
        
        return bundlePath;
    }
    return nil ;
}
@end

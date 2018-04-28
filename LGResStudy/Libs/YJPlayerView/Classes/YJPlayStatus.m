//
//  YJPlayStatus.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJPlayStatus.h"
#import <Masonry/Masonry.h>

@interface YJPlayStatus ()
/** 开始 */
@property (strong, nonatomic) UIView *viewPlay;
/** 暂停 */
@property (strong, nonatomic) UIView *viewPause;
/** 完成 */
@property (strong, nonatomic) UIView *viewFinish;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;
/** 快进 */
@property (strong, nonatomic) UIView *viewSpeed;
/** 快退 */
@property (strong, nonatomic) UIView *viewBack;
@end
@implementation YJPlayStatus
+ (YJPlayStatus *)sharePlayStatus{
    static YJPlayStatus * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[YJPlayStatus alloc]init];
    });
    return macro;
}
- (void)againClickEvent:(UIButton *) btn{
    [self setViewLoadErrorShow:NO];
    if (self.LoadErrorUpdateBlock) {
        self.LoadErrorUpdateBlock();
    }
}
- (void)playClickEvent:(UIButton *) btn{
    [self setViewPlayShow:NO];
    if (self.StartPlayBlock) {
        self.StartPlayBlock();
    }
}
- (void)againPlayClickEvent:(UIButton *) btn{
    [self setViewFinishShow:NO];
    if (self.AgainPlayBlock) {
        self.AgainPlayBlock();
    }
}
- (void)showViewPause{
    [self.viewLoadError removeFromSuperview];
    [self.viewPlay removeFromSuperview];
    [self setShowOnBackgroundView:self.viewPause show:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setShowOnBackgroundView:weakSelf.viewPause show:NO];
       
    });
}
- (void)setViewPlayShow:(BOOL)show{
    [self.viewLoadError removeFromSuperview];
    [self.viewFinish removeFromSuperview];
    [self setShowOnBackgroundView:self.viewPlay show:show];
}
- (void)setViewFinishShow:(BOOL)show{
    [self.viewPlay removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewFinish show:show];
}
- (void)setViewLoadErrorShow:(BOOL)show{
    [self.viewPlay removeFromSuperview];
    [self.viewFinish removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoadError show:show];
}
- (void)setViewPlaySpeedShow:(BOOL)show{
    [self.viewBack removeFromSuperview];
    [self setShowOnBackgroundView:self.viewSpeed show:show];
}
- (void)setViewPlayBackShow:(BOOL)show{
    [self.viewSpeed removeFromSuperview];
    [self setShowOnBackgroundView:self.viewBack show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self.ownView addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.left.equalTo(self.ownView);
            make.top.equalTo(self.ownView).offset(44);
        }];
    }else {
        [aView removeFromSuperview];
    }
}
- (UIView *)viewBack{
    if (!_viewBack) {
        _viewBack = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.backgroundColor = [UIColor clearColor];
        [playBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_reverse"]] forState:UIControlStateNormal];
        [playBtn setTitle:@"快退" forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_viewBack addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewBack);
            make.bottom.equalTo(_viewBack.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(110, 30));
        }];
        playBtn.userInteractionEnabled = NO;
    }
    return _viewBack;
}
- (UIView *)viewSpeed{
    if (!_viewSpeed) {
        _viewSpeed = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.backgroundColor = [UIColor clearColor];
        [playBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_speed"]] forState:UIControlStateNormal];
        [playBtn setTitle:@"快进" forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_viewSpeed addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewSpeed);
            make.bottom.equalTo(_viewSpeed.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(110, 30));
        }];
        playBtn.userInteractionEnabled = NO;
    }
    return _viewSpeed;
}
- (UIView *)viewPlay{
    if (!_viewPlay) {
        _viewPlay = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [playBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_play"]] forState:UIControlStateNormal];
        [playBtn setTitle:@"开始播放" forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        playBtn.layer.cornerRadius = 13;
        playBtn.layer.borderWidth = 0;
        playBtn.layer.masksToBounds = YES;
        [_viewPlay addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_viewPlay);
            make.size.mas_equalTo(CGSizeMake(110, 30));
        }];
        [playBtn addTarget:self action:@selector(playClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewPlay;
}
- (UIView *)viewPause{
    if (!_viewPause) {
        _viewPause = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pauseBtn.userInteractionEnabled = NO;
        pauseBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [pauseBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_pause"]] forState:UIControlStateNormal];
        [pauseBtn setTitle:@"已暂停" forState:UIControlStateNormal];
        [pauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        pauseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        pauseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        pauseBtn.layer.cornerRadius = 13;
        pauseBtn.layer.borderWidth = 0;
        pauseBtn.layer.masksToBounds = YES;
        [_viewPause addSubview:pauseBtn];
        [pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_viewPause);
            make.size.mas_equalTo(CGSizeMake(90, 26));
        }];
    }
    return _viewPause;
}
- (UIView *)viewFinish{
    if (!_viewFinish) {
        _viewFinish = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *tipLab = [UILabel new];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = [UIColor whiteColor];
        tipLab.font = [UIFont systemFontOfSize:16];
        tipLab.text = @"视频已播放完成,可选择重播";
        [_viewFinish addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.left.equalTo(_viewFinish);
        }];
        
        UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        againBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [againBtn setTitle:@"点击重播" forState:UIControlStateNormal];
        [againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        againBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        againBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        againBtn.layer.cornerRadius = 13;
        againBtn.layer.borderWidth = 0;
        againBtn.layer.masksToBounds = YES;
        [_viewFinish addSubview:againBtn];
        [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewFinish);
            make.top.equalTo(tipLab.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(90, 26));
        }];
        [againBtn addTarget:self action:@selector(againPlayClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewFinish;
}
- (UIView *)viewLoadError{
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *errorLab = [UILabel new];
        errorLab.textAlignment = NSTextAlignmentCenter;
        errorLab.textColor = [UIColor whiteColor];
        errorLab.font = [UIFont systemFontOfSize:16];
        errorLab.text = @"资源加载失败,请稍后重试";
        [_viewLoadError addSubview:errorLab];
        [errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.left.equalTo(_viewLoadError);
        }];
        
        UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        againBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [againBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        [againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        againBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        againBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        againBtn.layer.cornerRadius = 13;
        againBtn.layer.borderWidth = 0;
        againBtn.layer.masksToBounds = YES;
        [_viewLoadError addSubview:againBtn];
        [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewLoadError);
            make.top.equalTo(errorLab.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(90, 26));
        }];
        [againBtn addTarget:self action:@selector(againClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewLoadError;
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

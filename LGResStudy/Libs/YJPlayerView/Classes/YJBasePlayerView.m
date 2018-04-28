//
//  YJOrientationView.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/15.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJBasePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>

#define Device_Width  [[UIScreen mainScreen] bounds].size.width
#define Device_Height [[UIScreen mainScreen] bounds].size.height

@interface YJBasePlayerView ()<UIGestureRecognizerDelegate>
/** 当前旋转方向 */
@property(nonatomic,assign)UIInterfaceOrientation currentOrientation;
/** 系统音量滑块 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 系统状态栏 */
@property(nonatomic,strong)UIView *statusBar;
/** 单击手势 */
@property(nonatomic,strong)UITapGestureRecognizer *singleTap;
/** 双击手势 */
@property(nonatomic,strong)UITapGestureRecognizer *doubleTap;
/** 平移手势 */
@property(nonatomic,strong)UIPanGestureRecognizer *panRecognizer;
/** 手势视图 */
@property (nonatomic,strong) UIView *gesView;
@end
@implementation YJBasePlayerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self getSystemVolume];
        //开启
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        //注册屏幕旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        [self addGestures];
        [self addSubview:self.gesView];
        [self.gesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self addNotification];
    }
    return self;
}
// 添加手势
- (void)addGestures{
    [self.gesView addGestureRecognizer:self.singleTap];
    [self.gesView addGestureRecognizer:self.doubleTap];
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.gesView addGestureRecognizer:self.panRecognizer];
}
// 添加通知
- (void)addNotification{
    //APP运行状态通知，将要被挂起
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterPlayground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
- (void)destroyPlayer{
    //回到竖屏
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    //重置状态条
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //恢复默认状态栏显示与否
    self.statusBar.hidden = self.isFullScreen;
    [self removeFromSuperview];
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)userRotationAction{
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    } else {
        self.isFullScreen = YES;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }
}
/** 获取系统音量控件 */
- (void)getSystemVolume{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
}
/** 屏幕旋转通知 */
- (void)deviceOrientChange:(NSNotification *) noti{
    if (!self.autoRotationDisable) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
        }else if (orientation == UIDeviceOrientationLandscapeRight){
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeRight];
        }else if (orientation ==UIDeviceOrientationPortrait){
            [self setOrientationPortraitConstraint];
        }
    }
}
/** 手动旋转 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}
/** 设置竖屏的约束 */
- (void)setOrientationPortraitConstraint{
    self.isFullScreen = NO;
    if (UIInterfaceOrientationPortrait == self.currentOrientation) {
        return;
    }
    //还原
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    }];
    //设置是否隐藏
    self.statusBar.hidden = self.isFullScreen;
    [self removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self.fatherView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    self.currentOrientation = UIInterfaceOrientationPortrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
/** 设置横屏的约束 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    self.isFullScreen = YES;
    if (orientation == self.currentOrientation) {
        return;
    }
    
    //设置是否隐藏
    self.statusBar.hidden = _isFullScreen;
    
    [self removeFromSuperview];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    if (self.isFullScreenByUser) {
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    }else{
        //播放器所在控制器不支持旋转，采用旋转view的方式实现
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }else if (orientation == UIInterfaceOrientationLandscapeRight) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation( - M_PI / 2);
            }];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        }
    }
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Device_Width));
        make.height.equalTo(@(Device_Height));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.currentOrientation = orientation;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark APP活动通知
- (void)appDidEnterBackground:(NSNotification *)note{
    //将要挂起，停止播放
}
- (void)appDidEnterPlayground:(NSNotification *)note{
    //继续播放
}
#pragma mark 手势点击方法
- (void)singleTap:(UITapGestureRecognizer *)tap{}
- (void)doubleTap:(UITapGestureRecognizer *)tap{}
-(void)panDirection:(UIPanGestureRecognizer *)pan{}
#pragma mark setter getter
- (void)setVolumeValue:(CGFloat)volumeValue{
    _volumeValue = volumeValue;
    self.volumeViewSlider.value = volumeValue;
}
- (void)setPanEnable:(BOOL)panEnable{
    _panEnable = panEnable;
    self.panRecognizer.enabled = panEnable;
}
- (UIView *)statusBar{
    if (!_statusBar){
        _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    return _statusBar;
}
-(UITapGestureRecognizer *)singleTap{
    if (!_singleTap) {
        _singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        _singleTap.delegate =  self;
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
    }
    return _singleTap;
}
-(UITapGestureRecognizer *)doubleTap{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
        _doubleTap.delegate =  self;
    }
    return _doubleTap;
}
-(UIPanGestureRecognizer *)panRecognizer{
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        _panRecognizer.delegate = self;
        [_panRecognizer setMaximumNumberOfTouches:1];
        [_panRecognizer setDelaysTouchesBegan:YES];
        [_panRecognizer setDelaysTouchesEnded:YES];
        [_panRecognizer setCancelsTouchesInView:YES];
        _panRecognizer.enabled = NO;
    }
    return _panRecognizer;
}
- (UIView *)gesView{
    if (!_gesView) {
        _gesView = [UIView new];
        _gesView.backgroundColor = [UIColor clearColor];
    }
    return  _gesView;
}
@end

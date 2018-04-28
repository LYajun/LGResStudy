//
//  RLGBaseViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGBaseViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGActivityIndicatorView.h"
@interface RLGBaseViewController ()
/** 加载中 */
@property (strong, nonatomic) UIView *viewLoading;
/** 没有数据 */
@property (strong, nonatomic) UIView *viewNoData;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;
@end

@implementation RLGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)dealloc{
    RLG_Log([NSString stringWithFormat:@"%@ dealloc",NSStringFromClass(self.class)]);
}
- (void)initNaviBar{
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_back")] style:UIBarButtonItemStylePlain target:self action:@selector(navBar_leftItemPressed)];
}
- (void)navBar_leftItemPressed{
    RLG_StopPlayer();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Stateview
- (void)setViewLoadingShow:(BOOL)show{
    [self.viewNoData removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoading show:show];
}
- (void)setViewNoDataShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewNoData show:show];
}
- (void)setViewLoadErrorShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewNoData removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoadError show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self.view addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [aView removeFromSuperview];
    }
}
- (UIView *)viewLoading {
    if (!_viewLoading) {
        _viewLoading = [[UIView alloc]init];
        RLGActivityIndicatorView *activityIndicatorView = [[RLGActivityIndicatorView alloc] initWithType:RLGActivityIndicatorAnimationTypeBallPulse tintColor:RLG_Color(0x0EB5F4)];
        [_viewLoading addSubview:activityIndicatorView];
        __weak typeof(self) weakSelf = self;
        [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.viewLoading);
            make.width.height.mas_equalTo(100);
        }];
        [activityIndicatorView startAnimating];
    }
    return _viewLoading;
}

- (UIView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[UIView alloc]init];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"statusView_empy")]];
        [_viewNoData addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewNoData);
            make.centerY.equalTo(weakSelf.viewNoData).offset(-10);
        }];
        UILabel *lab = [[UILabel alloc] init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor =  RLG_Color(0x666666);
        if (self.noDataText && self.noDataText.length > 0) {
            lab.text = self.noDataText;
        }else{
            lab.text = @"亲，尚未查找到...";
        }
        [_viewNoData addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(weakSelf.viewNoData);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
    }
    return _viewNoData;
}
- (UIView *)viewLoadError {
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc]init];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"statusView_error")]];
        [_viewLoadError addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewLoadError);
            make.centerY.equalTo(weakSelf.viewLoadError).offset(-10);
        }];
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RLG_Color(0x333333);
        lab.text = @"糟糕，服务器开小差了,轻触刷新";
        [_viewLoadError addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(weakSelf.viewLoadError);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorUpdate)];
        [_viewLoadError addGestureRecognizer:tap];
        
    }
    return _viewLoadError;
}
- (void)loadErrorUpdate{
}
@end

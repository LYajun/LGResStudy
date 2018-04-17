//
//  LGResStudyViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGResStudyViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGActivityIndicatorView.h"

@interface LGResStudyViewController ()
/** 加载中 */
@property (strong, nonatomic) UIView *viewLoading;
/** 没有数据 */
@property (strong, nonatomic) UIView *viewNoData;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;
@end

@implementation LGResStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        lab.text = @"当前数据为空";
        [_viewNoData addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(weakSelf.viewNoData);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
    }
    return _viewNoData;
}
- (void)noDataUpdate{
    
}
- (UIView *)viewLoadError {
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc]init];
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/YJReaderTool.framework/YJReaderTool.bundle"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
            bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"YJReaderTool.bundle"];
        }
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"statusView_error"];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        [_viewLoadError addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewLoadError);
            make.centerY.equalTo(_viewLoadError).offset(-10);
        }];
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [YJEmptyHandle colorWithHex:0x333333];
        lab.text = @"加载失败了,轻触重新加载";
        [_viewLoadError addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(_viewLoadError);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorTapAction)];
        [_viewLoadError addGestureRecognizer:tap];
        
    }
    return _viewLoadError;
}
- (void)loadErrorUpdate{
    
}
@end

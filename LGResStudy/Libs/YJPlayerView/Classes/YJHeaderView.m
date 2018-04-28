//
//  YJHeaderView.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJHeaderView.h"
#import <Masonry/Masonry.h>

@interface YJHeaderView ()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *moreBtn;

@end
@implementation YJHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layoutUI];
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.titleLab.hidden = YES;
    self.isShowing = YES;
}
- (void)layoutUI{
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.right.equalTo(self.moreBtn.mas_left).offset(-20);
    }];
}
#pragma mark public
- (void)show{
     self.isShowing = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.moreBtn.hidden = NO;
        if (self.isFullScreen) {
            self.moreBtn.hidden = NO;
        }
    }];
}
- (void)hide{
     self.isShowing = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.moreBtn.hidden = YES;
        self.titleLab.hidden = YES;
    }];
}
#pragma mark events
- (void)backClickEvent:(UIButton *) btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnDidClick)]) {
        [self.delegate backBtnDidClick];
    }
}
- (void)moreClickEvent:(UIButton *) btn{
    
}
#pragma mark setter getter
- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    self.titleLab.text = videoTitle;
}
- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    self.titleLab.hidden = !isFullScreen;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_back"]] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:[self getResourceFromBundleFileName:@"yj_more"]] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
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

//
//  RLGTextWordView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/18.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTextWordView.h"
#import "RLGWordModel.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGVoicePlayer.h"
#import "RLGTouchView.h"

@interface RLGAlertView: RLGTouchView
@end
@implementation RLGAlertView
- (void)drawRect:(CGRect)rect{
    UIRectCorner corners = UIRectCornerAllCorners;
    corners = UIRectCornerBottomLeft|UIRectCornerBottomRight;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
@interface RLGTextWordView ()
@property (nonatomic,retain) RLGAlertView *alertView;
@property (strong, nonatomic) UIButton *enVoiceBtn;
@property (strong,nonatomic) UIButton *usVoiceBtn;
@property (strong, nonatomic) UILabel *wordL;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *enPlayGifImage;
@property (strong, nonatomic) UIImageView *usPlayGifImage;
@property (strong, nonatomic) RLGWordModel *wordModel;
@property (strong, nonatomic) RLGVoicePlayer *voicePlayer;
@end
@implementation RLGTextWordView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}
- (void)initUI{
     self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    __weak typeof(self) weakSelf = self;
    self.voicePlayer.PlayFinishBlock = ^{
        [weakSelf stopGif];
    };
    self.voicePlayer.PlayFailBlock = ^{
        [weakSelf stopGif];
    };
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}
- (void)layoutUI{
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(RLG_ScreenWidth()*0.8, RLG_ScreenWidth()*0.8*0.6));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = RLG_ThemeColor();
    [self.alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.alertView);
        make.height.mas_equalTo(5);
    }];
    [self.alertView addSubview:self.wordL];
    [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(5);
        make.left.equalTo(self.alertView).offset(10);
        make.centerX.equalTo(self.alertView);
        make.height.mas_equalTo(35);
    }];
    [self.alertView addSubview:self.enVoiceBtn];
    [self.enVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wordL);
        make.top.equalTo(self.wordL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.alertView addSubview:self.usVoiceBtn];
    [self.usVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.enVoiceBtn);
        make.left.equalTo(self.enVoiceBtn.mas_right).offset(30);
    }];
    [self.alertView addSubview:self.enPlayGifImage];
    [self.enPlayGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.enVoiceBtn);
        make.width.equalTo(self.enPlayGifImage.mas_height);
    }];
    [self.alertView addSubview:self.usPlayGifImage];
    [self.usPlayGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.usVoiceBtn);
        make.width.equalTo(self.usPlayGifImage.mas_height);
    }];
    [self.alertView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.wordL);
        make.top.equalTo(self.enVoiceBtn.mas_bottom).offset(5);
        make.bottom.equalTo(self.alertView).offset(-5);
    }];
}
+ (void)showTextWordViewWithWordModel:(RLGWordModel *)wordModel{
    RLGTextWordView *wordView = [[RLGTextWordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    wordView.wordModel = wordModel;
    wordView.wordL.text = wordModel.cwName;
    wordView.textView.text = [wordModel wordChineseMean];
    [wordView.enVoiceBtn setTitle:[@" 英" stringByAppendingString:RLG_AttributedString(wordModel.unPText, 14).string] forState:UIControlStateNormal];
    [wordView.usVoiceBtn setTitle:[@" 美" stringByAppendingString:RLG_AttributedString(wordModel.usPText, 14).string] forState:UIControlStateNormal];
    [wordView show];
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
- (void)hide{
    [self.voicePlayer stop];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)enVoiceAction{
    [self.usPlayGifImage stopAnimating];
    [self.voicePlayer pause];
    if (LGResConfig().appendDomain) {
        [self.voicePlayer setPlayerWithUrlString:[LGResConfig().voiceUrl stringByAppendingString:self.wordModel.unPVoice]];
    }else{
        [self.voicePlayer setPlayerWithUrlString:self.wordModel.unPVoice];
    }
    [self.voicePlayer play];
    self.enPlayGifImage.hidden = NO;
    [self.enPlayGifImage startAnimating];
}
- (void)usVoiceAction{
    [self.enPlayGifImage stopAnimating];
    [self.voicePlayer pause];
    if (LGResConfig().appendDomain) {
        [self.voicePlayer setPlayerWithUrlString:[LGResConfig().voiceUrl stringByAppendingString:self.wordModel.usPVoice]];
    }else{
        [self.voicePlayer setPlayerWithUrlString:self.wordModel.usPVoice];
    }
    [self.voicePlayer play];
    self.usPlayGifImage.hidden = NO;
    [self.usPlayGifImage startAnimating];
}
- (void)stopGif{
    self.enPlayGifImage.hidden = YES;
    [self.enPlayGifImage stopAnimating];
    self.usPlayGifImage.hidden = YES;
    [self.usPlayGifImage stopAnimating];
}
#pragma mark getter
- (RLGVoicePlayer *)voicePlayer{
    if (!_voicePlayer) {
        _voicePlayer = [[RLGVoicePlayer alloc] init];
    }
    return _voicePlayer;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.textColor = [UIColor darkGrayColor];
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}
- (UIImageView *)enPlayGifImage{
    if (!_enPlayGifImage) {
        _enPlayGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _enPlayGifImage.animationImages = RLG_VoiceGifs();
        _enPlayGifImage.animationDuration = 1.0;
        _enPlayGifImage.hidden = YES;
    }
    return _enPlayGifImage;
}
- (UIImageView *)usPlayGifImage{
    if (!_usPlayGifImage) {
        _usPlayGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _usPlayGifImage.animationImages = RLG_VoiceGifs();
        _usPlayGifImage.animationDuration = 1.0;
        _usPlayGifImage.hidden = YES;
    }
    return _usPlayGifImage;
}
- (UIButton *)enVoiceBtn{
    if (!_enVoiceBtn) {
        _enVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_enVoiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_n")] forState:UIControlStateNormal];
        [_enVoiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_h")] forState:UIControlStateHighlighted];
        [_enVoiceBtn setTitle:@"英['steibI]" forState:UIControlStateNormal];
        [_enVoiceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_enVoiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_enVoiceBtn addTarget:self action:@selector(enVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enVoiceBtn;
}
- (UIButton *)usVoiceBtn{
    if (!_usVoiceBtn) {
        _usVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _usVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_usVoiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_n")] forState:UIControlStateNormal];
        [_usVoiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_h")] forState:UIControlStateHighlighted];
        [_usVoiceBtn setTitle:@"美['steibI]" forState:UIControlStateNormal];
        [_usVoiceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_usVoiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_usVoiceBtn addTarget:self action:@selector(usVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usVoiceBtn;
}
- (UILabel *)wordL{
    if (!_wordL) {
        _wordL = [UILabel new];
        _wordL.textColor = [UIColor blackColor];
        _wordL.font = [UIFont systemFontOfSize:30];
    }
    return _wordL;
}
- (RLGAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[RLGAlertView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}
@end

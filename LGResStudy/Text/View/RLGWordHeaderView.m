//
//  RLGWordHeaderView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGWordHeaderView.h"
#import "RLGVoicePlayer.h"
#import "RLGWordModel.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>


@interface RLGWordHeaderView ()
@property (strong, nonatomic) UIButton *enVoiceBtn;
@property (strong,nonatomic) UIButton *usVoiceBtn;
@property (strong, nonatomic) UILabel *wordL;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *enPlayGifImage;
@property (strong, nonatomic) UIImageView *usPlayGifImage;
@property (strong, nonatomic) RLGVoicePlayer *voicePlayer;
@end
@implementation RLGWordHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}
- (void)initUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    self.voicePlayer.PlayFinishBlock = ^{
        [weakSelf stopGif];
    };
    self.voicePlayer.PlayFailBlock = ^{
        [weakSelf stopGif];
    };
}
- (void)layoutUI{
    [self.contentView addSubview:self.wordL];
    [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(35);
    }];
    [self.contentView addSubview:self.enVoiceBtn];
    [self.enVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wordL);
        make.top.equalTo(self.wordL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.usVoiceBtn];
    [self.usVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.enVoiceBtn);
        make.left.equalTo(self.enVoiceBtn.mas_right).offset(30);
    }];
    [self.contentView addSubview:self.enPlayGifImage];
    [self.enPlayGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.enVoiceBtn);
        make.width.equalTo(self.enPlayGifImage.mas_height);
    }];
    [self.contentView addSubview:self.usPlayGifImage];
    [self.usPlayGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.usVoiceBtn);
        make.width.equalTo(self.usPlayGifImage.mas_height);
    }];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.wordL);
        make.top.equalTo(self.enVoiceBtn.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}
- (void)setWordModel:(RLGWordModel *)wordModel{
    _wordModel = wordModel;
    self.wordL.text = wordModel.cwName;
    self.textView.text = [wordModel wordChineseMean];
    [self.enVoiceBtn setTitle:[@" 英" stringByAppendingString:RLG_AttributedString(wordModel.unPText, 14).string] forState:UIControlStateNormal];
    [self.usVoiceBtn setTitle:[@" 美" stringByAppendingString:RLG_AttributedString(wordModel.usPText, 14).string] forState:UIControlStateNormal];
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
    if (self.PlayBlock) {
        self.PlayBlock();
    }
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
- (void)stop{
    [self.voicePlayer stop];
    [self stopGif];
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
        _textView.scrollEnabled = NO;
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
@end

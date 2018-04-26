//
//  RLGWordCell.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGWordCell.h"
#import "RLGCommon.h"
#import "RLGWordModel.h"
#import "RLGVoicePlayer.h"
#import <Masonry/Masonry.h>

@interface RLGWordCell ()
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (nonatomic,copy) NSString *voiceUrl;
@property (strong, nonatomic) UIImageView *playGifImage;
@property (strong, nonatomic) RLGVoicePlayer *voicePlayer;
@end
@implementation RLGWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lab = [UILabel new];
    lab.text = @"例句";
    lab.textColor = [UIColor lightGrayColor];
    lab.backgroundColor = RLG_Color(0xF8F8FF);
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.layer.cornerRadius = 2;
    lab.layer.masksToBounds = YES;
    [self.contentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 22));
    }];
    [self.contentView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(45);
    }];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lab.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(3);
        make.right.equalTo(self.voiceBtn.mas_left);
        make.height.mas_greaterThanOrEqualTo(46);
    }];
    
    [self.contentView addSubview:self.playGifImage];
    [self.playGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.voiceBtn);
        make.width.height.mas_equalTo(20);
    }];
    __weak typeof(self) weakSelf = self;
    self.voicePlayer.PlayFinishBlock = ^{
        [weakSelf stopGif];
    };
    self.voicePlayer.PlayFailBlock = ^{
        [weakSelf stopGif];
    };
}
- (void)setWordSenModel:(SenCollectionModel *)wordSenModel{
    _wordSenModel = wordSenModel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:wordSenModel.sentenceEn_attr];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [att appendAttributedString:wordSenModel.sTranslation_attr];
    self.titleL.attributedText = att;
    self.voiceUrl = wordSenModel.sViocePath;
    self.isPlay = self.voicePlayer.isPlaying && [self.voicePlayer isPlayingWithUrl:wordSenModel.sViocePath];
}
- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    self.playGifImage.hidden = !isPlay;
    if (isPlay) {
        [self.playGifImage startAnimating];
    }else{
         [self.playGifImage stopAnimating];
    }
}
- (void)stop{
    [self.voicePlayer stop];
    [self stopGif];
}
- (void)stopGif{
    self.playGifImage.hidden = YES;
    [self.playGifImage stopAnimating];
}
- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    self.voiceBtn.hidden = (RLG_IsEmpty(voiceUrl) ? YES : NO);
}
- (RLGVoicePlayer *)voicePlayer{
    if (!_voicePlayer) {
        _voicePlayer = [[RLGVoicePlayer alloc] init];
    }
    return _voicePlayer;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.numberOfLines = 0;
        _titleL.textColor = [UIColor darkGrayColor];
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UIImageView *)playGifImage{
    if (!_playGifImage) {
        _playGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playGifImage.animationImages = RLG_VoiceGifs();
        _playGifImage.animationDuration = 1.0;
        _playGifImage.hidden = YES;
    }
    return _playGifImage;
}
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_n")] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_h")] forState:UIControlStateHighlighted];
        [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
- (void)voiceAction{
    if (self.PlayBlock) {
        self.PlayBlock();
    }
    [self.voicePlayer pause];
    if (LGResConfig().appendDomain) {
        [self.voicePlayer setPlayerWithUrlString:[LGResConfig().voiceUrl stringByAppendingString:self.voiceUrl]];
    }else{
        [self.voicePlayer setPlayerWithUrlString:self.voiceUrl];
    }
    [self.voicePlayer play];
    self.playGifImage.hidden = NO;
    [self.playGifImage startAnimating];
}

@end

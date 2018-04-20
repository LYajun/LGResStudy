//
//  DLGResultVoiceCell.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultVoiceCell.h"
#import <Masonry/Masonry.h>
#import "DLGCommon.h"
#import "DLGPlayer.h"
#import "DLGWordCategoryModel.h"
#import "DLGWordModel.h"

@interface DLGResultVoiceCell ()
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (nonatomic,copy) NSString *voiceUrl;
@property (strong, nonatomic) UIImageView *playGifImage;
@end
@implementation DLGResultVoiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
     self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [view addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(view);
        make.width.height.mas_equalTo(45);
    }];
    [view addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.top.equalTo(view).offset(3);
        make.right.equalTo(self.voiceBtn.mas_left);
        make.height.mas_greaterThanOrEqualTo(46);
    }];
    
    [view addSubview:self.playGifImage];
    [self.playGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.voiceBtn);
        make.width.height.mas_equalTo(20);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopGif) name:DLGPlayerDidFinishPlayNotification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)stopGif{
    self.playGifImage.hidden = YES;
    [self.playGifImage stopAnimating];
}
- (void)setTextModel:(DLGWordCategoryModel *)textModel adIndexPath:(NSIndexPath *)indexPath{
    SenCollectionModel *senModel = textModel.categoryList[indexPath.row];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:senModel.sentenceEn_attr];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [att appendAttributedString:senModel.sTranslation_attr];
    self.titleL.attributedText = att;
    self.voiceUrl = senModel.sViocePath;
}
- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    self.voiceBtn.hidden = (DLG_IsEmpty(voiceUrl) ? YES : NO);
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
        _playGifImage.animationImages = DLG_VoiceGifs();
        _playGifImage.animationDuration = 1.0;
        _playGifImage.hidden = YES;
    }
    return _playGifImage;
}
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"voice1")] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
- (void)voiceAction{
    [[DLGPlayer shareInstance] stop];
    if (LGDicConfig().appendDomain) {
        [[DLGPlayer shareInstance] startPlayWithUrl:[LGDicConfig().voiceUrl stringByAppendingString:self.voiceUrl]];
    }else{
        [[DLGPlayer shareInstance] startPlayWithUrl:self.voiceUrl];
    }
    [[DLGPlayer shareInstance] play];
    self.playGifImage.hidden = NO;
    [self.playGifImage startAnimating];
}
@end

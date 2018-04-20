//
//  DLGResultTableHeader.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultTableHeader.h"
#import "DLGButton.h"
#import "DLGCommon.h"
#import "DLGWordModel.h"
#import "DLGPlayer.h"
#import "DLGWordCategoryModel.h"
#import <Masonry/Masonry.h>


@interface DLGResultTableCategoryHeader ()
@property (strong, nonatomic) DLGTIButton *expandBtn;
@end
@implementation DLGResultTableCategoryHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
         [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.expandBtn];
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
}
- (void)expandAction:(UIButton *) btn{
    if ([self.view respondsToSelector:@selector(expandOrFoldAtIndex:)]) {
        [self.view expandOrFoldAtIndex:self.index];
    }
}
- (void)setCategoryTitle:(NSString *)title{
     [self.expandBtn setTitle:title forState:UIControlStateNormal];
}
- (void)setCategoryExpand:(BOOL)expand{
    if (expand) {
        self.expandBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        self.expandBtn.imageView.transform = CGAffineTransformIdentity;
    }
}
- (DLGTIButton *)expandBtn{
    if (!_expandBtn) {
        _expandBtn = [DLGTIButton buttonWithType:UIButtonTypeCustom];
        _expandBtn.backgroundColor = [UIColor whiteColor];
        _expandBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _expandBtn.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18];
        [_expandBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_expandBtn addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        [_expandBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"expand2")] forState:UIControlStateNormal];
        [_expandBtn setTitle:@"例句详解" forState:UIControlStateNormal];
    }
    return _expandBtn;
}
@end

@interface DLGResultTableMainHeader ()

@property (strong, nonatomic) DLGITButton *enVoiceBtn;
@property (strong,nonatomic) DLGITButton *usVoiceBtn;
@property (strong,nonatomic) DLGITButton *allExpandBtn;
@property (strong,nonatomic) DLGITButton *allFoldBtn;
@property (strong, nonatomic) UILabel *wordL;
@property (strong, nonatomic) UILabel *textL;
@property (strong, nonatomic) UIImageView *enPlayGifImage;
@property (strong, nonatomic) UIImageView *usPlayGifImage;
@end

@implementation DLGResultTableMainHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.allFoldBtn];
    [self.allFoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.allExpandBtn];
    [self.allExpandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(self.allFoldBtn);
        make.right.equalTo(self.allFoldBtn.mas_left).offset(-10);
    }];
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
    [self.contentView addSubview:self.textL];
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.wordL);
        make.top.equalTo(self.enVoiceBtn.mas_bottom).offset(5);
        make.bottom.equalTo(self.allFoldBtn.mas_top).offset(-10);
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopGif) name:DLGPlayerDidFinishPlayNotification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)stopGif{
    self.enPlayGifImage.hidden = YES;
    [self.enPlayGifImage stopAnimating];
    self.usPlayGifImage.hidden = YES;
    [self.usPlayGifImage stopAnimating];
}
#pragma mark action
- (void)setCategoryModel:(DLGWordCategoryModel *)categoryModel{
    _categoryModel = categoryModel;
    DLGWordModel *wordModel = [categoryModel.categoryList firstObject];
    self.wordL.text = wordModel.cwName;
    self.textL.text = [wordModel wordChineseMean];
    [self.enVoiceBtn setTitle:[@"英" stringByAppendingString:DLG_AttributedString(wordModel.unPText, 14).string] forState:UIControlStateNormal];
    [self.usVoiceBtn setTitle:[@"美" stringByAppendingString:DLG_AttributedString(wordModel.usPText, 14).string] forState:UIControlStateNormal];
    self.allFoldBtn.selected = !categoryModel.foldEnable;
    self.allFoldBtn.userInteractionEnabled = categoryModel.foldEnable;
    self.allExpandBtn.selected = !categoryModel.expandEnable;
    self.allExpandBtn.userInteractionEnabled = categoryModel.expandEnable;
}
- (void)enVoiceAction{
    DLGWordModel *wordModel = [self.categoryModel.categoryList firstObject];
    [[DLGPlayer shareInstance] stop];
    if (LGDicConfig().appendDomain) {
        [[DLGPlayer shareInstance] startPlayWithUrl:[LGDicConfig().voiceUrl stringByAppendingString:wordModel.unPVoice]];
    }else{
        [[DLGPlayer shareInstance] startPlayWithUrl:wordModel.unPVoice];
    }
    [[DLGPlayer shareInstance] play];
    self.enPlayGifImage.hidden = NO;
    [self.enPlayGifImage startAnimating];
}
- (void)usVoiceAction{
    DLGWordModel *wordModel = [self.categoryModel.categoryList firstObject];
    [[DLGPlayer shareInstance] stop];
    if (LGDicConfig().appendDomain) {
        [[DLGPlayer shareInstance] startPlayWithUrl:[LGDicConfig().voiceUrl stringByAppendingString:wordModel.usPVoice]];
    }else{
        [[DLGPlayer shareInstance] startPlayWithUrl:wordModel.usPVoice];
    }
    [[DLGPlayer shareInstance] play];
    self.usPlayGifImage.hidden = NO;
    [self.usPlayGifImage startAnimating];
}
- (void)allExpandAction{
    if ([self.view respondsToSelector:@selector(allExpand:)]) {
        [self.view allExpand:YES];
    }
}
- (void)allFoldAction{
    if ([self.view respondsToSelector:@selector(allExpand:)]) {
        [self.view allExpand:NO];
    }
}
#pragma mark getter
- (UILabel *)wordL{
    if (!_wordL) {
        _wordL = [UILabel new];
        _wordL.textColor = [UIColor blackColor];
        _wordL.font = [UIFont systemFontOfSize:30];
    }
    return _wordL;
}
- (UILabel *)textL{
    if (!_textL) {
        _textL = [UILabel new];
        _textL.backgroundColor = [UIColor whiteColor];
        _textL.textColor = [UIColor darkGrayColor];
        _textL.font = [UIFont systemFontOfSize:14];
        _textL.numberOfLines = 0;
    }
    return _textL;
}
- (UIImageView *)enPlayGifImage{
    if (!_enPlayGifImage) {
        _enPlayGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
       _enPlayGifImage.animationImages = DLG_VoiceGifs();
        _enPlayGifImage.animationDuration = 1.0;
        _enPlayGifImage.hidden = YES;
    }
    return _enPlayGifImage;
}
- (UIImageView *)usPlayGifImage{
    if (!_usPlayGifImage) {
        _usPlayGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _usPlayGifImage.animationImages = DLG_VoiceGifs();
        _usPlayGifImage.animationDuration = 1.0;
        _usPlayGifImage.hidden = YES;
    }
    return _usPlayGifImage;
}
- (DLGITButton *)enVoiceBtn{
    if (!_enVoiceBtn) {
        _enVoiceBtn = [DLGITButton buttonWithType:UIButtonTypeCustom];
        _enVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_enVoiceBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"voice1")] forState:UIControlStateNormal];
        [_enVoiceBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"voice2")] forState:UIControlStateHighlighted];
        [_enVoiceBtn setTitle:@"英['steibI]" forState:UIControlStateNormal];
        [_enVoiceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_enVoiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_enVoiceBtn addTarget:self action:@selector(enVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enVoiceBtn;
}
- (DLGITButton *)usVoiceBtn{
    if (!_usVoiceBtn) {
        _usVoiceBtn = [DLGITButton buttonWithType:UIButtonTypeCustom];
        _usVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_usVoiceBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"voice1")] forState:UIControlStateNormal];
        [_usVoiceBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"voice2")] forState:UIControlStateHighlighted];
        [_usVoiceBtn setTitle:@"美['steibI]" forState:UIControlStateNormal];
        [_usVoiceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_usVoiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_usVoiceBtn addTarget:self action:@selector(usVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usVoiceBtn;
}
- (DLGITButton *)allExpandBtn{
    if (!_allExpandBtn) {
        _allExpandBtn = [DLGITButton buttonWithType:UIButtonTypeCustom];
        _allExpandBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allExpandBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"expand")] forState:UIControlStateNormal];
        [_allExpandBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"expand_h")] forState:UIControlStateSelected];
        [_allExpandBtn setTitle:@"全部展开" forState:UIControlStateNormal];
        [_allExpandBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_allExpandBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_allExpandBtn addTarget:self action:@selector(allExpandAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allExpandBtn;
}
- (DLGITButton *)allFoldBtn{
    if (!_allFoldBtn) {
        _allFoldBtn = [DLGITButton buttonWithType:UIButtonTypeCustom];
        _allFoldBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allFoldBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"fold")] forState:UIControlStateNormal];
        [_allFoldBtn setImage:[UIImage imageNamed:DLG_GETBundleResource(@"fold_h")] forState:UIControlStateSelected];
        [_allFoldBtn setTitle:@"全部折叠" forState:UIControlStateNormal];
        [_allFoldBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_allFoldBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_allFoldBtn addTarget:self action:@selector(allFoldAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allFoldBtn;
}
@end

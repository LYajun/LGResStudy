//
//  RLGVoiceRecordOperateView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceRecordOperateView.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>

@interface RLGVoiceRecordOperateView ()
@property (nonatomic,strong) UILabel *numL;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,assign) NSInteger totalRecordNum;
@property (nonatomic,assign) NSInteger currentIndex;
@end
@implementation RLGVoiceRecordOperateView
- (instancetype)initWithFrame:(CGRect)frame totalRecordNum:(NSInteger) totalRecordNum{
    if (self = [super initWithFrame:frame]) {
        self.totalRecordNum = totalRecordNum;
        [self layoutUI];
        [self setCurrentRecordIndex:0];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.lastBtn];
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(self.lastBtn.mas_height);
    }];
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(self.lastBtn.mas_height);
    }];
    [self addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.lastBtn.mas_right).offset(20);
        make.right.equalTo(self.nextBtn.mas_left).offset(-20);
    }];
}
- (void)lastClickAction:(UIButton *) btn{
    if (self.RecordIndexBlock) {
        self.RecordIndexBlock(self.currentIndex - 1);
    }
    [self setCurrentRecordIndex:self.currentIndex - 1];
}
- (void)nextClickAction:(UIButton *) btn{
    if (self.RecordIndexBlock) {
        self.RecordIndexBlock(self.currentIndex + 1);
    }
    [self setCurrentRecordIndex:self.currentIndex + 1];
}
- (void)setCurrentRecordIndex:(NSInteger)index{
    self.currentIndex = index;
    self.numL.text = [NSString stringWithFormat:@"%li/%li",index+1,self.totalRecordNum];
    if (self.currentIndex == 0) {
        self.lastBtn.enabled = NO;
        self.nextBtn.enabled = YES;
    }else if (self.currentIndex == self.totalRecordNum-1){
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = NO;
    }else{
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = YES;
    }
}
- (UILabel *)numL{
    if (!_numL) {
        _numL = [UILabel new];
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.font = [UIFont systemFontOfSize:17];
        _numL.textColor = [UIColor darkGrayColor];
    }
    return _numL;
}
- (UIButton *)lastBtn{
    if (!_lastBtn) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_recordlast")] forState: UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(lastClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _lastBtn.enabled = NO;
    }
    return _lastBtn;
}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_recordnext")] forState: UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}
@end

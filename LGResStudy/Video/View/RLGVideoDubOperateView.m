//
//  RLGVideoDubOperateView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoDubOperateView.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>

@interface RLGVideoDubOperateView ()
@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,assign) NSInteger totalDubNum;
@property (nonatomic,assign) NSInteger currentIndex;
@end
@implementation RLGVideoDubOperateView
- (instancetype)initWithFrame:(CGRect)frame totalDubNum:(NSInteger)totalDubNum{
    if (self = [super initWithFrame:frame]) {
        self.totalDubNum = totalDubNum;
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
    [self addSubview:self.previewBtn];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.lastBtn.mas_right).offset(20);
        make.right.equalTo(self.nextBtn.mas_left).offset(-20);
    }];
}
- (void)previewClickAction:(UIButton *) btn{
    if (self.previewBlock) {
        self.previewBlock();
    }
}
- (void)lastClickAction:(UIButton *) btn{
    if (self.dubIndexBlock) {
        self.dubIndexBlock(self.currentIndex - 1);
    }
    [self setCurrentRecordIndex:self.currentIndex - 1];
}
- (void)nextClickAction:(UIButton *) btn{
    if (self.dubIndexBlock) {
        self.dubIndexBlock(self.currentIndex + 1);
    }
    [self setCurrentRecordIndex:self.currentIndex + 1];
}
- (void)setCurrentRecordIndex:(NSInteger)index{
    self.currentIndex = index;
    if (self.currentIndex == 0) {
        self.lastBtn.enabled = NO;
        self.nextBtn.enabled = YES;
    }else if (self.currentIndex == self.totalDubNum-1){
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = NO;
    }else{
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = YES;
    }
}
- (void)setPreviewEnable:(BOOL)previewEnable{
    _previewEnable = previewEnable;
    self.previewBtn.enabled = previewEnable;
}
- (UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"预览配音效果" forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewBtn setTitleColor:RLG_ThemeColor() forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_previewBtn addTarget:self action:@selector(previewClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _previewBtn.enabled = NO;
    }
    return _previewBtn;
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

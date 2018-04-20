//
//  RLGTextOperateView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTextOperateView.h"
#import "RLGTipButton.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGAudioRecorder.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import "RLGRecordListView.h"

@interface RLGTextOperateView ()
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) RLGTipButton *microBtn;
@property (nonatomic,strong) UILabel *stateL;
@end
@implementation RLGTextOperateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
        [self updateInfo];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-4);
        make.width.equalTo(self.recordBtn.mas_height);
    }];
    [self addSubview:self.microBtn];
    [self.microBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.recordBtn);
        make.width.equalTo(self.recordBtn.mas_height);
    }];
    [self addSubview:self.stateL];
    [self.stateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn);
        make.left.equalTo(self.recordBtn.mas_right).offset(5);
        make.right.equalTo(self.microBtn.mas_left).offset(-20);
    }];
    __weak typeof(self) weakSelf = self;
    [RLGAudioRecorder shareInstance].RecorderFinishBlock = ^{
        [weakSelf updateInfo];
        weakSelf.stateL.text = @"";
        weakSelf.recordBtn.selected = NO;
        [LGAlert showStatus:@"录音完成"];
    };
    [RLGAudioRecorder shareInstance].RecorderOccurErrorBlock = ^{
        weakSelf.recordBtn.selected = NO;
        weakSelf.stateL.text = @"";
        [LGAlert showRedStatus:@"录音失败"];
    };
    [RLGAudioRecorder shareInstance].RecordTimeBlock = ^(NSInteger recordTime) {
        weakSelf.stateL.text = [NSString stringWithFormat:@"录音中%@",RLG_Time(recordTime)];
    };
}
- (void)updateInfo{
    NSArray *records = [RLGAudioRecorder shareInstance].recordFiles;
    if (RLG_IsEmpty(records)) {
        self.microBtn.tipEnable = NO;
    }else{
        self.microBtn.tipEnable = YES;
        self.microBtn.tipCount = records.count;
    }
}
#pragma mark action
- (void)playClickAction:(UIButton *) btn{
    if (btn.selected) {
        [[RLGAudioRecorder shareInstance] stop];
    }else{
        self.stateL.text = @"准备录音";
        [[RLGAudioRecorder shareInstance] record];
    }
    btn.selected = !btn.selected;
}
- (void)microClickAction:(UIButton *) btn{
    self.recordBtn.selected = YES;
    [self playClickAction:self.recordBtn];
   RLGRecordListView *listView = [RLGRecordListView showRecordListView];
    __weak typeof(self) weakSelf = self;
    listView.DismissBlock = ^{
        [weakSelf updateInfo];
    };
}
#pragma mark getter
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botplay")] forState: UIControlStateNormal];
          [_recordBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botstop")] forState: UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(playClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordBtn;
}
- (UILabel *)stateL{
    if (!_stateL) {
        _stateL = [UILabel new];
        _stateL.textColor = RLG_Color(0x3AADD1);
        _stateL.font = [UIFont systemFontOfSize:14];
    }
    return _stateL;
}
- (RLGTipButton *)microBtn{
    if (!_microBtn) {
        _microBtn = [RLGTipButton buttonWithType:UIButtonTypeCustom];
        [_microBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_microphone")] forState: UIControlStateNormal];
        [_microBtn addTarget:self action:@selector(microClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _microBtn.tipEnable = NO;
    }
    return _microBtn;
}
@end

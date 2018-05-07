//
//  RLGSpeechTipView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/26.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGSpeechTipView.h"
#import "RLGWeakTimer.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGSpeechEngine.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import <AVFoundation/AVFoundation.h>

@interface RLGSpeechTipView ()
@property (nonatomic,strong) UIImageView *bgImageV;
@property (nonatomic,strong) UILabel *stateLab;
@property(nonatomic,strong) RLGWeakTimer *timer;
@property (nonatomic,assign) NSInteger timeCount;
@end
@implementation RLGSpeechTipView
- (instancetype)initWithFrame:(CGRect)frame refText:(NSString *) refText recordTime:(NSInteger) recordTime{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
        self.timeCount = recordTime;
        if ([[RLGSpeechEngine shareInstance] isInitConfig]) {
            [self startSpeechEngine];
            [self startRecordWithReftext:refText];
        }else{
            self.stateLab.text = @"语音打分服务未开启";
            if (self.speechFinishBlock) {
                self.speechFinishBlock(@"");
            }
        }
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.bgImageV];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.stateLab];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
    }];
}
- (void)startSpeechEngine{
    __weak typeof(self) weakSelf = self;
    [[RLGSpeechEngine shareInstance] speechEngineResult:^(RLGSpeechResultModel *resultModel) {
        [weakSelf stopTimeer];
        if (resultModel.isError) {
             weakSelf.stateLab.text = @"语音打分异常!";
            NSLog(@"结束评测错误:%@",resultModel.errorMsg);
        }else{
            weakSelf.stateLab.text = [NSString stringWithFormat:@"得分: %@分",resultModel.totalScore];
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
            [plist setObject:[resultModel rlg_JSONObject] forKey:resultModel.speechID];
            [plist writeToFile:RLG_SpeechRecordInfoPath() atomically:false];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (weakSelf.speechFinishBlock) {
                weakSelf.speechFinishBlock(resultModel.speechID);
            }
        });
    }];
}
- (void)stopTimeer{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)startRecordWithReftext:(NSString *) refText{
    [self.timer fire];
    [[RLGSpeechEngine shareInstance] startEngineAtRefText:refText markType:RLGSpeechEngineMarkTypeSen];
}
- (RLGWeakTimer *)timer{
    if (!_timer) {
        _timer = [RLGWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES dispatchQueue:dispatch_queue_create("LGResStudyTimerQueue", DISPATCH_QUEUE_CONCURRENT)];
    }
    return _timer;
}
- (void)timerAction{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.timeCount == 0) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            weakSelf.stateLab.text = @"请稍等,评分中";
             [[RLGSpeechEngine shareInstance] stopEngine];
        }else{
            weakSelf.stateLab.text = [NSString stringWithFormat:@"请跟读,录音中...%li",weakSelf.timeCount];
            weakSelf.timeCount--;
        }
    });
}
- (UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [UILabel new];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.font = [UIFont systemFontOfSize:15];
        _stateLab.text = @"录音准备...";
    }
    return _stateLab;
}
- (UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_tipbg")]];
    }
    return _bgImageV;
}
@end

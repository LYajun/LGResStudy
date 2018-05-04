//
//  RLGVoiceOperateView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceOperateView.h"
#import "RLGTipButton.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGVoicePlayer.h"
#import "RLGResModel.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import "RLGSpeechEngine.h"

@interface RLGVoiceOperateView ()
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UILabel *playTimeL;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIProgressView *progressBufView;
@property (nonatomic,strong) RLGTipButton *microBtn;
@property (nonatomic,strong) RLGVoicePlayer *player;

@property (nonatomic,copy) NSString *voiceUrl;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) CGFloat currentPlayProgress;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) BOOL isSpeeching;
@property (nonatomic,assign) BOOL isSpeeched;
@end
@implementation RLGVoiceOperateView
- (instancetype)initWithFrame:(CGRect)frame voiceUrl:(NSString *)voiceUrl{
    if (self = [super initWithFrame:frame]) {
        self.voiceUrl = voiceUrl;
        self.lastBtn.enabled = NO;
        [LGAlert showIndeterminateWithStatus:@"缓冲中..."];
        [self.player setPlayerWithUrlString:voiceUrl];
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.playTimeL];
    [self.playTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(8);
    }];
    
    [self addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playTimeL);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.playTimeL.mas_left).offset(-5);
    }];
    
    [self insertSubview:self.progressBufView belowSubview:self.progressSlider];
    [self.progressBufView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.equalTo(self.progressSlider);
    }];
    [self addSubview:self.lastBtn];
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(6);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(self.lastBtn.mas_height);
    }];
    
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.lastBtn);
        make.left.equalTo(self.lastBtn.mas_right).offset(25);
        make.width.equalTo(self.recordBtn.mas_height);
    }];

    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.lastBtn);
        make.left.equalTo(self.recordBtn.mas_right).offset(25);
        make.width.equalTo(self.nextBtn.mas_height);
    }];

    [self addSubview:self.microBtn];
    [self.microBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playTimeL.mas_bottom).offset(5);
        make.centerY.equalTo(self.lastBtn);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(self.microBtn.mas_height);
    }];
}
- (void)setIsNeedRecord:(BOOL)isNeedRecord{
    _isNeedRecord = isNeedRecord;
    self.microBtn.hidden = !isNeedRecord;
}
- (void)setResModel:(RLGResModel *)resModel{
    _resModel = resModel;
    [self updateInfo];
}
- (void)updateInfo{
    NSArray *records = [[RLGSpeechEngine shareInstance] recordNames];
    if (RLG_IsEmpty(records)) {
        self.microBtn.tipEnable = NO;
    }else{
        NSInteger count = 0;
        RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
        for (RLGResVideoModel *model in contentModel.VideoTrainSynInfo) {
            if (!RLG_IsEmpty(model.recordNameList)) {
                for (NSString *recordName in model.recordNameList) {
                    if ([records containsObject:recordName]) {
                        count++;
                    }
                }
            }
        }
        if (count > 0) {
            self.microBtn.tipCount = count;
        }
    }
}
- (void)resetSetup{
    [self.player stop];
    self.playTimeL.text = [NSString stringWithFormat:@"00:00/%@",RLG_Time(self.duration)];
    self.recordBtn.selected = NO;
    self.currentIndex = 0;
    self.progressSlider.value = 0;
    self.lastBtn.enabled = NO;
    self.nextBtn.enabled = YES;
}
- (void)setCurrentPlayIndex:(NSInteger)index{
    self.currentIndex = index;
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[index];
    [self.player seekToTime:videoModel.Starttime.floatValue / 1000 isPlay:NO];
    [self.player play];
}
- (void)setCurrentPlayProgress:(CGFloat)currentPlayProgress{
    _currentPlayProgress = currentPlayProgress;
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    if (self.currentIndex == 0) {
        self.lastBtn.enabled = NO;
        self.nextBtn.enabled = YES;
    }else if (self.currentIndex == contentModel.VideoTrainSynInfo.count - 1){
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = NO;
    }else{
        self.lastBtn.enabled = YES;
        self.nextBtn.enabled = YES;
    }
    BOOL isNext = NO;
    for (int i = 0; i < contentModel.VideoTrainSynInfo.count; i++) {
        RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[i];
        CGFloat playTime = currentPlayProgress * 1000;
        if (playTime >= videoModel.Starttime.floatValue && playTime <= (videoModel.Starttime.floatValue + videoModel.Timelength.floatValue) && i == self.currentIndex+1) {
            isNext = YES;
            self.currentIndex = i;
            break;
        }
    }
    if (isNext) {
        if (self.isNeedRecord) {
            [self.player pause];
            if (self.PlayRecordIndexBlock) {
                self.PlayRecordIndexBlock(self.currentIndex - 1);
            }
        }else{
            if (self.PlayIndexBlock) {
                self.PlayIndexBlock(self.currentIndex);
            }
        }
    }
}
- (void)progressSliderTouchDownEvent:(UISlider *) slider{
    [self.player pause];
}
- (void)progressSliderTouchUpEvent:(UISlider *) slider{
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    NSInteger index = 0;
    CGFloat playTime = slider.value*self.duration * 1000;
    for (int i = 0; i < contentModel.VideoTrainSynInfo.count; i++) {
        RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[i];
        if (playTime >= videoModel.Starttime.floatValue && playTime <= (videoModel.Starttime.floatValue + videoModel.Timelength.floatValue)) {
            index = i;
            break;
        }
    }
    [self setCurrentPlayIndex:index];
    if (self.PlayIndexBlock) {
        self.PlayIndexBlock(index);
    }
}
- (void)playClickAction:(UIButton *) btn{
    if (btn.selected) {
        [self.player pause];
        btn.selected = NO;
    }else{
        [self.player play];
        btn.selected = YES;
    }
}
- (void)stopPlay{
    [self.player stop];
}
- (void)play{
    self.recordBtn.selected = YES;
    [self updateInfo];
     [self.player play];
    if (self.PlayIndexBlock) {
        self.PlayIndexBlock(self.currentIndex);
    }
}
- (void)pause{
    self.recordBtn.selected = YES;
    [self playClickAction:self.recordBtn];
}
- (void)lastClickAction:(UIButton *) btn{
    [self.player pause];
    if (self.PlayIndexBlock) {
        self.PlayIndexBlock(self.currentIndex - 1);
    }
    [self setCurrentPlayIndex:self.currentIndex - 1];
}
- (void)nextClickAction:(UIButton *) btn{
    [self.player pause];
    if (self.PlayIndexBlock) {
        self.PlayIndexBlock(self.currentIndex + 1);
    }
    [self setCurrentPlayIndex:self.currentIndex + 1];
}
- (void)microClickAction:(UIButton *) btn{
    self.recordBtn.selected = YES;
    [self playClickAction:self.recordBtn];
    if (self.MicroClickBlock) {
        self.MicroClickBlock();
    }
}
#pragma mark getter
- (RLGVoicePlayer *)player{
    if (!_player) {
        _player = [[RLGVoicePlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _player.TotalDurationBlock = ^(CGFloat totalDuration) {
            weakSelf.duration = totalDuration;
            weakSelf.playTimeL.text = [NSString stringWithFormat:@"00:00/%@",RLG_Time(weakSelf.duration)];
        };
        _player.TotalBufferBlock = ^(CGFloat totalBuffer) {
             weakSelf.progressBufView.progress = totalBuffer /  weakSelf.duration;
            if (totalBuffer >= weakSelf.duration*0.9) {
                [LGAlert hide];
            }
        };
        _player.PlayProgressBlock = ^(CGFloat progress) {
            weakSelf.currentPlayProgress = progress;
            weakSelf.progressSlider.value = progress /  weakSelf.duration;
            weakSelf.playTimeL.text = [NSString stringWithFormat:@"%@/%@",RLG_Time(progress),RLG_Time(weakSelf.duration)];
        };
        _player.PlayFinishBlock = ^{
            [weakSelf resetSetup];
            if (weakSelf.PlayIndexBlock) {
                weakSelf.PlayIndexBlock(weakSelf.currentIndex);
            }
        };
        _player.PlayFailBlock = ^{
            weakSelf.recordBtn.selected = NO;
            [LGAlert showRedStatus:@"音频文件加载失败"];
        };
        _player.SeekFinishBlock = ^{
            weakSelf.recordBtn.selected = YES;
        };
        _player.PlaybackLikelyToKeepUpBlock = ^(BOOL isKeepUp) {
            if (isKeepUp) {
                [LGAlert hide];
            }else{
                [LGAlert showIndeterminateWithStatus:@"缓冲中..."];
            }
        };
    }
    return _player;
}
- (UIButton *)lastBtn{
    if (!_lastBtn) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botlast")] forState: UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(lastClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lastBtn;
}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botnext")] forState: UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botplay")] forState: UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_botpause")] forState: UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(playClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordBtn;
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
- (UISlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_progressSlider setThumbImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_slide")] forState:UIControlStateNormal];
        _progressSlider.minimumTrackTintColor = RLG_ThemeColor();
        _progressSlider.maximumTrackTintColor = [UIColor clearColor];
        _progressSlider.value = 0;
        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchCancel];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpOutside];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _progressSlider;
}
- (UIProgressView *)progressBufView{
    if (!_progressBufView) {
        _progressBufView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressBufView.progressTintColor = [UIColor lightGrayColor];
        _progressBufView.trackTintColor = [UIColor darkGrayColor];
        _progressBufView.progress = 0;
    }
    return _progressBufView;
}
- (UILabel *)playTimeL{
    if (!_playTimeL) {
        _playTimeL = [UILabel new];
        _playTimeL.textAlignment = NSTextAlignmentRight;
        _playTimeL.textColor = [UIColor lightGrayColor];
        _playTimeL.font = [UIFont systemFontOfSize:10];
        _playTimeL.text = @"00:00/00:00";
    }
    return _playTimeL;
}
@end

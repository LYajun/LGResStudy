//
//  RLGVideoDubView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoDubView.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGSpeechEngine.h"
#import "RLGAudioRecorder.h"
#import "RLGWeakTimer.h"
#import <LGAlertUtil/LGAlertUtil.h>

@interface RLGVideoDubButton : UIButton

@end
@implementation RLGVideoDubButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height*3/4;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height/4;
    return CGRectMake(0, titleY, titleW, titleH);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.height*3/4;
    CGFloat imageH = imageW;
    CGFloat imageX = (contentRect.size.width - imageW)/2;
    return CGRectMake(imageX, 0, imageW, imageH);
    
}
@end
@interface RLGVideoDubView ()
@property (nonatomic,strong) UILabel *dubL;
@property (nonatomic,strong) UIButton *dubBtn;
@property (nonatomic,strong) UILabel *dubStateL;
@property (strong, nonatomic) UIImageView *dubGifImage;
@property (nonatomic,strong) RLGVideoDubButton *originBtn;
@property (nonatomic,strong) RLGVideoDubButton *playbackBtn;
@property (nonatomic,strong) UILabel *dubScoreL;
@property (nonatomic,strong) RLGAudioRecorder *player;
@property(nonatomic,strong) RLGWeakTimer *timer;
@property (nonatomic,assign) NSInteger timeCount;
@end
@implementation RLGVideoDubView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.dubBtn];
    [self.dubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [self addSubview:self.dubGifImage];
    [self.dubGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dubBtn);
    }];
  
    [self addSubview:self.dubStateL];
    [self.dubStateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.dubBtn.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    
    [self addSubview:self.originBtn];
    [self.originBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dubStateL.mas_bottom).offset(25);
        make.centerX.equalTo(self).offset(-50);
        make.size.mas_equalTo(CGSizeMake(64, 80));
    }];
    [self addSubview:self.playbackBtn];
    [self.playbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originBtn);
        make.centerX.equalTo(self).offset(50);
        make.size.mas_equalTo(CGSizeMake(64, 80));
    }];
    
    [self addSubview:self.dubScoreL];
    [self.dubScoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.playbackBtn);
        make.left.equalTo(self.playbackBtn.mas_right);
    }];
    
    [self addSubview:self.dubL];
    [self.dubL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self.dubBtn.mas_top).offset(-10);
    }];
}
- (void)setVideoModel:(RLGResVideoModel *)videoModel{
    _videoModel = videoModel;
    NSString *eText = videoModel.Etext_attr.string;
    if ([eText hasSuffix:@"\n"]) {
        eText = [eText substringToIndex:eText.length-1];
    }
    NSMutableAttributedString *eAttr = [[NSMutableAttributedString alloc] initWithString:eText];
    [eAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, eAttr.length)];
    self.dubL.attributedText = eAttr;
    
    self.playbackBtn.enabled = !RLG_IsEmpty(self.videoModel.recordNames);
    self.timeCount = self.videoModel.Timelength.floatValue/1000+1;
    
    if (!RLG_IsEmpty(self.videoModel.recordNames)) {
        NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
        RLGSpeechResultModel *markModel = [RLGSpeechResultModel speechResultWithDictionary:[plist objectForKey:self.videoModel.recordNames]];
        [self setRecordScore:[NSString stringWithFormat:@"%@",markModel.totalScore]];
    }
}
- (void)setRecordScore:(NSString *) score{
    self.playbackBtn.enabled = YES;
    NSMutableAttributedString *attr = RLG_AttributedString(@"分", 14);
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attr.length)];
    NSMutableAttributedString *scoreAttr = RLG_AttributedString(score, 18);
    if (score.floatValue >= 60) {
        [scoreAttr addAttribute:NSForegroundColorAttributeName value:RLG_Color(0x00CD00) range:NSMakeRange(0,scoreAttr.length)];
    }else{
        [scoreAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,scoreAttr.length)];
    }
    [attr insertAttributedString:scoreAttr atIndex:0];
    self.dubScoreL.attributedText = attr;
}
- (void)dubAction:(UIButton *) btn{
    if (self.dubGifImage.hidden) {
        if ([[RLGSpeechEngine shareInstance] isInitConfig]) {
            if (self.dubBlock) {
                self.dubBlock();
            }
            self.dubGifImage.hidden = NO;
            [self.dubGifImage startAnimating];
            [self startSpeechEngine];
            NSString *eText = self.videoModel.Etext_attr.string;
            if ([eText containsString:@"\n"]) {
                eText = [eText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            }
            [self startRecordWithReftext:eText];
        }else{
            [LGAlert showRedStatus:@"语音打分服务未开启"];
        }
        
    }
}
- (void)originAction:(UIButton *) btn{
    if (self.originBlock) {
        self.originBlock();
    }
}
- (void)playDub{
    [self playbackAction:nil];
}
- (void)playbackAction:(UIButton *) btn{
    NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.videoModel.recordNames]];
    [self.player playAtPath:fullpath];
}
- (void)startSpeechEngine{
    __weak typeof(self) weakSelf = self;
    [[RLGSpeechEngine shareInstance] speechEngineResult:^(RLGSpeechResultModel *resultModel) {
        [weakSelf stopTimeer];
        if (resultModel.isError) {
            [LGAlert showRedStatus:@"语音打分异常!"];
            NSLog(@"结束评测错误:%@",resultModel.errorMsg);
        }else{
            if (![[NSUserDefaults standardUserDefaults] boolForKey:NSStringFromClass([self class])]) {
                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:NSStringFromClass([self class])];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [LGAlert alertSuccessWithMessage:[NSString stringWithFormat:@"配音得分: %@分\n配音文件只保存得分最高的",resultModel.totalScore] confirmBlock:nil];
            }else{
                [LGAlert showStatus:[NSString stringWithFormat:@"配音得分: %@分",resultModel.totalScore]];
            }
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
            if (!RLG_IsEmpty(weakSelf.videoModel.recordNames) && !RLG_IsEmpty([plist objectForKey:weakSelf.videoModel.recordNames])) {
                RLGSpeechResultModel *model = [RLGSpeechResultModel speechResultWithDictionary:[plist objectForKey:weakSelf.videoModel.recordNames]];
                if (resultModel.totalScore.floatValue > model.totalScore.floatValue) {
                    weakSelf.videoModel.recordNames = resultModel.speechID;
                    NSMutableDictionary *namePlist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordNamePath()];
                    [namePlist setObject:weakSelf.videoModel.recordNames forKey:weakSelf.videoModel.OrgID];
                    [namePlist writeToFile:RLG_SpeechRecordNamePath() atomically:false];
                    [weakSelf setRecordScore:[NSString stringWithFormat:@"%@",resultModel.totalScore]];
                    if (weakSelf.dubResultBlock) {
                        weakSelf.dubResultBlock();
                    }
                }
            }else{
                weakSelf.videoModel.recordNames = resultModel.speechID;
                NSMutableDictionary *namePlist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordNamePath()];
                [namePlist setObject:weakSelf.videoModel.recordNames forKey:weakSelf.videoModel.OrgID];
                [namePlist writeToFile:RLG_SpeechRecordNamePath() atomically:false];
                [weakSelf setRecordScore:[NSString stringWithFormat:@"%@",resultModel.totalScore]];
                if (weakSelf.dubResultBlock) {
                    weakSelf.dubResultBlock();
                }
            }
            [plist setObject:[resultModel rlg_JSONObject] forKey:resultModel.speechID];
            [plist writeToFile:RLG_SpeechRecordInfoPath() atomically:false];
        }
        
    }];
}
- (void)startRecordWithReftext:(NSString *) refText{
    [self.timer fire];
    [[RLGSpeechEngine shareInstance] startEngineAtRefText:refText];
}
- (void)stopTimeer{
    self.timeCount = self.videoModel.Timelength.floatValue/1000+1;
    self.dubGifImage.hidden = YES;
    [self.dubGifImage stopAnimating];
    self.dubStateL.text = @"点击话筒,开始配音";
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerAction{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.timeCount == 0) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            weakSelf.dubStateL.text = @"请稍等,评分中";
            [[RLGSpeechEngine shareInstance] stopEngine];
        }else{
            weakSelf.dubStateL.text = [NSString stringWithFormat:@"正在配音...%li",weakSelf.timeCount];
            weakSelf.timeCount--;
        }
    });
}
#pragma mark getter
- (RLGWeakTimer *)timer{
    if (!_timer) {
        _timer = [RLGWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES dispatchQueue:dispatch_queue_create("LGResStudyTimerQueue", DISPATCH_QUEUE_CONCURRENT)];
    }
    return _timer;
}

- (RLGAudioRecorder *)player{
    if (!_player) {
        _player = [[RLGAudioRecorder alloc] init];
    }
    return _player;
}
- (UILabel *)dubL{
    if (!_dubL) {
        _dubL = [UILabel new];
        _dubL.numberOfLines = 0;
        _dubL.textAlignment = NSTextAlignmentCenter;
    }
    return _dubL;
}
- (UILabel *)dubStateL{
    if (!_dubStateL) {
        _dubStateL = [UILabel new];
        _dubStateL.textAlignment = NSTextAlignmentCenter;
        _dubStateL.font = [UIFont systemFontOfSize:14];
        _dubStateL.textColor = [UIColor lightGrayColor];
        _dubStateL.text = @"点击话筒,开始配音";
    }
    return _dubStateL;
}
- (UILabel *)dubScoreL{
    if (!_dubScoreL) {
        _dubScoreL = [UILabel new];
    }
    return _dubScoreL;
}
- (UIButton *)dubBtn{
    if (!_dubBtn) {
        _dubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dubBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_dub4")] forState:UIControlStateNormal];
        [_dubBtn addTarget:self action:@selector(dubAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dubBtn;
}
- (UIImageView *)dubGifImage{
    if (!_dubGifImage) {
        _dubGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dubGifImage.animationImages = RLG_RecordGifs();
        _dubGifImage.animationDuration = 1.0;
        _dubGifImage.hidden = YES;
    }
    return _dubGifImage;
}
- (RLGVideoDubButton *)originBtn{
    if (!_originBtn) {
        _originBtn = [RLGVideoDubButton buttonWithType:UIButtonTypeCustom];
        [_originBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_dub3")] forState:UIControlStateNormal];
        [_originBtn setTitle:@"原音" forState:UIControlStateNormal];
        [_originBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_originBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _originBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_originBtn addTarget:self action:@selector(originAction:) forControlEvents:UIControlEventTouchUpInside];
    }
     return _originBtn;
}
- (RLGVideoDubButton *)playbackBtn{
    if (!_playbackBtn) {
        _playbackBtn = [RLGVideoDubButton buttonWithType:UIButtonTypeCustom];
        [_playbackBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_dub2")] forState:UIControlStateNormal];
        [_playbackBtn setTitle:@"配音" forState:UIControlStateNormal];
        [_playbackBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_playbackBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_playbackBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _playbackBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_playbackBtn addTarget:self action:@selector(playbackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playbackBtn;
}
@end

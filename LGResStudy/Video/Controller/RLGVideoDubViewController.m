//
//  RLGVideoDubViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoDubViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGResModel.h"
#import "RLGVideoDubOperateView.h"
#import "RLGVideoDubView.h"
#import "RLGVoicePlayer.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import "YJPlayerView.h"
#import "RLGSpeechEngine.h"

@interface RLGVideoDubViewController ()
@property (nonatomic, strong) YJPlayerView *playerView;
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,strong) UIScrollView *scorllView;
@property (nonatomic,strong) RLGVideoDubOperateView *operateView;
@property (nonatomic,strong) RLGVoicePlayer *player;
@property (nonatomic,strong) UILabel *indexL;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation RLGVideoDubViewController
- (instancetype)initWithResModel:(RLGResModel *) resModel{
    if (self = [super init]) {
        self.resModel = resModel;
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LGAlert showIndeterminateWithStatus:@"初始化..."];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self layoutUI];
}

- (void)layoutUI{
    
    [self.view addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    UIView *playContentView = [UIView new];
    [self.view addSubview:playContentView];
    [playContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.left.equalTo(self.view);
        make.height.mas_equalTo(RLG_ScreenWidth()*9/16);
    }];
    [playContentView addSubview:self.playerView];
    __weak typeof(self) weakSelf = self;
    self.playerView.BackClickBlock = ^{
        [[RLGSpeechEngine shareInstance] stopEngine];
        [weakSelf.playerView destroyPlayer];
        [weakSelf.player stop];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    self.playerView.fatherView = playContentView;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(playContentView);
    }];
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.playerView setVideoUrl:contentModel.ResMediaPath isPlay:NO];
    self.playerView.videoTitle = self.resModel.ResName;
    self.playerView.subTitleModels = contentModel.VideoTrainSynInfo;
    self.playerView.hideStateBar = YES;
    self.playerView.isDubMode = YES;
    self.playerView.isSilence = YES;
    
    [self.view addSubview:self.scorllView];
    [self.scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playContentView.mas_bottom);
        make.left.centerX.equalTo(self.view);
        make.bottom.equalTo(self.operateView.mas_top);
    }];
    UIView *scrollContentView = [UIView new];
    scrollContentView.tag = 110;
    [self.scorllView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scorllView);
        make.height.equalTo(self.scorllView);
    }];
    
    UIView *lastView;
    for (int i = 0; i < contentModel.VideoTrainSynInfo.count; i++) {
        RLGVideoDubView *dubView = [[RLGVideoDubView alloc] init];
        dubView.videoModel = contentModel.VideoTrainSynInfo[i];
        dubView.originBlock = ^{
            [weakSelf.player seekToTime:contentModel.VideoTrainSynInfo[i].Starttime.floatValue/1000];
        };
        dubView.dubBlock = ^{
            [weakSelf.playerView play];
        };
        dubView.dubResultBlock = ^{
            weakSelf.operateView.previewEnable = !RLG_IsEmpty(contentModel.VideoTrainSynInfo[i].recordNames);
        };
        dubView.tag = i;
        [scrollContentView addSubview:dubView];
        [dubView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.top.equalTo(scrollContentView);
            make.width.mas_equalTo(RLG_ScreenWidth());
            if (i == 0) {
                make.left.equalTo(scrollContentView);
            }else{
                make.left.equalTo(lastView.mas_right);
            }
        }];
        if (i == contentModel.VideoTrainSynInfo.count - 1) {
            [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(dubView.mas_right);
            }];
        }
        lastView = dubView;
    }
    
    [self.view addSubview:self.indexL];
    [self.indexL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.operateView.mas_top);
    }];
    self.currentIndex = 0;
    [self loadData];
}
- (void)loadData{
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.player setPlayerWithUrlString:contentModel.ResMediaPath];
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
     RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    self.indexL.text = [NSString stringWithFormat:@"%li/%li",currentIndex+1,contentModel.VideoTrainSynInfo.count];
    self.currentDubView.videoModel = contentModel.VideoTrainSynInfo[currentIndex];
}
- (RLGVideoDubView *)currentDubView{
    UIView *scrollContentView = [self.scorllView viewWithTag:110];
    RLGVideoDubView *dubView = [scrollContentView viewWithTag:self.currentIndex];
    return dubView;
}
- (YJPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[YJPlayerView alloc] initWithFrame:CGRectZero];
    }
    return _playerView;
}
- (UILabel *)indexL{
    if (!_indexL) {
        _indexL = [UILabel new];
        _indexL.textColor = [UIColor lightGrayColor];
        _indexL.font = [UIFont systemFontOfSize:15];
        _indexL.textAlignment = NSTextAlignmentCenter;
    }
    return _indexL;
}
- (RLGVideoDubOperateView *)operateView{
    if (!_operateView) {
        RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
        RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo.firstObject;
        _operateView = [[RLGVideoDubOperateView alloc] initWithFrame:CGRectZero totalDubNum:contentModel.VideoTrainSynInfo.count];
        _operateView.previewEnable = !RLG_IsEmpty(videoModel.recordNames);
        __weak typeof(self) weakSelf = self;
        _operateView.dubIndexBlock = ^(NSInteger index) {
            weakSelf.playerView.dubIndex = index;
            weakSelf.currentIndex = index;
            [weakSelf.player pause];
            weakSelf.scorllView.contentOffset = CGPointMake(RLG_ScreenWidth()*index, 0);
            RLGResVideoModel *videoModel1 = contentModel.VideoTrainSynInfo[index];
            weakSelf.operateView.previewEnable = !RLG_IsEmpty(videoModel1.recordNames);
        };
        _operateView.previewBlock = ^{
            [weakSelf.playerView play];
            [weakSelf.currentDubView playDub];
        };
    }
    return _operateView;
}
- (RLGVoicePlayer *)player{
    if (!_player) {
        _player = [[RLGVoicePlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _player.TotalDurationBlock = ^(CGFloat totalDuration) {
            weakSelf.duration = totalDuration;
        };
        _player.TotalBufferBlock = ^(CGFloat totalBuffer) {
            if (totalBuffer >= weakSelf.duration*0.9) {
                [LGAlert hide];
            }
        };
        _player.PlayProgressBlock = ^(CGFloat progress) {
            RLGResContentModel *contentModel = weakSelf.resModel.Reslist.firstObject;
            RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[weakSelf.currentIndex];
            if (progress*1000 >= (videoModel.Starttime.floatValue + videoModel.Timelength.floatValue)) {
                [weakSelf.player pause];
               
            }
        };
        _player.PlayFailBlock = ^{
            [LGAlert hide];
            [LGAlert alertWarningWithMessage:@"音频文件加载失败" canceTitle:@"退出" confirmTitle:@"重新加载" cancelBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } confirmBlock:^{
                [weakSelf loadData];
            }];
        };
        _player.SeekFinishBlock = ^{
        };
        _player.PlaybackLikelyToKeepUpBlock = ^(BOOL isKeepUp) {
            if (isKeepUp) {
                [LGAlert hide];
            }else{
                [LGAlert showIndeterminateWithStatus:@"加载音频文件..."];
            }
        };
    }
    return _player;
}
- (UIScrollView *)scorllView{
    if (!_scorllView) {
        _scorllView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scorllView.scrollEnabled = NO;
    }
    return _scorllView;
}
@end

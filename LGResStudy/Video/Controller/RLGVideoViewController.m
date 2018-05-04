//
//  RLGVideoViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoViewController.h"
#import "RLGCommon.h"
#import "RLGResModel.h"
#import "YJPlayerView.h"
#import "YJDynamicSegment.h"
#import "RLGImportantTextViewController.h"
#import "RLGVideoSubtitleViewController.h"
#import "RLGVideoDubMainViewController.h"
#import <Masonry/Masonry.h>
#import "RLGViewTransferProtocol.h"
#import "RLGSpeechEngine.h"
#import <LGAlertUtil/LGAlertUtil.h>
@interface RLGVideoViewController ()<RLGViewTransferProtocol>
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic, strong) YJPlayerView *playerView;
@property (nonatomic,strong) YJDynamicSegment *segMent;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) RLGVideoDubMainViewController *dubMianVC;
@end

@implementation RLGVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)dealloc{
    RLG_Log(@"RLGVideoViewController dealloc");
    [self.playerView destroyPlayer];
}
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)layoutUI{
    UIView *playContentView = [UIView new];
    [self.view addSubview:playContentView];
    [playContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.left.equalTo(self.view);
        make.height.mas_equalTo(RLG_ScreenWidth()*9/16);
    }];
    [playContentView addSubview:self.playerView];
    self.playerView.fatherView = playContentView;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(playContentView);
    }];
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.playerView setVideoUrl:contentModel.ResMediaPath isPlay:NO];
    self.playerView.videoTitle = self.resModel.ResName;
    self.playerView.isHideBakcBtn = YES;
    self.playerView.subTitleModels = contentModel.VideoTrainSynInfo;
    self.playerView.isShowDub = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(playContentView.mas_bottom);
    }];
    
    UIView *scrollContentView = [UIView new];
    [self.scrollView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.height.equalTo(self.scrollView);
    }];
    [scrollContentView addSubview:self.segMent];
    [self.segMent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.left.equalTo(scrollContentView);
        make.width.mas_equalTo(RLG_ScreenWidth());
    }];
    RLGVideoDubMainViewController *dubMianVC = [[RLGVideoDubMainViewController alloc] initWithResModel:self.resModel];
    dubMianVC.ownController = self;
    [scrollContentView addSubview:dubMianVC.view];
    [dubMianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segMent.mas_right);
        make.centerY.top.equalTo(scrollContentView);
        make.width.mas_equalTo(RLG_ScreenWidth());
    }];
    self.dubMianVC = dubMianVC;
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dubMianVC.view.mas_right);
    }];
    RLGImportantTextViewController *improtantVC = [[RLGImportantTextViewController alloc] initWithImportantTexts:self.resModel.rlgImporKnTexts];
    improtantVC.ownController = self;
    improtantVC.title = @"重要知识点";
    RLGVideoSubtitleViewController *subTitleVC = [[RLGVideoSubtitleViewController alloc] initWithVideoModels:contentModel.VideoTrainSynInfo];
    subTitleVC.ownController = self;
    subTitleVC.title = @"视频字幕";
    self.segMent.viewControllers = @[improtantVC,subTitleVC];
}
- (void)updateData:(RLGResModel *)data{
    self.resModel = data;
    [self layoutUI];
}
- (void)studyModelChangeAtIndex:(NSInteger)index{
    [self.playerView stop];
    if (index == 0) {
        self.scrollView.contentOffset = CGPointZero;
        RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
        [self.playerView setVideoUrl:contentModel.ResMediaPath isPlay:NO];
        [self.dubMianVC stopRecordPlay];
    }else{
        RLG_MicrophoneAuthorization();
        if (![[RLGSpeechEngine shareInstance] isInitConfig]) {
            [LGAlert showIndeterminateWithStatus:@"语音服务启动中..."];
            __weak typeof(self) weakSelf = self;
            [[RLGSpeechEngine shareInstance] initResult:^(BOOL success) {
                [LGAlert showSuccessWithStatus:@"语音评测服务已启动"];
                [RLGSpeechEngine shareInstance].markType = RLGSpeechEngineMarkTypeSen;
                RLGResContentModel *contentModel = weakSelf.resModel.Reslist.firstObject;
                [weakSelf.playerView setVideoUrl:contentModel.ResMediaPath isPlay:NO];
            }];
        }else{
            [RLGSpeechEngine shareInstance].markType = RLGSpeechEngineMarkTypeSen;
            RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
            [self.playerView setVideoUrl:contentModel.ResMediaPath isPlay:NO];
        }
        self.scrollView.contentOffset = CGPointMake(RLG_ScreenWidth(), 0);
    }
    
}
- (void)clickNavBarMoreTool{
    [self.playerView pause];
    [self.dubMianVC stopRecordPlay];
}
- (void)enterDubModel{
    [self.playerView pause];
    [self.dubMianVC stopRecordPlay];
}
- (void)enterWordInquire{
    [self.playerView pause];
}
#pragma mark getter
- (YJPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[YJPlayerView alloc] initWithFrame:CGRectZero];
    }
    return _playerView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}
- (YJDynamicSegment *)segMent{
    if (!_segMent) {
        _segMent = [YJDynamicSegment new];
        _segMent.pageItems = 3;
        _segMent.normalColor = [UIColor blackColor];
        _segMent.selectColor = RLG_ThemeColor();
    }
    return _segMent;
}
@end

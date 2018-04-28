//
//  RLGVoiceRecordViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceRecordViewController.h"
#import "RLGResModel.h"
#import "RLGVoiceRecordOperateView.h"
#import "RLGVoiceRecordTable.h"
#import <Masonry/Masonry.h>
#import "RLGCommon.h"
#import "RLGVoicePlayer.h"
#import <LGAlertUtil/LGAlertUtil.h>

@interface RLGVoiceRecordViewController ()
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,strong) UIScrollView *scorllView;
@property (nonatomic,strong) RLGVoiceRecordOperateView *operateView;
@property (nonatomic,strong) RLGVoicePlayer *player;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation RLGVoiceRecordViewController
- (instancetype)initWithResModel:(RLGResModel *)resModel{
    if (self = [super init]) {
        self.resModel = resModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"我的录音";
    [LGAlert showIndeterminateWithStatus:@"请稍等..."];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self layoutUI];
}
- (void)loadData{
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.player setPlayerWithUrlString:contentModel.ResMediaPath];
}
- (void)layoutUI{
    [self.view addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.scorllView];
    [self.scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerX.equalTo(self.view);
        make.bottom.equalTo(self.operateView.mas_top);
    }];
    UIView *scrollContentView = [UIView new];
    scrollContentView.tag = 110;
    [self.scorllView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scorllView);
        make.height.equalTo(self.scorllView);
    }];
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    UIView *lastView;
    for (int i = 0; i < contentModel.VideoTrainSynInfo.count; i++) {
        RLGVoiceRecordTable *tableView = [[RLGVoiceRecordTable alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.videoModel = contentModel.VideoTrainSynInfo[i];
        tableView.tag = i;
        tableView.ownController = self;
        [scrollContentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
                make.right.equalTo(tableView.mas_right);
            }];
        }
        lastView = tableView;
    }
    [LGAlert hide];
    [self loadData];
}
- (void)loadErrorUpdate{
    [self loadData];
}
- (void)playToIndex:(NSInteger)index{
    self.currentIndex = index;
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[index];
    [self.player seekToTime:videoModel.Starttime.floatValue/1000];
}
- (void)speechDidFinish{
    [self.player pause];
}
- (void)speechRecordDidDelete{
    if (self.DeleteRecordBlock) {
        self.DeleteRecordBlock();
    }
}
- (RLGVoiceRecordTable *)currentTableView{
    UIView *scrollContentView = [self.scorllView viewWithTag:110];
    RLGVoiceRecordTable *tableView = [scrollContentView viewWithTag:self.currentIndex];
    return tableView;
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
                [weakSelf.currentTableView stopHeaderPlay];
            }
        };
        _player.PlayFailBlock = ^{
            [LGAlert showRedStatus:@"音频文件加载失败"];
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
- (RLGVoiceRecordOperateView *)operateView{
    if (!_operateView) {
         RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
        _operateView = [[RLGVoiceRecordOperateView alloc] initWithFrame:CGRectZero totalRecordNum:contentModel.VideoTrainSynInfo.count];
        __weak typeof(self) weakSelf = self;
        _operateView.RecordIndexBlock = ^(NSInteger index) {
            weakSelf.currentIndex = index;
            [weakSelf.player pause];
            [weakSelf.currentTableView stopPlay];
            RLG_StopPlayer();
            weakSelf.scorllView.contentOffset = CGPointMake(RLG_ScreenWidth()*index, 0);
        };
    }
    return _operateView;
}
- (UIScrollView *)scorllView{
    if (!_scorllView) {
        _scorllView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scorllView.scrollEnabled = NO;
    }
    return _scorllView;
}
@end

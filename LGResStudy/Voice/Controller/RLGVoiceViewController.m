//
//  RLGVoiceViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGResModel.h"
#import "RLGVoiceTable.h"
#import "RLGVoiceOperateView.h"
#import "RLGTextPresenter.h"
#import "RLGTextWordView.h"
#import "RLGSpeechEngine.h"
#import <LGAlertUtil/LGAlertUtil.h>

@interface RLGVoiceViewController ()
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,strong) RLGVoiceTable *tableView;
@property (nonatomic,strong) RLGTextPresenter *presenter;
@property (nonatomic,strong) RLGVoiceOperateView *operateView;
@end

@implementation RLGVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)dealloc{
    RLG_Log(@"RLGVoiceViewController dealloc");
}
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)layoutUI{
    [self.view addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.centerX.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerX.equalTo(self.view);
        make.bottom.equalTo(self.operateView.mas_top);
    }];
    self.tableView.resModel = self.resModel;
    self.operateView.resModel = self.resModel;
}
#pragma mark RLGViewTransferProtocol
- (void)updateData:(RLGResModel *)data{
    self.resModel = data;
    [self layoutUI];
}
- (void)selectImporKnText:(NSString *)text{
    [self.presenter startRequestWithWord:text];
}
- (void)studyModelChangeAtIndex:(NSInteger)index{
    if (index == 0) {
        self.operateView.isNeedRecord = NO;
    }else{
        RLG_MicrophoneAuthorization();
        if (![[RLGSpeechEngine shareInstance] isInitConfig]) {
            [LGAlert showIndeterminateWithStatus:@"语音服务启动中..."];
            [[RLGSpeechEngine shareInstance] initResult:^(BOOL success) {
                [LGAlert showSuccessWithStatus:@"语音评测服务已启动"];
            }];
        }
        self.operateView.isNeedRecord = YES;
    }
    [self.operateView resetSetup];
    [self.tableView resetSetup];
}
- (void)updateWordModel:(id)wordModel{
    [RLGTextWordView showTextWordViewWithWordModel:wordModel];
}
- (void)playToIndex:(NSInteger)index{
    [self.operateView setCurrentPlayIndex:index];
}
- (void)speechDidFinish{
    [self.operateView play];
}
#pragma mark getter
- (RLGTextPresenter *)presenter{
    if (!_presenter) {
        _presenter = [[RLGTextPresenter alloc] initWithView:self];
    }
    return _presenter;
}
- (RLGVoiceTable *)tableView{
    if (!_tableView) {
        _tableView = [[RLGVoiceTable alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.ownController = self;
    }
    return _tableView;
}
- (RLGVoiceOperateView *)operateView{
    if (!_operateView) {
        RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
        _operateView = [[RLGVoiceOperateView alloc] initWithFrame:CGRectZero voiceUrl:contentModel.ResMediaPath];
        _operateView.isNeedRecord = NO;
        __weak typeof(self) weakSelf = self;
        _operateView.PlayIndexBlock = ^(NSInteger index) {
            [weakSelf.tableView setCurrentPlayIndex:index];
        };
        _operateView.PlayRecordIndexBlock = ^(NSInteger index) {
            [weakSelf.tableView showSpeechMarkAtIndex:index];
        };
    }
    return _operateView;
}
@end

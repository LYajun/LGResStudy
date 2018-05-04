//
//  LGResStudyViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGResStudyViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGResStudyPresenter.h"
#import "RLGViewTransferProtocol.h"
#import "RLGResModel.h"
#import "RLGImportantWordView.h"
#import "RLGPopupMenu.h"
#import <LGDic/LGDic.h>
#import "RLGWordViewController.h"
#import "RLGSpeechEngine.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import "RLGSpeechEngine.h"


@interface RLGResStudyViewController ()<RLGViewTransferProtocol,RLGPopupMenuDelegate>


@property (strong, nonatomic) RLGResStudyPresenter *presenter;
@property (nonatomic,strong) UISegmentedControl *segMentControl;
@property (nonatomic,strong) RLGResModel *resModel;


@property (strong, nonatomic) UIButton *improtantBtn;
@property (strong, nonatomic) UIButton *moreBtn;
@end

@implementation RLGResStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.presenter startRequest];
}

- (void)dealloc{
    RLG_Log(@"RLGResStudyViewController dealloc");
}
- (void)initUI{
    self.navigationItem.titleView = self.segMentControl;
}
- (void)layoutUI{
    self.segMentControl.hidden = NO;
    [self.segMentControl setTitle:self.resModel.rlgSegmentTitles.firstObject forSegmentAtIndex:0];
    [self.segMentControl setTitle:self.resModel.rlgSegmentTitles.lastObject forSegmentAtIndex:1];
    if (self.resModel.rlgResType != video) {
        [self.view addSubview:self.improtantBtn];
        [self.improtantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-70);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}
- (void)navBar_leftItemPressed{
    RLG_StopPlayer();
    [[RLGSpeechEngine shareInstance] stopEngine];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateData:(RLGResModel *)data{
    self.resModel = data;
    [self layoutUI];
}

- (void)segmentAction:(UISegmentedControl *) segment{
    [self.presenter studyModelChangeAtIndex:segment.selectedSegmentIndex resType:self.resModel.rlgResType];
}
- (void)importantClickEvent{
    RLG_StopPlayer();
   RLGImportantWordView *wordView = [RLGImportantWordView showImportantWordView];
    [wordView updateData:self.resModel.rlgImporKnTexts];
    __weak typeof(self) weakSelf = self;
    wordView.SelectWordBlock = ^(NSString *word) {
        RLGWordViewController *wordVC = [[RLGWordViewController alloc] initWithWord:word];
        [weakSelf.navigationController pushViewController:wordVC animated:YES];
    };
    [self.presenter enterImportantWord];
}
- (void)moreClickEvent{
    NSArray *titles;
    NSArray *images;
//    if (self.resModel.rlgResType != text) {
//        titles = @[@"电子词典",@"笔记",@"重启语音服务"];
//        images = @[RLG_GETBundleResource(@"lg_dic"),RLG_GETBundleResource(@"lg_note"),RLG_GETBundleResource(@"lg_restart")];
//    }else{
        titles = @[@"电子词典",@"笔记"];
        images = @[RLG_GETBundleResource(@"lg_dic"),RLG_GETBundleResource(@"lg_note")];
//    }
    RLG_StopPlayer();
   RLGPopupMenu *menu = [[RLGPopupMenu alloc] initWithTitles:titles icons:images menuWidth:160 delegate:self];
    [menu showRelyOnView:self.moreBtn];
    [self.presenter enterMoreTool];
}
- (void)RLGPopupMenuDidSelectedAtIndex:(NSInteger)index RLGPopupMenu:(RLGPopupMenu *)RLGPopupMenu{
    switch (index) {
        case 0:
            [self openDic];
            break;
        case 1:
            [self openNote];
            break;
        case 2:
            [self restartSpeech];
            break;
        default:
            break;
    }
}
- (void)openDic{
    LGDicConfig().wordUrl = LGResConfig().wordUrl;
    LGDicConfig().userID = LGResConfig().UserID;
    LGDicConfig().parameters = LGResConfig().parameters;
    LGDicConfig().wordKey = LGResConfig().wordKey;
    [self.navigationController pushViewController:LGDicHomeController() animated:YES];
}
- (void)openNote{
    if (LGResConfig().NoteEntryBlock) {
        LGResConfig().NoteEntryBlock();
    }
}
- (void)restartSpeech{
    [LGAlert showIndeterminateWithStatus:@"重启中..."];
    [[RLGSpeechEngine shareInstance] initEngine];
    [[RLGSpeechEngine shareInstance] initResult:^(BOOL success) {
        [LGAlert hide];
        [LGAlert alertSuccessWithMessage:@"语音评测服务已重启" confirmBlock:nil];
    }];
}
- (void)loadErrorUpdate{
    [self.presenter startRequest];
}
#pragma mark getter
- (UISegmentedControl *)segMentControl{
    if (!_segMentControl) {
        _segMentControl = [[UISegmentedControl alloc] initWithItems:@[@"--",@"--"]];
        _segMentControl.frame = CGRectMake(0, 0, RLG_ScreenWidth() / 2, 25);
        [_segMentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segMentControl.selectedSegmentIndex = 0;
        _segMentControl.tintColor = [UIColor whiteColor];
        _segMentControl.backgroundColor = [UIColor clearColor];
        [_segMentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segMentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:RLG_ThemeColor()} forState:UIControlStateSelected];
        _segMentControl.hidden = YES;
    }
    return _segMentControl;
}
- (RLGResStudyPresenter *)presenter{
    if (!_presenter) {
        _presenter = [[RLGResStudyPresenter alloc] initWithView:self];
    }
    return _presenter;
}
- (UIButton *)improtantBtn{
    if (!_improtantBtn) {
        _improtantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_improtantBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_importantword")] forState:UIControlStateNormal];
        [_improtantBtn addTarget:self action:@selector(importantClickEvent) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _improtantBtn;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(0, 0, 28, 28);
        [_moreBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_more")] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClickEvent) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreBtn;
}

@end

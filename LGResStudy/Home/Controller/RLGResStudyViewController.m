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
#import "RLGActivityIndicatorView.h"
#import "RLGResStudyPresenter.h"
#import "RLGViewTransferProtocol.h"
#import "RLGResModel.h"
#import "RLGImportantWordView.h"
#import "RLGAudioRecorder.h"
#import "RLGPopupMenu.h"
#import <LGDic/LGDic.h>

@interface RLGResStudyViewController ()<RLGViewTransferProtocol,RLGPopupMenuDelegate>
/** 加载中 */
@property (strong, nonatomic) UIView *viewLoading;
/** 没有数据 */
@property (strong, nonatomic) UIView *viewNoData;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;

@property (strong, nonatomic) RLGResStudyPresenter *presenter;
@property (nonatomic,strong) UISegmentedControl *segMentControl;
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,assign) BOOL naviBarTranslucent;

@property (strong, nonatomic) UIButton *improtantBtn;
@property (strong, nonatomic) UIButton *moreBtn;
@end

@implementation RLGResStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.presenter startRequest];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.naviBarTranslucent) {
        self.navigationController.navigationBar.translucent = YES;
    }
}
- (void)dealloc{
    RLG_Log(@"RLGResStudyViewController dealloc");
}
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_back")] style:UIBarButtonItemStylePlain target:self action:@selector(navBar_leftItemPressed)];
    self.navigationItem.titleView = self.segMentControl;
    self.naviBarTranslucent = self.navigationController.navigationBar.translucent;
    if (self.naviBarTranslucent) {
        self.navigationController.navigationBar.translucent = NO;
    }
}
- (void)layoutUI{
    self.segMentControl.hidden = NO;
    [self.segMentControl setTitle:self.resModel.rlgSegmentTitles.firstObject forSegmentAtIndex:0];
    [self.segMentControl setTitle:self.resModel.rlgSegmentTitles.lastObject forSegmentAtIndex:1];
    if (self.resModel.rlgResType != video) {
        [self.view addSubview:self.improtantBtn];
        [self.improtantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-54);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)updateData:(RLGResModel *)data{
    self.resModel = data;
    [self layoutUI];
}
- (void)navBar_leftItemPressed{
    [[RLGAudioRecorder shareInstance] stop];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)segmentAction:(UISegmentedControl *) segment{
    [self.presenter studyModelChangeAtIndex:segment.selectedSegmentIndex resType:self.resModel.rlgResType];
}
- (void)importantClickEvent{
   RLGImportantWordView *wordView = [RLGImportantWordView showImportantWordView];
    [wordView updateData:self.resModel.rlgImporKnTexts];
//    __weak typeof(self) weakSelf = self;
    wordView.SelectWordBlock = ^(NSString *word) {
        NSLog(@"单词:%@",word);
    };
}
- (void)moreClickEvent{
    [[RLGAudioRecorder shareInstance] stop];
   RLGPopupMenu *menu = [[RLGPopupMenu alloc] initWithTitles:@[@"电子词典",@"笔记"] icons:@[RLG_GETBundleResource(@"lg_dic"),RLG_GETBundleResource(@"lg_note")] menuWidth:135 delegate:self];
    [menu showRelyOnView:self.moreBtn];
}
- (void)RLGPopupMenuDidSelectedAtIndex:(NSInteger)index RLGPopupMenu:(RLGPopupMenu *)RLGPopupMenu{
    switch (index) {
        case 0:
            [self openDic];
            break;
        case 1:
            [self openNote];
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
#pragma mark Stateview
- (void)setViewLoadingShow:(BOOL)show{
    [self.viewNoData removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoading show:show];
}
- (void)setViewNoDataShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewNoData show:show];
}
- (void)setViewLoadErrorShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewNoData removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoadError show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self.view addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [aView removeFromSuperview];
    }
}
- (UIView *)viewLoading {
    if (!_viewLoading) {
        _viewLoading = [[UIView alloc]init];
        RLGActivityIndicatorView *activityIndicatorView = [[RLGActivityIndicatorView alloc] initWithType:RLGActivityIndicatorAnimationTypeBallPulse tintColor:RLG_Color(0x0EB5F4)];
        [_viewLoading addSubview:activityIndicatorView];
        __weak typeof(self) weakSelf = self;
        [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.viewLoading);
            make.width.height.mas_equalTo(100);
        }];
        [activityIndicatorView startAnimating];
    }
    return _viewLoading;
}

- (UIView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[UIView alloc]init];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"statusView_empy")]];
        [_viewNoData addSubview:img];
            __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewNoData);
            make.centerY.equalTo(weakSelf.viewNoData).offset(-10);
        }];
        UILabel *lab = [[UILabel alloc] init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor =  RLG_Color(0x666666);
        if (self.noDataText && self.noDataText.length > 0) {
            lab.text = self.noDataText;
        }else{
            lab.text = @"亲，尚未查找到...";
        }
        [_viewNoData addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(weakSelf.viewNoData);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
    }
    return _viewNoData;
}
- (UIView *)viewLoadError {
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc]init];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"statusView_error")]];
        [_viewLoadError addSubview:img];
            __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewLoadError);
            make.centerY.equalTo(weakSelf.viewLoadError).offset(-10);
        }];
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RLG_Color(0x333333);
        lab.text = @"糟糕，服务器开小差了,轻触刷新";
        [_viewLoadError addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(weakSelf.viewLoadError);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorUpdate)];
        [_viewLoadError addGestureRecognizer:tap];
        
    }
    return _viewLoadError;
}
- (void)loadErrorUpdate{
    [self.presenter startRequest];
}
@end

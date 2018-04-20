//
//  LGDicViewController.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGDicViewController.h"
#import "DLGCommon.h"
#import "DLGConfig.h"
#import "DLGRecordViewController.h"
#import "DLGResultViewController.h"
#import "DLGSearchTextField.h"
#import "DLGViewTransferProtocol.h"
#import "DLGDicPresenter.h"
#import "DLGWordModel.h"
#import "DLGRecorder.h"
#import "DLGPlayer.h"
#import "DLGAlert.h"

@interface DLGDicViewController ()<DLGSearchTextFieldDelegate,DLGViewTransferProtocol>
@property (nonatomic,strong) DLGRecordViewController<DLGViewTransferProtocol> *recordVC;
@property (nonatomic,strong) DLGResultViewController<DLGViewTransferProtocol> *resultVC;
@property (nonatomic,strong) UIButton *searchBtn;
@property (nonatomic,strong) DLGSearchTextField *searchBar;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) DLGDicPresenter *homePresenter;
@property (nonatomic,assign) BOOL naviBarTranslucent;
@end

@implementation DLGDicViewController
#pragma mark cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DLGPlayer shareInstance] stop];
    if (self.naviBarTranslucent) {
        self.navigationController.navigationBar.translucent = YES;
    }
}
- (void)dealloc{
    DLG_Log(@"LGDicViewController-dealloc");
}
#pragma mark action
- (void)initNavBar{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:DLG_GETBundleResource(@"lg_back")] style:UIBarButtonItemStylePlain target:self action:@selector(navBar_leftItemPressed)];
    self.naviBarTranslucent = self.navigationController.navigationBar.translucent;
    if (self.naviBarTranslucent) {
        self.navigationController.navigationBar.translucent = NO;
    }
}
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    [self.view addSubview:self.mainScrollView];
    [self addSubController:self.recordVC atIndex:0];
    [self addSubController:self.resultVC atIndex:1];
    
    if (!DLG_IsEmpty(LGDicConfig().word)) {
        [self searchWord:LGDicConfig().word];
        LGDicConfig().word = @"";
    }
}
- (void)addSubController:(UIViewController *) subController atIndex:(NSInteger) index{
    subController.view.frame = CGRectMake(DLG_ScreenWidth() * index, 0, DLG_ScreenWidth(), self.mainScrollView.frame.size.height);
    [self.mainScrollView addSubview:subController.view];
    [self addChildViewController:subController];
}
- (void)navBar_leftItemPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBtnAction:(UIButton *) btn{
    if (self.mainScrollView.contentOffset.x/DLG_ScreenWidth() > 0) {
        [[DLGPlayer shareInstance] stop];
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
        [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        self.searchBar.text = @"";
        if ([self.recordVC respondsToSelector:@selector(updateData:)]) {
            [self.recordVC updateData:nil];
        }
    }else{
        if (DLG_IsEmpty(self.searchBar.text)) {
            [[DLGAlert shareInstance] showInfoWithStatus:@"输入不能为空!"];
        }else{
            [self searchWord:self.searchBar.text];
        }
    }
}
#pragma mark delegate && protocol
- (void)dlg_textFieldDidSearch:(DLGSearchTextField *)textField word:(NSString *)word{
     [self searchWord:word];
}
- (void)searchWord:(NSString *)word{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = word;
    [self.homePresenter startRequestWithWord:word];
}
- (void)endEdit{
     [self.searchBar resignFirstResponder];
}
- (void)updateData:(DLGWordModel *)data{
    if(LGDicConfig().QueryBlock){
        LGDicConfig().QueryBlock(self.searchBar.text);
    }
    
    [[DLGRecorder shareInstance] addRecordWithWord:self.searchBar.text meaning:data.wordChineseMean];
    if ([self.resultVC respondsToSelector:@selector(updateData:)]) {
        [self.resultVC updateData:data];
    }
    self.mainScrollView.contentOffset = CGPointMake(DLG_ScreenWidth(), 0);
    [self.searchBtn setTitle:@"取消" forState:UIControlStateNormal];
}

#pragma mark setter getter
- (DLGDicPresenter *)homePresenter{
    if (!_homePresenter) {
        _homePresenter = [[DLGDicPresenter alloc] initWithView:self];
    }
    return _homePresenter;
}
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DLG_ScreenWidth(), DLG_ScreenHeight()- DLG_NaviBarHeight(self))];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.scrollEnabled = NO;
        _mainScrollView.contentSize = CGSizeMake(DLG_ScreenWidth() * 2, 0);
    }
    return _mainScrollView;
}
- (DLGRecordViewController<DLGViewTransferProtocol> *)recordVC{
    if (!_recordVC) {
        _recordVC = [[DLGRecordViewController<DLGViewTransferProtocol> alloc] init];
        _recordVC.transferView = self;
    }
    return _recordVC;
}
- (DLGResultViewController<DLGViewTransferProtocol> *)resultVC{
    if (!_resultVC) {
        _resultVC = [[DLGResultViewController<DLGViewTransferProtocol> alloc] init];
        _resultVC.transferView = self;
    }
    return _resultVC;
}
- (DLGSearchTextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [[DLGSearchTextField alloc] initWithFrame:CGRectMake(0, 0, DLG_ScreenWidth() * 4 / 5, 30)];
        _searchBar.dlgDelegate = self;
    }
    return _searchBar;
}
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, 40, 28);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
@end

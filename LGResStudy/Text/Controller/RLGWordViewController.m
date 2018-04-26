//
//  RLGWordViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGWordViewController.h"
#import "RLGWordModel.h"
#import "RLGWordHeaderView.h"
#import "RLGWordCell.h"
#import <Masonry/Masonry.h>
#import "RLGHttpClient.h"
#import "RLGCommon.h"
#import "RLGVoicePlayer.h"
#import "RLGHttpResponseProtocol.h"

@interface RLGWordViewController ()<UITableViewDelegate,UITableViewDataSource,RLGHttpResponseProtocol>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) RLGHttpClient *presenter;
@property(nonatomic,copy) NSString *word;
@property(nonatomic,strong) RLGWordModel *wordModel;
@property (nonatomic,strong) NSIndexPath *indexP;
@end

@implementation RLGWordViewController
- (instancetype)initWithWord:(NSString *) word{
    if (self = [super init]) {
        self.word = word;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"单词释义";
    self.noDataText = @"无匹配信息";
    [self startRequest];
}
- (void)dealloc{
    RLG_Log(@"RLGWordViewController dealloc");
}
- (void)startRequest{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:LGResConfig().parameters];
    [dic setValue:self.word forKey:LGResConfig().wordKey];
    [self setViewLoadingShow:YES];
    if (LGResConfig().postEnable) {
        [self.presenter post:LGResConfig().wordUrl parameters:dic];
    }else{
        [self.presenter get:LGResConfig().wordUrl parameters:dic];
    }
    
}
- (void)layoutUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)success:(id)responseObject{
    [self setViewLoadingShow:NO];
    self.wordModel = responseObject;
    [self layoutUI];
}
- (void)failure:(NSError *)error{
    if (error.code == 10010) {
        [self setViewNoDataShow:YES];
    }else{
        [self setViewLoadErrorShow:YES];
    }
}
- (void)loadErrorUpdate{
    [self startRequest];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return self.wordModel.wordSenCollection.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        RLGWordHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RLGWordHeaderView class])];
        headerView.wordModel = self.wordModel;
        __weak typeof(self) weakSelf = self;
        headerView.PlayBlock = ^{
            if (weakSelf.indexP) {
                RLGWordCell *lastCell = [tableView cellForRowAtIndexPath:weakSelf.indexP];
                [lastCell stop];
            }
        };
        return headerView;
    }else{
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }else{
        RLGWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLGWordCell class]) forIndexPath:indexPath];
        SenCollectionModel *senModel = self.wordModel.wordSenCollection[indexPath.row];
        cell.wordSenModel = senModel;
        __weak typeof(self) weakSelf = self;
        cell.PlayBlock = ^{
            RLGWordHeaderView *header = (RLGWordHeaderView *)[tableView headerViewForSection:0];
            [header stop];
            if (weakSelf.indexP) {
                RLGWordCell *lastCell = [tableView cellForRowAtIndexPath:weakSelf.indexP];
                [lastCell stop];
            }
            weakSelf.indexP = indexPath;
        };
        return cell;
    }
}
- (RLGHttpClient *)presenter{
    if (!_presenter) {
        _presenter = [[RLGHttpClient alloc] initWithResponder:self];
    }
    return _presenter;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 100;
        _tableView.sectionFooterHeight = 0.1;
        [_tableView registerClass:[RLGWordCell class] forCellReuseIdentifier:NSStringFromClass([RLGWordCell class])];
        [_tableView registerClass:[RLGWordHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RLGWordHeaderView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end

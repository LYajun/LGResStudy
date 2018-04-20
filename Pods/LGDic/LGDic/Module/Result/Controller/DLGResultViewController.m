//
//  DLGResultViewController.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultViewController.h"
#import <Masonry/Masonry.h>
#import "DLGResultTable.h"

@interface DLGResultViewController ()<DLGViewTransferProtocol>
@property (nonatomic,strong)DLGResultTable *tableView;
@end

@implementation DLGResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)updateData:(DLGWordModel *)data{
    self.tableView.wordModel = data;
}

- (DLGResultTable *)tableView{
    if (!_tableView) {
        _tableView = [[DLGResultTable alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end

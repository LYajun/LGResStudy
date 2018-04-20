//
//  DLGRecordViewController.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGRecordViewController.h"
#import "DLGRecordTable.h"
#import <Masonry/Masonry.h>

@interface DLGRecordViewController ()<DLGViewTransferProtocol>
@property (nonatomic,strong)DLGRecordTable *tableView;
@end

@implementation DLGRecordViewController

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

#pragma mark delegate && protocol
- (void)endEdit{
    if ([self.transferView respondsToSelector:@selector(endEdit)]) {
        [self.transferView endEdit];
    }
}
- (void)searchWord:(NSString *)word{
    if ([self.transferView respondsToSelector:@selector(searchWord:)]) {
        [self.transferView searchWord:word];
    }
}
- (void)updateData:(id)data{
    [self.tableView reloadData];
}

#pragma mark getter
- (DLGRecordTable *)tableView{
    if (!_tableView) {
        _tableView = [[DLGRecordTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.ownController = self;
    }
    return _tableView;
}
@end

//
//  DLGRecordTable.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGRecordTable.h"
#import "DLGRecordCell.h"

#import "DLGRecorder.h"

@interface DLGRecordTable ()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation DLGRecordTable
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.rowHeight = 55;
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[DLGRecordCell class] forCellReuseIdentifier:NSStringFromClass([DLGRecordCell class])];
    }
    return self;
}
- (NSArray *)recordList{
    return [[DLGRecorder shareInstance] recordList];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.ownController respondsToSelector:@selector(endEdit)]) {
        [self.ownController endEdit];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLGRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLGRecordCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.recordList[indexPath.row];
    [cell setWord:[info objectForKey:@"word"]];
    [cell setWordMeaning:[info objectForKey:@"meaning"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.ownController respondsToSelector:@selector(searchWord:)]) {
         NSDictionary *info = self.recordList[indexPath.row];
        [self.ownController searchWord:[info objectForKey:@"word"]];
    }
}
@end

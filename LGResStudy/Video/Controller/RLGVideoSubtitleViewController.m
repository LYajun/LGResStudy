//
//  RLGVideoSubtitleViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoSubtitleViewController.h"
#import "RLGResModel.h"
#import <Masonry/Masonry.h>
#import "RLGCommon.h"

@interface RLGVideoSubtitleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *videoModels;
@end

@implementation RLGVideoSubtitleViewController
- (instancetype)initWithVideoModels:(NSArray *) videoModels{
    if (self = [super init]) {
        self.videoModels = videoModels;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RLG_Color(0xF4F4F4);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.bottom.left.centerX.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    RLGResVideoModel *videoModel = self.videoModels[indexPath.row];
    NSMutableAttributedString *attr = videoModel.Etext_attr.mutableCopy;
    if (!RLG_IsEmpty(videoModel.Ctext)) {
        [attr appendAttributedString:videoModel.Ctext_attr];
    }
    NSString *text = attr.string;
    if ([text hasSuffix:@"\n"]) {
        text = [text substringToIndex:text.length-1];
    }
    attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attr.length)];
    cell.textLabel.attributedText = attr;
    return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}
@end

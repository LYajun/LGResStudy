//
//  RLGVideoDubMainViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//



#import "RLGVideoDubMainViewController.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGResModel.h"
#import "RLGVideoDubMainTable.h"
#import "RLGVideoDubViewController.h"

@interface RLGVideoDubMainTitleView : UIView
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
@property (nonatomic,strong) RLGResModel *resModel;
@end

@implementation RLGVideoDubMainTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RLG_Color(0xF4F4F4);
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_dub1")]];
        [self addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).mas_offset(10);
            make.height.mas_equalTo(18);
        }];
        
        UILabel *titleL = [UILabel new];
        titleL.text = @"我的配音";
        titleL.textColor = [UIColor darkGrayColor];
        titleL.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(imageV.mas_right).offset(5);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [micBtn setTitle:@"添加" forState:UIControlStateNormal];
        micBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        micBtn.backgroundColor = RLG_ThemeColor();
        [micBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        micBtn.layer.cornerRadius = 3;
        micBtn.layer.masksToBounds = YES;
        [micBtn addTarget:self action:@selector(addRecordAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:micBtn];
        [micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(self).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
    }
    return self;
}
- (void)addRecordAction{
    if ([self.ownController respondsToSelector:@selector(enterDubModel)]) {
        [self.ownController enterDubModel];
    }
    RLGVideoDubViewController *dubVC = [[RLGVideoDubViewController alloc] initWithResModel:self.resModel];
    [self.ownController presentViewController:dubVC animated:NO completion:nil];
}
@end

@interface RLGVideoDubMainViewController ()
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,strong) RLGVideoDubMainTitleView *titleV;
@property (nonatomic,strong) RLGVideoDubMainTable *tableView;
@end

@implementation RLGVideoDubMainViewController
- (instancetype)initWithResModel:(RLGResModel *) resModel{
    if (self = [super init]) {
        self.resModel = resModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleV];
    [self.titleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.titleV.mas_bottom);
    }];
    self.tableView.resModel = self.resModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.resModel = self.resModel;
}
- (void)stopRecordPlay{
    [self.tableView stopPlay];
}
- (RLGVideoDubMainTitleView *)titleV{
    if (!_titleV) {
        _titleV = [[RLGVideoDubMainTitleView alloc] initWithFrame:CGRectZero];
        _titleV.resModel = self.resModel;
        _titleV.ownController = self.ownController;
    }
    return _titleV;
}
- (RLGVideoDubMainTable *)tableView{
    if (!_tableView) {
        _tableView = [[RLGVideoDubMainTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}
@end

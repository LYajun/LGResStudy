//
//  RLGImportantWordView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGImportantWordView.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGTouchView.h"

@interface RLGImportantWordView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) RLGTouchView *alertView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) NSArray *words;
@end
@implementation RLGImportantWordView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}
+ (instancetype)showImportantWordView{
    RLGImportantWordView *wordView = [[RLGImportantWordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [wordView show];
    return wordView;
}
- (void)initUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}
- (void)layoutUI{
    [self addSubview:self.alertView];
    self.alertView.frame = CGRectMake(0, RLG_ScreenHeight(), RLG_ScreenWidth(), RLG_ScreenHeight()/2);
    [self.alertView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.alertView);
        make.left.equalTo(self.alertView).offset(10);
        make.height.mas_equalTo(44);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = RLG_Color(0xE0E0E0);
    [self.alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.alertView);
        make.top.equalTo(self.titleL.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.alertView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.bottom.equalTo(self.alertView);
        make.top.equalTo(line.mas_bottom);
    }];
}
- (void)updateData:(NSArray *)datas{
    self.words = datas;
    self.titleL.text = [NSString stringWithFormat:@"重要知识点 [%li]",datas.count];
    [self.tableView reloadData];
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    self.alertView.transform = CGAffineTransformMakeTranslation(0, -RLG_ScreenHeight()/4);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.alertView.transform = CGAffineTransformMakeTranslation(0, -RLG_ScreenHeight()/2);
    } completion:^(BOOL finished) {
    }];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alertView.transform = CGAffineTransformIdentity;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.words.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.words[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    if (self.SelectWordBlock) {
        self.SelectWordBlock(self.words[indexPath.row]);
    }
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textColor = RLG_ThemeColor();
        _titleL.text = @"重要知识点 [0]";
    }
    return _titleL;
}
- (RLGTouchView *)alertView{
    if (!_alertView) {
        _alertView = [[RLGTouchView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.rowHeight = 44;
    }
    return _tableView;
}
@end

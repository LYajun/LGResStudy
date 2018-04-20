//
//  RLGRecordListView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGRecordListView.h"
#import "RLGCommon.h"
#import "RLGAudioRecorder.h"
#import <Masonry/Masonry.h>
#import "RLGTouchView.h"

@interface RLGRecordCell : UITableViewCell
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *durationL;
@property (nonatomic,assign) BOOL isPlay;
@end


@implementation RLGRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(self.playBtn.mas_height);
    }];
    [self.contentView addSubview:self.durationL];
    [self.durationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(60);
    }];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(5);
        make.right.equalTo(self.durationL.mas_left).offset(20);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(14);
    }];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.timeL);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.timeL.mas_top).offset(-3);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = RLG_Color(0xE0E0E0);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeL);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}
- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    self.playBtn.selected = isPlay;
}
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_cellplay")] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_cellstop")] forState:UIControlStateSelected];
    }
    return _playBtn;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textColor = [UIColor darkGrayColor];
        _titleL.font = [UIFont systemFontOfSize:17];
    }
    return _titleL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [UILabel new];
        _timeL.textColor = [UIColor lightGrayColor];
        _timeL.font = [UIFont systemFontOfSize:13];
    }
    return _timeL;
}
- (UILabel *)durationL{
    if (!_durationL) {
        _durationL = [UILabel new];
        _durationL.textColor = [UIColor lightGrayColor];
        _durationL.font = [UIFont systemFontOfSize:15];
        _durationL.textAlignment = NSTextAlignmentRight;
    }
    return _durationL;
}
@end

@interface RLGRecordListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) RLGTouchView *alertView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) NSArray *recordArr;
@property(nonatomic,strong) NSIndexPath *indexP;
@end

@implementation RLGRecordListView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}
- (void)initUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    __weak typeof(self) weakSelf = self;
    [RLGAudioRecorder shareInstance].PlayerFinishBlock = ^{
        RLGRecordCell *cell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.indexP];
        cell.isPlay = NO;
    };
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
+ (instancetype)showRecordListView{
    RLGRecordListView *listView = [[RLGRecordListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    listView.recordArr = [RLGAudioRecorder shareInstance].recordURLAssets;
    [listView updateInfo];
    [listView show];
    return listView;
}
- (void)updateInfo{
    NSInteger count = 0;
    if (!RLG_IsEmpty(self.recordArr)) {
        count = self.recordArr.count;
    }
    self.titleL.text = [NSString stringWithFormat:@"我的全部录音 [%li]",count];
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
    if (self.DismissBlock) {
        self.DismissBlock();
    }
    [[RLGAudioRecorder shareInstance] stopPlay];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alertView.transform = CGAffineTransformIdentity;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     RLGAudioModel *model = self.recordArr[indexPath.row];
    [[RLGAudioRecorder shareInstance] removeRecordFileAtPath:model.path];
    self.recordArr = [RLGAudioRecorder shareInstance].recordURLAssets;
    [self updateInfo];
     [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RLGRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLGRecordCell class]) forIndexPath:indexPath];
    RLGAudioModel *model = self.recordArr[indexPath.row];
    cell.isPlay = [[RLGAudioRecorder shareInstance] isPlayAtPath:model.path];
    cell.titleL.text = [NSString stringWithFormat:@"我的录音%02li",indexPath.row+1];
    cell.timeL.text = model.createTime;
    cell.durationL.text = RLG_Time(model.duration);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RLGRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RLGAudioModel *model = self.recordArr[indexPath.row];
    if (self.indexP && ![cell isEqual:[tableView cellForRowAtIndexPath: self.indexP]]) {
        [[RLGAudioRecorder shareInstance] stopPlay];
        RLGRecordCell *cell1 = [tableView cellForRowAtIndexPath: self.indexP];
        cell1.isPlay = NO;
    }
    if (cell.isPlay) {
        [[RLGAudioRecorder shareInstance] stopPlay];
    }else{
        [[RLGAudioRecorder shareInstance] playAtPath:model.path];
    }
    cell.isPlay = !cell.isPlay;
    self.indexP = indexPath;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textColor = RLG_ThemeColor();
    }
    return _titleL;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[RLGRecordCell class] forCellReuseIdentifier:NSStringFromClass([RLGRecordCell class])];
        _tableView.rowHeight = 64;
    }
    return _tableView;
}
- (RLGTouchView *)alertView{
    if (!_alertView) {
        _alertView = [[RLGTouchView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}
@end

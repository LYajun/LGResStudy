//
//  RLGVideoDubMainTable.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVideoDubMainTable.h"
#import "RLGResModel.h"
#import <Masonry/Masonry.h>
#import "RLGCommon.h"
#import "RLGAudioRecorder.h"
#import "RLGSpeechEngine.h"
#import <LGAlertUtil/LGAlertUtil.h>


@interface RLGVideoRecordCell: UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *scoreL;
@property (nonatomic,strong) UILabel *timeL;
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIImageView *playGifImage;
@property (nonatomic,assign) BOOL isPlay;
@end
@implementation RLGVideoRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(66, 25));
    }];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreL.mas_left).offset(-20);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.timeL.mas_top).offset(-5);
        make.height.mas_greaterThanOrEqualTo(30);
        make.width.mas_equalTo(80);
    }];
    
    [self.contentView addSubview:self.playImage];
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.width.height.mas_equalTo(20);
        make.left.equalTo(self.titleL.mas_right).offset(5);
    }];
    
    [self.contentView addSubview:self.playGifImage];
    [self.playGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.top.equalTo(self.playImage);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = RLG_Color(0xF4F4F4);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}
- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    self.playGifImage.hidden = !isPlay;
    if (isPlay) {
        [self.playGifImage startAnimating];
    }else{
        [self.playGifImage stopAnimating];
    }
}
- (void)setTitleIndex:(NSInteger) index{
    self.titleL.text = [NSString stringWithFormat:@"我的配音%li",index+1];
}
- (void)setRecordTime:(NSString *) recordTime{
    self.timeL.text = recordTime;
}
- (void)setRecordScore:(NSString *) score{
    NSMutableAttributedString *attr = RLG_AttributedString(@"得分: ", 14);
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attr.length)];
    NSMutableAttributedString *scoreAttr = RLG_AttributedString(score, 18);
    if (score.floatValue >= 60) {
        [scoreAttr addAttribute:NSForegroundColorAttributeName value:RLG_Color(0x00CD00) range:NSMakeRange(0,scoreAttr.length)];
    }else{
        [scoreAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,scoreAttr.length)];
    }
    [attr appendAttributedString:scoreAttr];
    self.scoreL.attributedText = attr;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor darkGrayColor];
    }
    return _titleL;
}
- (UILabel *)scoreL{
    if (!_scoreL) {
        _scoreL = [UILabel new];
        _scoreL.textAlignment = NSTextAlignmentRight;
    }
    return _scoreL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [UILabel new];
        _timeL.textColor = [UIColor lightGrayColor];
        _timeL.font = [UIFont systemFontOfSize:13];
    }
    return _timeL;
}
- (UIImageView *)playImage{
    if (!_playImage) {
        _playImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_n")]];
    }
    return _playImage;
}
- (UIImageView *)playGifImage{
    if (!_playGifImage) {
        _playGifImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playGifImage.animationImages = RLG_VoiceGifs();
        _playGifImage.animationDuration = 1.0;
        _playGifImage.hidden  = YES;
    }
    return _playGifImage;
}
@end


@interface RLGVideoDubMainTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RLGAudioRecorder *player;
@property(nonatomic,strong) NSIndexPath *indexP;
@property(nonatomic,strong) NSMutableArray *recordArr;
@property(nonatomic,strong) UIView *stateView;
@end
@implementation RLGVideoDubMainTable
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self configure];
    }
    return self;
}
- (NSMutableArray *)recordArr{
    if (!_recordArr) {
        _recordArr = [NSMutableArray array];
    }
    return _recordArr;
}
- (RLGAudioRecorder *)player{
    if (!_player) {
        _player = [[RLGAudioRecorder alloc] init];
    }
    return _player;
}
- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [UIView new];
        _stateView.backgroundColor = [UIColor whiteColor];
        UILabel *stateLab = [UILabel new];
        stateLab.textColor = [UIColor lightGrayColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:15];
        stateLab.text = @"亲,未查询到配音...";
        [_stateView addSubview:stateLab];
        __weak typeof(self) weakSelf = self;
        [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.stateView);
        }];
    }
    return _stateView;
}
- (void)configure{
    self.backgroundColor = RLG_Color(0xF4F4F4);
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 80;
    [self registerClass:[RLGVideoRecordCell class] forCellReuseIdentifier:NSStringFromClass([RLGVideoRecordCell class])];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    self.player.PlayerFinishBlock = ^{
        RLGVideoRecordCell *cell = [weakSelf cellForRowAtIndexPath:weakSelf.indexP];
        cell.isPlay = NO;
    };
}
- (void)setStateViewShow:(BOOL) show{
    [self setShowOnBackgroundView:self.stateView show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self.superview addSubview:aView];
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.centerX.equalTo(self.superview);
            make.top.equalTo(self);
        }];
    }else {
        [aView removeFromSuperview];
    }
}
- (void)stopPlay{
    if (self.indexP) {
        RLGVideoRecordCell *cell = [self cellForRowAtIndexPath:self.indexP];
        cell.isPlay = NO;
    }
    [self.player stopPlay];
}
- (void)setResModel:(RLGResModel *)resModel{
    _resModel = resModel;
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.recordArr removeAllObjects];
    for (RLGResVideoModel *videoModel in contentModel.VideoTrainSynInfo) {
        if (!RLG_IsEmpty(videoModel.recordNames)) {
            [self.recordArr addObject:videoModel];
        }
    }
    if (self.recordArr.count > 0) {
        [self setStateViewShow:NO];
    }else{
        [self setStateViewShow:YES];
    }
    [self reloadData];
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
    RLGResVideoModel *videoModel = self.recordArr[indexPath.row];
    NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",videoModel.recordNames]];
    __weak typeof(self) weakSelf = self;
    [self.player stopPlay];
    [[RLGSpeechEngine shareInstance] removeRecordFileAtPath:fullpath complete:^(BOOL success) {
        if (success) {
            [weakSelf.recordArr removeObjectAtIndex:indexPath.row];
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordNamePath()];
            [plist removeObjectForKey:videoModel.OrgID];
            [plist writeToFile:RLG_SpeechRecordNamePath() atomically:false];
            
            NSMutableDictionary *plist1 = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
            [plist1 removeObjectForKey:videoModel.recordNames];
            [plist1 writeToFile:RLG_SpeechRecordInfoPath() atomically:false];
            videoModel.recordNames = @"";
            
            [weakSelf deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            if (weakSelf.recordArr.count == 0) {
                [weakSelf setStateViewShow:YES];
            }
        }else{
            [LGAlert showErrorWithStatus:@"删除录音文件失败"];
        }
    }];
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RLGVideoRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLGVideoRecordCell class]) forIndexPath:indexPath];
    RLGResVideoModel *videoModel = self.recordArr[indexPath.row];
    NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",videoModel.recordNames]];
    RLGSpeechModel *speechModel = [[RLGSpeechEngine shareInstance] parseVoiceFileAtPath:fullpath];
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
    RLGSpeechResultModel *markModel = [RLGSpeechResultModel speechResultWithDictionary:[plist objectForKey:videoModel.recordNames]];
    [cell setTitleIndex:indexPath.row];
    [cell setRecordTime:speechModel.createTime];
    [cell setRecordScore:[NSString stringWithFormat:@"%@",markModel.totalScore]];
    cell.isPlay = [self.player isPlayAtPath:speechModel.path];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RLGVideoRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RLGResVideoModel *videoModel = self.recordArr[indexPath.row];
    NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",videoModel.recordNames]];
    RLGSpeechModel *recordModel = [[RLGSpeechEngine shareInstance] parseVoiceFileAtPath:fullpath];
    if (self.indexP && ![cell isEqual:[tableView cellForRowAtIndexPath: self.indexP]]) {
        [self.player stopPlay];
        RLGVideoRecordCell *cell1 = [tableView cellForRowAtIndexPath: self.indexP];
        cell1.isPlay = NO;
    }
    if (cell.isPlay) {
        [self.player stopPlay];
    }else{
        [self.player playAtPath:recordModel.path];
    }
    cell.isPlay = !cell.isPlay;
    self.indexP = indexPath;
}
@end

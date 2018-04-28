//
//  RLGVoiceRecordTable.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceRecordTable.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>
#import "RLGSpeechEngine.h"
#import "RLGAudioRecorder.h"
#import <LGAlertUtil/LGAlertUtil.h>

@interface RLGVoiceRecordHeader: UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *scoreL;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (strong, nonatomic) UIImageView *playGifImage;
@property (nonatomic,copy) void (^playBlock) (void);
@property (nonatomic,assign) BOOL isPlay;
@end
@implementation RLGVoiceRecordHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.playGifImage];
    [self.playGifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.top.equalTo(self.voiceBtn);
        make.width.equalTo(self.playGifImage.mas_height);
    }];
    
    [self.contentView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.voiceBtn);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.voiceBtn.mas_top).offset(-5);
        make.height.mas_greaterThanOrEqualTo(30);
        
    }];
}
- (void)voiceAction{
    self.isPlay = YES;
    if (self.playBlock) {
        self.playBlock();
    }
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
- (void)setTitleAttr:(NSMutableAttributedString *) titleAttr{
     [titleAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18]range:NSMakeRange(0,titleAttr.length)];
    self.titleL.attributedText = titleAttr;
}
- (void)setRecordMaxScore:(NSString *) score{
    NSMutableAttributedString *attr = RLG_AttributedString(@"最高得分:", 14);
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attr.length)];
    NSMutableAttributedString *maxScoreAttr = RLG_AttributedString(score, 18);
    if (score.floatValue >= 60) {
        [maxScoreAttr addAttribute:NSForegroundColorAttributeName value:RLG_Color(0x00CD00) range:NSMakeRange(0,maxScoreAttr.length)];
    }else{
        [maxScoreAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,maxScoreAttr.length)];
    }
    [attr appendAttributedString:maxScoreAttr];
    NSMutableAttributedString *scoreAttr = RLG_AttributedString(@"&nbsp;&nbsp;总分:", 14);
    [scoreAttr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,scoreAttr.length)];
    [attr appendAttributedString:scoreAttr];
    NSMutableAttributedString *totalScoreAttr = RLG_AttributedString(@"100分", 14);
    [totalScoreAttr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,totalScoreAttr.length)];
    [attr appendAttributedString:totalScoreAttr];
    self.scoreL.attributedText = attr;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.numberOfLines = 0;
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
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _voiceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_voiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_n")] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"voice_h")] forState:UIControlStateHighlighted];
        [_voiceBtn setTitle:@" 原音" forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
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

#pragma mark -

@interface RLGVoiceRecordCell: UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *scoreL;
@property (nonatomic,strong) UILabel *timeL;
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIImageView *playGifImage;
@property (nonatomic,assign) BOOL isPlay;
@end
@implementation RLGVoiceRecordCell
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
    self.titleL.text = [NSString stringWithFormat:@"我的录音%li",index+1];
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

#pragma mark -

@interface RLGVoiceRecordTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RLGAudioRecorder *player;
@property(nonatomic,strong) NSIndexPath *indexP;
@end
@implementation RLGVoiceRecordTable
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self configure];
    }
    return self;
}
- (RLGAudioRecorder *)player{
    if (!_player) {
        _player = [[RLGAudioRecorder alloc] init];
    }
    return _player;
}
- (void)configure{
    self.backgroundColor = RLG_Color(0xF4F4F4);
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 80;
    self.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 80;
    self.sectionFooterHeight = 0.1;
    [self registerClass:[RLGVoiceRecordCell class] forCellReuseIdentifier:NSStringFromClass([RLGVoiceRecordCell class])];
    [self registerClass:[RLGVoiceRecordHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RLGVoiceRecordHeader class])];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    self.player.PlayerFinishBlock = ^{
        RLGVoiceRecordCell *cell = [weakSelf cellForRowAtIndexPath:weakSelf.indexP];
        cell.isPlay = NO;
    };
}
- (void)stopPlay{
    RLGVoiceRecordHeader *header = (RLGVoiceRecordHeader *)[self headerViewForSection:0];
    header.isPlay = NO;
    if (self.indexP) {
        RLGVoiceRecordCell *cell = [self cellForRowAtIndexPath:self.indexP];
        cell.isPlay = NO;
    }
    [self.player stopPlay];
}
- (void)stopHeaderPlay{
    RLGVoiceRecordHeader *header = (RLGVoiceRecordHeader *)[self headerViewForSection:0];
    header.isPlay = NO;
}
- (void)setVideoModel:(RLGResVideoModel *)videoModel{
    _videoModel = videoModel;
    if (!RLG_IsEmpty(videoModel.recordNameList)) {
        NSMutableArray *marks = [NSMutableArray array];
        NSMutableArray *records = [NSMutableArray array];
        for (NSString *name in videoModel.recordNameList) {
            NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",name]];
            [records addObject:[[RLGSpeechEngine shareInstance] parseVoiceFileAtPath:fullpath]];
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
            RLGSpeechResultModel *markModel = [RLGSpeechResultModel speechResultWithDictionary:[plist objectForKey:name]];
            if (markModel.totalScore.floatValue > _videoModel.maxScore.floatValue) {
                _videoModel.maxScore = [NSString stringWithFormat:@"%@",markModel.totalScore];
            }
            [marks addObject:markModel];
        }
        _videoModel.markModels = marks;
        _videoModel.recordModels = records;
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
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.videoModel.recordNameList];
    NSString *fullpath = [[RLGSpeechEngine shareInstance].recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",arr[indexPath.row]]];
    __weak typeof(self) weakSelf = self;
    [[RLGSpeechEngine shareInstance] removeRecordFileAtPath:fullpath complete:^(BOOL success) {
        if (success) {
            [arr removeObjectAtIndex:indexPath.row];
            weakSelf.videoModel.recordNames = [arr componentsJoinedByString:@","];
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordNamePath()];
            [plist setObject: weakSelf.videoModel.recordNames forKey: weakSelf.videoModel.SenID];
            [plist writeToFile:RLG_SpeechRecordNamePath() atomically:false];
            
            RLGSpeechResultModel *resultModel = self.videoModel.markModels[indexPath.row];
            NSMutableDictionary *plist1 = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordInfoPath()];
            [plist1 removeObjectForKey:resultModel.speechID];
            [plist1 writeToFile:RLG_SpeechRecordInfoPath() atomically:false];
            
            [weakSelf deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            if ([weakSelf.ownController respondsToSelector:@selector(speechRecordDidDelete)]) {
                [weakSelf.ownController speechRecordDidDelete];
            }
        }else{
            [LGAlert showErrorWithStatus:@"删除录音文件失败"];
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if (RLG_IsEmpty(self.videoModel.recordNameList)) {
            return 0;
        }else{
            return self.videoModel.recordNameList.count;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        RLGVoiceRecordHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RLGVoiceRecordHeader class])];
        [headerView setTitleAttr:self.videoModel.Etext_attr];
        [headerView setRecordMaxScore:self.videoModel.maxScore];
        __weak typeof(self) weakSelf = self;
        headerView.playBlock = ^{
            if (weakSelf.indexP) {
                RLGVoiceRecordCell *lastCell = [tableView cellForRowAtIndexPath:weakSelf.indexP];
                lastCell.isPlay = NO;
                [weakSelf.player stopPlay];
            }
            if ([weakSelf.ownController respondsToSelector:@selector(playToIndex:)]) {
                [weakSelf.ownController playToIndex:weakSelf.tag];
            }
            
        };
        return headerView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RLGVoiceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLGVoiceRecordCell class]) forIndexPath:indexPath];
    [cell setTitleIndex:indexPath.row];
    if (!RLG_IsEmpty(self.videoModel.markModels)) {
        RLGSpeechResultModel *resultModel = self.videoModel.markModels[indexPath.row];
        RLGSpeechModel *recordModel = self.videoModel.recordModels[indexPath.row];
        [cell setRecordTime:recordModel.createTime];
        [cell setRecordScore:[NSString stringWithFormat:@"%@",resultModel.totalScore]];
        cell.isPlay = [self.player isPlayAtPath:recordModel.path];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self stopHeaderPlay];
    if ([self.ownController respondsToSelector:@selector(speechDidFinish)]) {
        [self.ownController speechDidFinish];
    }
    RLGVoiceRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      RLGSpeechModel *recordModel = self.videoModel.recordModels[indexPath.row];
    if (self.indexP && ![cell isEqual:[tableView cellForRowAtIndexPath: self.indexP]]) {
        [self.player stopPlay];
        RLGVoiceRecordCell *cell1 = [tableView cellForRowAtIndexPath: self.indexP];
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

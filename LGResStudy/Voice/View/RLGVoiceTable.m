//
//  RLGVoiceTable.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceTable.h"
#import "RLGResModel.h"
#import "RLGVoiceTableCell.h"
#import "RLGVoiceTableHeader.h"
#import "RLGSpeechTipView.h"
#import "RLGCommon.h"

@interface RLGVoiceTable ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) NSIndexPath *refIndexPath;
@property (nonatomic,strong) RLGSpeechTipView *speechTipView;
@end
@implementation RLGVoiceTable
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 80;
    self.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 50;
    self.sectionFooterHeight = 0.1;
    
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[RLGVoiceTableCell class] forCellReuseIdentifier:NSStringFromClass([RLGVoiceTableCell class])];
    [self registerClass:[RLGVoiceTableHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RLGVoiceTableHeader class])];
    
    self.refIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)setResModel:(RLGResModel *)resModel{
    _resModel = resModel;
    [self reloadData];
}
- (void)setCurrentPlayIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    RLGVoiceTableCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (self.refIndexPath && ![cell isEqual:[self cellForRowAtIndexPath: self.refIndexPath]]) {
        RLGVoiceTableCell *cell1 = [self cellForRowAtIndexPath:self.refIndexPath];
        cell1.isChoice = NO;
    }
    cell.isChoice = YES;
    self.refIndexPath = indexPath;
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}
- (void)resetSetup{
    [self setCurrentPlayIndex:0];
}
- (void)showSpeechMarkAtIndex:(NSInteger) index{
    if (self.speechTipView) {
        [self.speechTipView removeFromSuperview];
        self.speechTipView = nil;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    RLGVoiceTableCell *cell = [self cellForRowAtIndexPath:indexPath];
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[index];
    RLGSpeechTipView *tipView = [[RLGSpeechTipView alloc] initWithFrame:CGRectMake((RLG_ScreenWidth()-160)/2, cell.frame.origin.y-cell.frame.size.height/2, 160, 40) refText:videoModel.Etext recordTime:videoModel.Timelength.floatValue / 1000 + 2];
    [self addSubview:tipView];
    self.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    tipView.speechFinishBlock = ^(NSString *recordID) {
        
        if (!RLG_IsEmpty(recordID)) {
            RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
            RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[indexPath.row];
            if (videoModel.recordNames.length != 0) {
                videoModel.recordNames = [videoModel.recordNames stringByAppendingString:@","];
            }
            videoModel.recordNames = [videoModel.recordNames stringByAppendingString:recordID];
            
            NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:RLG_SpeechRecordNamePath()];
            [plist setObject:videoModel.recordNames forKey:videoModel.SenID];
            [plist writeToFile:RLG_SpeechRecordNamePath() atomically:false];
        }
        if ([weakSelf.ownController respondsToSelector:@selector(speechDidFinish)]) {
            [weakSelf.ownController speechDidFinish];
        }
        [weakSelf hideSpeechTipView];
    };
    self.speechTipView = tipView;
}
- (void)hideSpeechTipView{
    self.userInteractionEnabled = YES;
    if (self.speechTipView) {
        [self.speechTipView removeFromSuperview];
        self.speechTipView = nil;
    }
}
- (void)touchCellIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    RLGVoiceTableCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (![cell isEqual:[self cellForRowAtIndexPath: self.refIndexPath]]) {
        RLGVoiceTableCell *cell1 = [self cellForRowAtIndexPath:self.refIndexPath];
        cell1.isChoice = NO;
        if ([self.ownController respondsToSelector:@selector(playToIndex:)]) {
            [self.ownController playToIndex:indexPath.row];
        }
    }
    
    cell.isChoice = YES;
    self.refIndexPath = indexPath;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideSpeechTipView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    return contentModel.VideoTrainSynInfo.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RLGVoiceTableHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RLGVoiceTableHeader class])];
    headerView.titleStr = self.resModel.ResName;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RLGVoiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLGVoiceTableCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    RLGResVideoModel *videoModel = contentModel.VideoTrainSynInfo[indexPath.row];
     [cell setTextAttribute:videoModel.Etext_attr withImporKnTexts:self.resModel.rlgImporKnTexts];
    cell.ownController = self.ownController;
    if (self.refIndexPath.row == indexPath.row) {
        cell.isChoice = YES;
    }else{
        cell.isChoice = NO;
    }
    cell.index = indexPath.row;
    return cell;
}

@end

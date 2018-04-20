//
//  DLGResultTable.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultTable.h"
#import "DLGCommon.h"
#import "DLGResultTableParseProtocol.h"
#import "DLGResultVoiceCell.h"
#import "DLGResultTextCell.h"
#import "DLGResultTableHeader.h"
#import "DLGResultTablePresenter.h"
#import "DLGWordModel.h"
#import "DLGWordCategoryModel.h"

@interface DLGResultTable ()<UITableViewDelegate,UITableViewDataSource,DLGResultTableParseProtocol>
@property (nonatomic,strong) DLGResultTablePresenter *presenter;
@property (nonatomic,strong) NSArray *dataArr;
@end
@implementation DLGResultTable
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedRowHeight = 80;
        self.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.estimatedSectionHeaderHeight = 100;
        self.sectionFooterHeight = 10;
        
        [self registerClass:[DLGResultTextCell class] forCellReuseIdentifier:NSStringFromClass([DLGResultTextCell class])];
        [self registerClass:[DLGResultVoiceCell class] forCellReuseIdentifier:NSStringFromClass([DLGResultVoiceCell class])];
        [self registerClass:[DLGResultTableCategoryHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([DLGResultTableCategoryHeader class])];
        [self registerClass:[DLGResultTableMainHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([DLGResultTableMainHeader class])];
        self.presenter = [[DLGResultTablePresenter alloc] initWithView:self];
    }
    return self;
}
- (void)setWordModel:(DLGWordModel *)wordModel{
    _wordModel = wordModel;
    [self.presenter startParseWithWordModel:wordModel];
}
- (void)expandOrFoldEnable{
    NSInteger expandCount = 0;
    NSInteger foldCount = 0;
    for (DLGWordCategoryModel *model in self.dataArr) {
        if (model.categoryType != DLGWordCategoryTypeWord) {
            if (model.expand) {
                expandCount++;
            }else{
                foldCount++;
            }
        }
    }
    DLGWordCategoryModel *categoryModel = [self.dataArr firstObject];
    if (foldCount == 0) {
        categoryModel.expandEnable = NO;
    }else{
        categoryModel.expandEnable = YES;
    }
    if (expandCount == 0) {
        categoryModel.foldEnable = NO;
    }else{
        categoryModel.foldEnable = YES;
    }
}
#pragma mark protocol
- (void)parseDidFinishWithResult:(NSArray *)result{
    self.dataArr = result;
    [self reloadData];
}
- (void)expandOrFoldAtIndex:(NSInteger)index{
    DLGWordCategoryModel *categoryModel = self.dataArr[index];
    categoryModel.expand = !categoryModel.expand;
    [self expandOrFoldEnable];
    [self reloadData];
}
- (void)allExpand:(BOOL)expand{
    for (DLGWordCategoryModel *model in self.dataArr) {
        model.expandEnable = !expand;
        model.foldEnable = expand;
        model.expand = expand;
    }
    [self reloadData];
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLGWordCategoryModel *categoryModel = self.dataArr[section];
    if (categoryModel.categoryType == DLGWordCategoryTypeWord) {
        return 0;
    }else{
        if (categoryModel.expand) {
            return categoryModel.categoryList.count;
        }else{
            return 0;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     DLGWordCategoryModel *categoryModel = self.dataArr[section];
    if (categoryModel.categoryType == DLGWordCategoryTypeWord) {
        DLGResultTableMainHeader *mainHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([DLGResultTableMainHeader class])];
        mainHeader.view = self;
        mainHeader.categoryModel = categoryModel;
        return mainHeader;
    }else{
        DLGResultTableCategoryHeader *categoryHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([DLGResultTableCategoryHeader class])];
        categoryHeader.view = self;
        categoryHeader.index = section;
        [categoryHeader setCategoryTitle:categoryModel.categoryTitle];
        [categoryHeader setCategoryExpand:categoryModel.expand];
        return categoryHeader;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLGWordCategoryModel *categoryModel = self.dataArr[indexPath.section];
    if (categoryModel.categoryType == DLGWordCategoryTypeWord) {
        return nil;
    }else{
        if (categoryModel.categoryType == DLGWordCategoryTypeSen) {
            DLGResultVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLGResultVoiceCell class]) forIndexPath:indexPath];
            [voiceCell setTextModel:categoryModel adIndexPath:indexPath];
            return voiceCell;
        }else if (categoryModel.categoryType == DLGWordCategoryTypeEnglish){
             DLGResultTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLGResultTextCell class]) forIndexPath:indexPath];
            MeanCollectionModel *meanModel = categoryModel.categoryList[indexPath.row];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:meanModel.chineseMeaning_attr];
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            [att appendAttributedString:meanModel.englishMeaning_attr];
            [textCell setText:att];
            return textCell;
        }else{
            DLGResultTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLGResultTextCell class]) forIndexPath:indexPath];
            [textCell setTextModel:categoryModel adIndexPath:indexPath];
            return textCell;
        }
    }
}
@end

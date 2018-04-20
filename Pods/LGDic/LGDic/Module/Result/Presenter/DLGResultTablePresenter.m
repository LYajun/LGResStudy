//
//  DLGResultTablePresenter.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultTablePresenter.h"
#import "DLGWordModel.h"
#import "DLGWordCategoryModel.h"
#import "DLGCommon.h"
#import "DLGResultTableParseProtocol.h"

@interface DLGResultTablePresenter ()

@end
@implementation DLGResultTablePresenter
- (instancetype)initWithView:(id)view{
    if (self = [super initWithView:view]) {
        
    }
    return self;
}
- (void)startParseWithWordModel:(DLGWordModel *)wordModel{
    NSMutableArray *coltArr = [NSMutableArray array];
    NSMutableArray *rltArr = [NSMutableArray array];
    NSMutableArray *senArr = [NSMutableArray array];
    NSMutableArray *classicArr = [NSMutableArray array];
    NSMutableArray *meanArr = [NSMutableArray array];
    for (CxCollectionModel *cxModel in wordModel.cxCollection) {
        [meanArr addObjectsFromArray:cxModel.meanCollection];
        for (MeanCollectionModel *meanModel in cxModel.meanCollection) {
            if (!DLG_IsEmpty(meanModel.senCollection)) {
                [senArr addObjectsFromArray:meanModel.senCollection];
            }
            if (!DLG_IsEmpty(meanModel.coltCollection)) {
                for (ColtCollectionModel *coltModel in meanModel.coltCollection) {
                    if (!DLG_IsEmpty(coltModel.senCollection)) {
                        [coltArr addObjectsFromArray:coltModel.senCollection];
                    }
                }
            }
            if (!DLG_IsEmpty(meanModel.classicCollection)) {
                [classicArr addObjectsFromArray:meanModel.classicCollection];
            }
            if (!DLG_IsEmpty(meanModel.rltCollection)) {
                [rltArr addObjectsFromArray:meanModel.rltCollection];
            }
        }
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObject:[self categoryModelWithType:DLGWordCategoryTypeWord list:@[wordModel]]];
    if (senArr.count > 0) {
        [dataArr addObject:[self categoryModelWithType:DLGWordCategoryTypeSen list:senArr]];
    }
    if (coltArr.count > 0) {
        [dataArr addObject:[self categoryModelWithType:DLGWordCategoryTypeColt list:coltArr]];
    }
    if (classicArr.count > 0) {
        [dataArr addObject:[self categoryModelWithType:DLGWordCategoryTypeClassic list:classicArr]];
    }
    if (rltArr.count > 0) {
        [dataArr addObject:[self categoryModelWithType:DDLGWordCategoryTypeRlt list:rltArr]];
    }
    [dataArr addObject:[self categoryModelWithType:DLGWordCategoryTypeEnglish list:meanArr]];
    
    if ([self.view respondsToSelector:@selector(parseDidFinishWithResult:)]) {
        [self.view parseDidFinishWithResult:dataArr];
    }
}
- (DLGWordCategoryModel *)categoryModelWithType:(DLGWordCategoryType) type list:(NSArray *) list{
    DLGWordCategoryModel *model = [[DLGWordCategoryModel alloc] init];
    model.categoryType = type;
    model.categoryList = list;
    model.expand = YES;
    if (type == DLGWordCategoryTypeWord) {
        model.foldEnable = YES;
    }
    return model;
}
@end

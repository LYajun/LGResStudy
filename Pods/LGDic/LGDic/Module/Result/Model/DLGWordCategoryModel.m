//
//  DLGWordCategoryModel.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGWordCategoryModel.h"

@implementation DLGWordCategoryModel
- (NSString *)categoryTitle{
    switch (self.categoryType) {
        case DLGWordCategoryTypeSen:
            return @"  例句详解";
            break;
        case DLGWordCategoryTypeColt:
            return @"  常用搭配";
            break;
        case DLGWordCategoryTypeClassic:
            return @"  经典应用";
            break;
        case DDLGWordCategoryTypeRlt:
            return @"  相关词汇";
            break;
        case DLGWordCategoryTypeEnglish:
            return @"  英英释义";
            break;
        default:
            return @"";
            break;
    }
}
@end

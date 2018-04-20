//
//  DLGWordCategoryModel.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,DLGWordCategoryType){
    DLGWordCategoryTypeWord,
    DLGWordCategoryTypeSen,
    DLGWordCategoryTypeColt,
    DLGWordCategoryTypeClassic,
    DDLGWordCategoryTypeRlt,
    DLGWordCategoryTypeEnglish
};
@interface DLGWordCategoryModel : NSObject
/** 分类类型 */
@property (nonatomic,assign) DLGWordCategoryType categoryType;
/** 分类列表 */
@property (nonatomic,strong) NSArray *categoryList;
/** 是否展开 */
@property (nonatomic,assign) BOOL expand;

/** 展开使能 */
@property (nonatomic,assign) BOOL expandEnable;
/** 折叠使能 */
@property (nonatomic,assign) BOOL foldEnable;
- (NSString *)categoryTitle;
@end

//
//  DLGResultTablePresenter.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGBasePresenter.h"

@class DLGWordModel;
@class DLGWordCategoryModel;
@interface DLGResultTablePresenter : DLGBasePresenter
- (void)startParseWithWordModel:(DLGWordModel *) wordModel;
@end

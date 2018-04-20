//
//  DLGResultTableHeader.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLGResultTableParseProtocol.h"

@class DLGWordCategoryModel;
@interface DLGResultTableCategoryHeader : UITableViewHeaderFooterView
@property (nonatomic,assign) id<DLGResultTableParseProtocol> view;
@property (nonatomic,assign) NSInteger index;
- (void)setCategoryTitle:(NSString *) title;
- (void)setCategoryExpand:(BOOL) expand;
@end


@interface DLGResultTableMainHeader : UITableViewHeaderFooterView
@property (nonatomic,assign) id<DLGResultTableParseProtocol> view;
@property (nonatomic,strong) DLGWordCategoryModel *categoryModel;
@end

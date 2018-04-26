//
//  RLGWordHeaderView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLGWordModel;
@interface RLGWordHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) RLGWordModel *wordModel;
@property (nonatomic,copy) void (^PlayBlock) (void);
- (void)stop;
@end

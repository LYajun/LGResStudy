//
//  RLGVideoDubMainTable.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLGResModel;
@interface RLGVideoDubMainTable : UITableView
@property (nonatomic,strong) RLGResModel *resModel;
- (void)stopPlay;
@end

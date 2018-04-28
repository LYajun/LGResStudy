//
//  RLGVoiceRecordTable.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLGResModel.h"
#import "RLGViewTransferProtocol.h"
@interface RLGVoiceRecordTable : UITableView
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
@property (nonatomic,strong) RLGResVideoModel *videoModel;

- (void)stopPlay;
- (void)stopHeaderPlay;
@end

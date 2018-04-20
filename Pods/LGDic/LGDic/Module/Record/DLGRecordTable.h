//
//  DLGRecordTable.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLGViewTransferProtocol.h"
@interface DLGRecordTable : UITableView
@property (nonatomic,weak) UIViewController<DLGViewTransferProtocol> *ownController;
@end

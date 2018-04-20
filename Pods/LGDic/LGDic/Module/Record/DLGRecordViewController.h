//
//  DLGRecordViewController.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLGViewTransferProtocol.h"

@interface DLGRecordViewController : UIViewController
@property (nonatomic,assign) id<DLGViewTransferProtocol> transferView;
@end

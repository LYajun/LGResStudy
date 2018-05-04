//
//  RLGVideoViewController.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLGViewTransferProtocol.h"
@interface RLGVideoViewController : UIViewController<RLGViewTransferProtocol>
@property (nonatomic,weak) UIViewController *ownController;

@end

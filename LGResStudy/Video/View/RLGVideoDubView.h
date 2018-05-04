//
//  RLGVideoDubView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLGResModel.h"

@interface RLGVideoDubView : UIView
@property (nonatomic,strong) RLGResVideoModel *videoModel;
@property (nonatomic,copy) void (^originBlock) (void);
@property (nonatomic,copy) void (^dubBlock) (void);
@property (nonatomic,copy) void (^dubResultBlock) (void);
- (void)playDub;
@end

//
//  RLGVoiceRecordViewController.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGBaseViewController.h"
#import "RLGViewTransferProtocol.h"
@class RLGResModel;
@interface RLGVoiceRecordViewController : RLGBaseViewController<RLGViewTransferProtocol>
- (instancetype)initWithResModel:(RLGResModel *) resModel;
@property (nonatomic,copy) void (^DeleteRecordBlock) (void);
@end

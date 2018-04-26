//
//  RLGVoiceTable.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTapTableView.h"
#import "RLGViewTransferProtocol.h"
@class RLGResModel;
@interface RLGVoiceTable : RLGTapTableView

@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
- (void)setCurrentPlayIndex:(NSInteger) index;
- (void)showSpeechMarkAtIndex:(NSInteger) index;
- (void)resetSetup;
@end

//
//  RLGVoiceTableCell.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLGViewTransferProtocol.h"
@interface RLGVoiceTableCell : UITableViewCell
/** 是否选择 */
@property (nonatomic,assign) BOOL isChoice;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
- (void)setTextAttribute:(NSMutableAttributedString *) textAttribute withImporKnTexts:(NSArray *) imporKnTexts;

@end

//
//  RLGTextView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLGViewTransferProtocol.h"
@interface RLGTextView : UITextView
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
- (void)setTextAttribute:(NSMutableAttributedString *) textAttribute withImporKnTexts:(NSArray *) imporKnTexts;
@end

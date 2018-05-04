//
//  RLGImportantTextViewController.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGBaseViewController.h"
#import "RLGViewTransferProtocol.h"
@interface RLGImportantTextViewController : RLGBaseViewController
@property (nonatomic,weak) UIViewController<RLGViewTransferProtocol> *ownController;
- (instancetype)initWithImportantTexts:(NSArray *) importantTexts;
@end

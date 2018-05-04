//
//  RLGVideoSubtitleViewController.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGBaseViewController.h"

@interface RLGVideoSubtitleViewController : RLGBaseViewController
- (instancetype)initWithVideoModels:(NSArray *) videoModels;
@property (nonatomic,weak) UIViewController *ownController;
@end

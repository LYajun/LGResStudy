//
//  RLGResStudyPresenter.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGHttpPresenter.h"

@interface RLGResStudyPresenter : RLGHttpPresenter
- (void)startRequest;
- (void)studyModelChangeAtIndex:(NSInteger) index resType:(NSInteger) resType;
@end

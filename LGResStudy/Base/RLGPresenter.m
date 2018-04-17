//
//  LGPresenter.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGPresenter.h"

@implementation RLGPresenter
- (instancetype)initWithView:(id)view{
    if (self = [super init]) {
        [self bindView:view];
    }
    return self;
}
- (void)bindView:(id)view{
    self.view = view;
}
- (void)unbindView{
    self.view = nil;
}
@end

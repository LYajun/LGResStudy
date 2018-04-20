//
//  RLGTouchView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/20.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTouchView.h"
#import <Masonry/Masonry.h>

@interface RLGTouchView ()

@end
@implementation RLGTouchView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [touchBtn setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:touchBtn];
        [touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
@end

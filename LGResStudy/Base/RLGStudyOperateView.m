//
//  RLGStudyOperateView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGStudyOperateView.h"
#import "RLGCommon.h"
#import <Masonry/Masonry.h>

@implementation RLGStudyOperateView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgImage.image = [UIImage imageWithContentsOfFile:RLG_GETBundleResource(@"lg_bottombg")];
        [self addSubview:bgImage];
        [bgImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end

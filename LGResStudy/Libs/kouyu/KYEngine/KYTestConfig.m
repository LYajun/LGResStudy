//
//  KYTestConfig.m
//  KouyuDemo
//
//  Created by Attu on 2017/8/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "KYTestConfig.h"

@implementation KYTestConfig

//初始化默认参数
- (instancetype)init {
    self = [super init];
    if (self) {
        self.userId = @"user-id";
        self.channel = 1;

        self.phoneme_output = YES;
    }
    return self;
}

@end

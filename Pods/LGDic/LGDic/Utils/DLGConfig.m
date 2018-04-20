//
//  DLGConfig.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGConfig.h"

@implementation DLGConfig
+ (DLGConfig *)shareInstance{
    static DLGConfig * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[DLGConfig alloc]init];
    });
    return macro;
}
@end

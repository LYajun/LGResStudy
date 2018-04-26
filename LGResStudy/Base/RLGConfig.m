//
//  RLGConfig.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGConfig.h"
#import "RLGSpeechEngine.h"

@implementation RLGConfig
+ (RLGConfig *)shareInstance{
    static RLGConfig * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[RLGConfig alloc]init];
    });
    return macro;
}
- (NSDictionary *)configParams{
    return @{
             @"UserID":(_UserID ? _UserID:@""),
             @"Token":(_Token ? _Token:@""),
             @"GUID":(_GUID ? _GUID:@""),
             @"Source":(_Source ? _Source:@""),
             @"PlanID":@""
             };
}
- (void)initSpeechEngine{
    [[RLGSpeechEngine shareInstance] initEngine];
}
@end

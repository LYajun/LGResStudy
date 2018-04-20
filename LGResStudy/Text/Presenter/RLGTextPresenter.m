//
//  RLGTextPresenter.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/18.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTextPresenter.h"
#import <LGAlertUtil/LGAlertUtil.h>
#import "RLGCommon.h"
#import "RLGViewTransferProtocol.h"

@implementation RLGTextPresenter
- (void)startRequestWithWord:(NSString *)word{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:LGResConfig().parameters];
    [dic setValue:word forKey:LGResConfig().wordKey];
    [LGAlert showIndeterminateWithStatus:@"匹配中..."];
    if (LGResConfig().postEnable) {
        [self.httpClient post:LGResConfig().wordUrl parameters:dic];
    }else{
        [self.httpClient get:LGResConfig().wordUrl parameters:dic];
    }
}
- (void)success:(id)responseObject{
    [LGAlert hide];
    if ([self.view respondsToSelector:@selector(updateWordModel:)]) {
        [self.view updateWordModel:responseObject];
    }
}
- (void)failure:(NSError *)error{
    [LGAlert showErrorWithStatus:@"查询知识点为空"];
}
@end

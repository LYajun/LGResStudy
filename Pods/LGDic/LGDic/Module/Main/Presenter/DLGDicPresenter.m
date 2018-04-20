//
//  DLGDicPresenter.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGDicPresenter.h"
#import "DLGCommon.h"
#import "DLGAlert.h"
#import "DLGViewTransferProtocol.h"

@implementation DLGDicPresenter
- (void)startRequestWithWord:(NSString *)word{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:LGDicConfig().parameters];
    [dic setValue:word forKey:LGDicConfig().wordKey];
    [[DLGAlert shareInstance] showIndeterminateWithStatus:@"匹配中..."];
    if (LGDicConfig().postEnable) {
        [self.httpClient post:LGDicConfig().wordUrl parameters:dic];
    }else{
        [self.httpClient get:LGDicConfig().wordUrl parameters:dic];
    }
}
- (void)success:(id)responseObject{
    [[DLGAlert shareInstance] hide];
    if ([self.view respondsToSelector:@selector(updateData:)]) {
        [self.view updateData:responseObject];
    }
}
- (void)failure:(NSError *)error{
    [[DLGAlert shareInstance] showErrorWithStatus:error.localizedDescription];
}
@end

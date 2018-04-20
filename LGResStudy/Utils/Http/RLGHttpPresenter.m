//
//  DLGHttpPresenter.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGHttpPresenter.h"
#import "RLGHttpResponseProtocol.h"


@interface RLGHttpPresenter ()<RLGHttpResponseProtocol>

@end
@implementation RLGHttpPresenter
- (instancetype)initWithView:(id)view{
    if (self = [super initWithView:view]) {
        self.httpClient = [[RLGHttpClient alloc] initWithResponder:self];
    }
    return self;
}

- (void)success:(id)responseObject{
    
}
- (void)failure:(NSError *)error{
    
}
@end

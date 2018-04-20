//
//  DLGHttpPresenter.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGHttpPresenter.h"

@interface DLGHttpPresenter ()

@end
@implementation DLGHttpPresenter
- (instancetype)initWithView:(id)view{
    if (self = [super initWithView:view]) {
        self.httpClient = [[DLGHttpClient alloc] initWithResponder:self];
    }
    return self;
}

- (void)success:(id)responseObject{
    
}
- (void)failure:(NSError *)error{
    
}
@end

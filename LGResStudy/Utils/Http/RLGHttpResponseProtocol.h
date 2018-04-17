//
//  DLGHttpResponseProtocol.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RLGHttpResponseProtocol <NSObject>
- (void)success:(id) responseObject;
- (void)failure:(NSError *) error;
@end

//
//  DLGHttpClient.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RLGHttpResponseProtocol;

@interface RLGHttpClient : NSObject
- (instancetype)initWithResponder:(id<RLGHttpResponseProtocol>) responder;
- (void)get:(NSString *) urlStr parameters:(NSDictionary *) parameters;
- (void)post:(NSString *) urlStr parameters:(NSDictionary *) parameters;
@end

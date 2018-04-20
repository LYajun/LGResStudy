//
//  DLGHttpClient.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGHttpResponseProtocol;

@interface DLGHttpClient : NSObject
- (instancetype)initWithResponder:(id<DLGHttpResponseProtocol>) responder;
- (void)get:(NSString *) urlStr parameters:(NSDictionary *) parameters;
- (void)post:(NSString *) urlStr parameters:(NSDictionary *) parameters;
@end

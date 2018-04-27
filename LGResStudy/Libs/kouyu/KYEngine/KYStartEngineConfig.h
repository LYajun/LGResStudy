//
//  KYStartEngineConfig.h
//  KouyuDemo
//
//  初始化引擎时配置的参数
//
//  Created by Attu on 2017/8/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KYStartEngineConfig : NSObject

/****************  公用参数  *****************/
@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *secretKey;

// 必须，开发证书文件路径(包含文件名)
@property (nonatomic, copy) NSString *provison;

// 可选，是否启用 VAD，默认 1 启用，0 为关闭
@property (nonatomic, assign) BOOL vadEnable;

// vad 技术 可选，发音结束判断间隔，单位 10ms,默认 60，即 600ms
@property (nonatomic, assign) CGFloat seek;

/******************************************/




/****************  云端引擎参数  *****************/

// 必选, 默认1
@property (nonatomic, assign) BOOL enable;

// 可选(若不填写 sdk 会使用默认地址 ws://api.17kouyu.com:8080), 灰度地址:ws://gray.17kouyu.com:8090
@property (nonatomic, copy) NSString *server;

// 可选，获取 serverList 的地址
@property (nonatomic, copy) NSString *serverList;

// 可选, 默认是 10s, 建立连接的超时时间
@property (nonatomic, assign) CGFloat connectTimeout;

// 可选, 默认是 60s, 响应的超时时间
@property (nonatomic, assign) CGFloat serverTimeout;

/******************************************/




/****************  离线引擎参数  *****************/

//必须，创建本地引擎，参数为本地资源路径
@property (nonatomic, copy) NSString *native;

//可选，使用 AiLocal 服务时，必须传入 AiLocal 服务的地址
@property (nonatomic, copy) NSString *ailocalAddress;

/******************************************/

@end

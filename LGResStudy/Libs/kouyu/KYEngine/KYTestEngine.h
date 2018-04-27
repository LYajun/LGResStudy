//
//  KYTestEngine.h
//  KouyuDemo
//
//  引擎类（用于构建引擎、开启评测等功能）
//
//  Created by Attu on 2017/8/15.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYStartEngineConfig.h"
#import "KYTestConfig.h"

typedef enum : NSUInteger {
    KY_CloudEngine,       //云端引擎
    KY_NativeEngine,      //离线引擎
} KYEngineType;

typedef void(^KYTestResultBlock)(NSString *testResult);

@interface KYTestEngine : NSObject

+ (instancetype)sharedInstance;

/**
 初始化引擎

 @param engineType 引擎类型
 @param startEngineConfig 初始化引擎配置参数
 @param finishBlock 初始化是否成功回调
 */
- (void)initEngine:(KYEngineType)engineType startEngineConfig:(KYStartEngineConfig *)startEngineConfig finishBlock:(void(^)(BOOL isSuccess))finishBlock;

/**
 启动引擎开始评测 
 
 @param testConfig  评测配置参数
 @param testResultBlock 评测成功回调
 */
- (void)startEngineWithTestConfig:(KYTestConfig *)testConfig result:(KYTestResultBlock)testResultBlock;

/**
 关闭引擎（有回调）
 */
- (void)stopEngine;

/**
 取消评测（无回调）
 */
- (void)cancelEngine;

/**
 销毁引擎
 */
- (void)deleteEngine;

/**
 回放
 */
- (void)playback;

@end

//
//  RLGConfig.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLGConfig : NSObject
/** 用户ID */
@property (nonatomic,copy) NSString *UserID;
/** 用户令牌 */
@property (nonatomic,copy) NSString *Token;
/** 资料ID */
@property (nonatomic,copy) NSString *GUID;
/** 资料来源 */
@property (nonatomic,copy) NSString *Source;
/** 资源网络地址 */
@property (nonatomic,copy) NSString *resUrl;

/** 词典地址 */
@property (nonatomic,copy) NSString *wordUrl;
/** 请求参数 */
@property (nonatomic,strong) NSDictionary *parameters;
/** 指定请求参数中键值对value为所查询的单词的key */
@property (nonatomic,copy) NSString *wordKey;

/** 是否POST请求 */
@property (nonatomic,assign) BOOL postEnable;


/** 对于音频地址缺失域名时的设置 */
/** 音频地址(Http://IP:Port) */
@property (nonatomic,copy) NSString *voiceUrl;
/** 音频地址是否需要拼接域名 */
@property (nonatomic,assign) BOOL appendDomain;

/** 笔记工具入口 */
@property (nonatomic,copy) void (^NoteEntryBlock) (void);

/** 初始化语音评测 */
- (void)initSpeechEngine;
+ (RLGConfig *)shareInstance;
- (NSDictionary *)configParams;
@end

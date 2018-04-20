//
//  DLGConfig.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGConfig : NSObject
/** 用户ID */
@property (nonatomic,copy) NSString *userID;
/** 词典地址 */
@property (nonatomic,copy) NSString *wordUrl;
/** 直接查询的单词 */
@property (nonatomic,copy) NSString *word;
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

/** 单词查询回调 */
@property (nonatomic,copy) void (^QueryBlock) (NSString *word);
+ (DLGConfig *)shareInstance;
@end

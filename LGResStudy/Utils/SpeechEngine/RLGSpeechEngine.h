//
//  RLGSpeechEngine.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/24.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,RLGSpeechEngineErrorType){
    // 初始化中
    RLGSpeechEngineErrorTypeIniting = 1000,
    // 评测启动失败
    RLGSpeechEngineErrorTypeEngineStartError,
    // 录音启动失败
    RLGSpeechEngineErrorTypeRecordStartError,
    // 录音授权失败
    RLGSpeechEngineErrorTypeRecordAuthError
};
typedef NS_ENUM(NSInteger,RLGSpeechEngineMarkType) {
    // 单词
    RLGSpeechEngineMarkTypeWord,
    // 句子
    RLGSpeechEngineMarkTypeSen
};
@interface RLGSpeechModel : NSObject

/** 时长 */
@property (nonatomic,assign) NSInteger duration;
/** 路径 */
@property (nonatomic,copy) NSString *path;
/** 创建时间 */
@property (nonatomic,copy) NSString *createTime;
/** 文件类型 */
@property (nonatomic,copy) NSString *fileType;
/** 音质类型 */
@property (nonatomic,copy) NSString *voiceType;
/** 文件大小 */
@property (nonatomic,copy) NSString *fileSize;

@end

@interface RLGSpeechResultModel : NSObject
/** 编号 */
@property (nonatomic,copy) NSString *speechID;
/** 总分 */
@property (nonatomic,copy) NSString *totalScore;
/** 发音得分 */
@property (nonatomic,copy) NSString *pronunciationScore;

/** 音素得分 - 单词*/
@property (nonatomic,copy) NSString *phonemeScore;

/** 完整度得分 - 句子*/
@property (nonatomic,copy) NSString *integrityScore;
/** 流利度得分 - 句子 */
@property (nonatomic,copy) NSString *fluencyScore;
/** 单词得分 - 句子*/
@property (nonatomic,copy) NSString *wordScore;

/** 是否出错 */
@property (nonatomic,assign) BOOL isError;
/** 错误信息 */
@property (nonatomic,copy) NSString *errorMsg;
+ (instancetype)speechResultWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)rlg_JSONObject;
@end

@interface RLGSpeechEngine : NSObject
+ (instancetype)shareInstance;
/** 开始评测 */
- (void)startEngineAtRefText:(NSString *)refText markType:(RLGSpeechEngineMarkType) markType;
/** 初始化引擎 */
- (void)initEngine;
/** 停止引擎 */
- (void)stopEngine;
/** 删除引擎 */
- (void)deleteEngine;
/** 销毁引擎 */
- (void)invalidateEngine;
/** 录音时间 */
- (void)recordTime:(void (^) (NSInteger recordTime)) timeBlock;
/** 录音回放 */
- (void)playback;
- (BOOL)isInitConfig;
/** 初始化结果 */
- (void)initResult:(void (^) (BOOL success)) resultBlock;
/** 停止评测 */
- (void)stopEngine:(void (^) (void)) stopBlock;
/** 评测结果 */
- (void)speechEngineResult:(void (^) (RLGSpeechResultModel *resultModel)) resultBlock;
/** 根据录音文件路径删除录音文件 */
- (void)removeRecordFileAtPath:(NSString *) path complete:(void (^) (BOOL success)) complete;
/** 解析录音文件信息 */
-(RLGSpeechModel *)parseVoiceFileAtPath:(NSString *) filePath;
/** 全部录音文件路径 */
- (NSArray *)recordFiles;
/** 全部录音文件名 */
- (NSArray *)recordNames;
/** 录音文件夹路径 */
- (NSString *)recordDirectory;
/** 全部录音频文件属性*/
- (NSArray<RLGSpeechModel *> *)recordURLAssets;
@end

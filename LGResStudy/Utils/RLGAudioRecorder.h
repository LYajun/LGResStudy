//
//  RLGAudioRecorder.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLGAudioModel : NSObject

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


@interface RLGAudioRecorder : NSObject
@property (nonatomic,copy) void (^RecordTimeBlock) (NSInteger recordTime);
@property (nonatomic,copy) void (^RecorderFinishBlock) (void);
@property (nonatomic,copy) void (^RecorderOccurErrorBlock) (void);
@property (nonatomic,copy) void (^PlayerFinishBlock) (void);
@property (nonatomic,copy) void (^PlayerOccurError) (void);
@property (nonatomic,copy) void (^RemoveRecordBlock) (void);
+ (RLGAudioRecorder *)shareInstance;
- (void)microphoneAuthorization;
/** 开始录音 */
- (void)record;
/** 停止 */
- (void)stop;
/** 是否正在录音 */
- (BOOL)isRecording;
/** 录音保存文件夹 */
- (NSString *)recordDirectory;
/** 根据录音文件路径删除录音文件 */
- (void)removeRecordFileAtPath:(NSString *) path;
/** 全部录音文件路径 */
- (NSArray *)recordFiles;
/** 全部录音文件名 */
- (NSArray *)recordNames;
/** 全部录音频文件属性*/
- (NSArray<RLGAudioModel *> *)recordURLAssets;
/** 播放录音 */
- (void)playAtPath:(NSString *) path;
/** 停止播放 */
- (void)stopPlay;
/** 当前资源是否正在播放 */
- (BOOL)isPlayAtPath:(NSString *)path;
@end

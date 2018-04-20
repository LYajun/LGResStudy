//
//  RLGAudioRecorder.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGAudioRecorder.h"
#import "RLGCommon.h"
#import <AVFoundation/AVFoundation.h>
#import "RLGWeakTimer.h"
#import <LGAlertUtil/LGAlertUtil.h>

@implementation RLGAudioModel
@end

@interface RLGAudioRecorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    // 标记是否正在录音
    BOOL wIsRecording;
    AVAudioRecorder *wRecorder;
    AVAudioPlayer *wAudioPlayer;
}
@property(nonatomic,strong) RLGWeakTimer *timer;
@property (nonatomic,assign) NSInteger timeCount;
@property (nonatomic,assign)  BOOL authorization;
@end
@implementation RLGAudioRecorder
+ (RLGAudioRecorder *)shareInstance{
    static RLGAudioRecorder * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[RLGAudioRecorder alloc]init];
    });
    return macro;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
#pragma mark public
- (void)microphoneAuthorization{
    __weak typeof(self) weakSelf = self;
    [self checkCameraAuthorizationGrand:^{
        weakSelf.authorization = YES;
    } withNoPermission:^{
        weakSelf.authorization = NO;
    }];
}
- (void)record{
    if (!self.authorization) {
        [LGAlert alertWarningWithMessage:@"录音失败,麦克风权限未打开" confirmTitle:@"我知道了" confirmBlock:nil];
        if (self.RecorderOccurErrorBlock) {
            self.RecorderOccurErrorBlock();
        }
        return;
    }
    if (wRecorder) {
        [self stop];
    }
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    NSError *error=nil;
    wRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordPath] settings:self.recordConfig error:&error];
    wRecorder.delegate = self;
    [wRecorder prepareToRecord];
    if (error) {
        wRecorder = nil;
        RLG_Log([NSString stringWithFormat:@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription]);
    }else{
        [wRecorder record];
        [self.timer fire];
    }
}
- (void)stop{
    if (wRecorder) {
        [wRecorder stop];
        wRecorder = nil;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 0;
}
- (BOOL)isRecording{
    return wRecorder.isRecording;
}

- (NSString *)recordDirectory{
    NSString *recordDir = [NSString stringWithFormat:@"%@/Library/LGAudioRecorder/%@/%@",NSHomeDirectory(),LGResConfig().UserID,LGResConfig().GUID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return recordDir;
}
- (void)removeRecordFileAtPath:(NSString *) path{
    if (wAudioPlayer) {
        [self stopPlay];
    }
    NSError *error;
    [self.fileManager removeItemAtPath:path error:&error];
    if (error) {
        RLG_Log([NSString stringWithFormat:@"删除录音文件失败: %@",error.localizedDescription]);
    }else{
        if (self.RemoveRecordBlock) {
            self.RemoveRecordBlock();
        }
    }
}
- (NSArray *)recordNames{
    NSError *error;
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.recordDirectory error:&error];
    if (error) {
        RLG_Log([NSString stringWithFormat:@"获取录音文件失败: %@",error.localizedDescription]);
        return nil;
    }
    return fileList;
}
- (NSArray *)recordFiles{
    NSError *error;
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.recordDirectory error:&error];
    if (error) {
        RLG_Log([NSString stringWithFormat:@"获取录音文件失败: %@",error.localizedDescription]);
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *name in fileList) {
        NSString *fullpath = [self.recordDirectory stringByAppendingPathComponent:name];
        [arr addObject:fullpath];
    }
    return arr;
}

- (NSArray<RLGAudioModel *> *)recordURLAssets{
    NSArray *paths = self.recordFiles;
    if (RLG_IsEmpty(paths)) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *path in paths) {
        [arr addObject:[self parseVoiceFileAtPath:path]];
    }
    return arr;
}
- (void)playAtPath:(NSString *)path{
    if (wAudioPlayer) {
        [self stopPlay];
    }
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    NSError *error=nil;
    wAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    wAudioPlayer.numberOfLoops = 0;
    wAudioPlayer.volume = 1.0;
    [wAudioPlayer prepareToPlay];
    wAudioPlayer.delegate = self;
    if (error) {
        RLG_Log([NSString stringWithFormat:@"创建播放器过程中发生错误，错误信息： %@",error.localizedDescription]);
    }else{
        [wAudioPlayer play];
    }
}
- (void)stopPlay{
    if (wAudioPlayer) {
        [wAudioPlayer stop];
        wAudioPlayer = nil;
    }
}
- (BOOL)isPlayAtPath:(NSString *)path{
    if (!wAudioPlayer) {
        return NO;
    }
    NSString *currentPath = wAudioPlayer.url.path;
    return [path isEqualToString:currentPath];
}
#pragma mark 协议
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
     [self stop];
    if (self.RecorderFinishBlock) {
        self.RecorderFinishBlock();
    }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    if (wRecorder) {
        [wRecorder deleteRecording];
    }
    [self stop];
    if (self.RecorderOccurErrorBlock) {
        self.RecorderOccurErrorBlock();
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlay];
    if (self.PlayerFinishBlock) {
        self.PlayerFinishBlock();
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
     [self stopPlay];
    if (self.PlayerOccurError) {
        self.PlayerOccurError();
    }
}
#pragma mark private
- (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                granted ? permissionGranted() : noPermission();
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            //通过授权
            permissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            //不能授权
            NSLog(@"不能完成授权，可能开启了访问限制");
        case AVAuthorizationStatusDenied:{
            //提示跳转到设置
        }
            break;
        default:
            break;
    }
}
- (RLGWeakTimer *)timer{
    if (!_timer) {
         _timer = [RLGWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES dispatchQueue:dispatch_queue_create("LGResStudyTimerQueue", DISPATCH_QUEUE_CONCURRENT)];
    }
    return _timer;
}
- (void)timerAction{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeCount++;
        if (weakSelf.RecordTimeBlock) {
            weakSelf.RecordTimeBlock(weakSelf.timeCount);
        }
    });
}
- (NSFileManager *)fileManager{
    return [NSFileManager defaultManager];
}
- (NSString *)recordPath{
    return [self.recordDirectory stringByAppendingPathComponent:self.recordName];
}
- (NSString *)recordName{
    NSDate *date= [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    return [NSString stringWithFormat:@"%@.caf",[dateformatter stringFromDate:date]];
}
- (NSDictionary *)recordConfig{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式.caf
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
// 解析音频文件属性:
-(RLGAudioModel *)parseVoiceFileAtPath:(NSString *) filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dictAtt = [fm attributesOfItemAtPath:filePath error:nil];
    //取得音频数据
    NSURL *fileURL=[NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    RLGAudioModel *assetModel = [[RLGAudioModel alloc] init];
    CMTime audioDuration = asset.duration;
    assetModel.duration = (NSInteger)CMTimeGetSeconds(audioDuration);
    assetModel.path = filePath;
//    NSString *singer;//歌手
//    NSString *song;//歌曲名
//    UIImage *image;//图片
//    NSString *albumName;//专辑名
    NSString *fileSize;//文件大小
    NSString *voiceStyle;//音质类型
    NSString *fileStyle;//文件类型
//    NSString *creatDate;//创建日期
    
//    for (NSString *format in [asset availableMetadataFormats]) {
//        for (AVMetadataItem *metadataItem in [asset metadataForFormat:format]) {
//            if([metadataItem.commonKey isEqualToString:@"title"]){
//                song = (NSString *)metadataItem.value;
//            }else if ([metadataItem.commonKey isEqualToString:@"artist"]){
//                singer = (NSString *)metadataItem.value;
//            }
//            else if ([metadataItem.commonKey isEqualToString:@"albumName"]){
//                albumName = (NSString *)metadataItem.value;
//            }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
//                NSDictionary *dict=(NSDictionary *)metadataItem.value;
//                NSData *data=[dict objectForKey:@"data"];
//                image = [UIImage imageWithData:data];//图片
//            }
//        }
//    }
    float tempFlo = [[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024);
    fileSize = [NSString stringWithFormat:@"%.2fMB",[[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024)];
//    NSString *tempStrr  = [NSString stringWithFormat:@"%@", [dictAtt objectForKey:@"NSFileCreationDate"]] ;
// 少8小时
//    creatDate = [tempStrr substringToIndex:19];
    NSString *fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
    NSString *timeStr = [fileName componentsSeparatedByString:@"."].firstObject;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateformatter dateFromString:timeStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    assetModel.createTime = [formatter stringFromDate:date];
    
    fileStyle = [fileName componentsSeparatedByString:@"."].lastObject;
    if(tempFlo <= 2){
        voiceStyle = @"普通";
    }else if(tempFlo > 2 && tempFlo <= 5){
        voiceStyle = @"良好";
    }else if(tempFlo > 5 && tempFlo < 10){
        voiceStyle = @"标准";
    }else if(tempFlo > 10){
        voiceStyle = @"高清";
    }
    assetModel.fileSize = fileSize;
    assetModel.fileType = fileStyle;
    assetModel.voiceType = voiceStyle;
    return assetModel;
}
@end

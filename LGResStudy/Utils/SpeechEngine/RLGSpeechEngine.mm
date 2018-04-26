//
//  RLGSpeechEngine.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/24.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGSpeechEngine.h"
#import "RLGWeakTimer.h"
#import <AVFoundation/AVFoundation.h>

#import "zlib.h"
#include "skegn.h"

extern "C" {
#include "airecorder.h"
#include "aiplayer.h"
}

@implementation RLGSpeechModel

@end
@implementation RLGSpeechResultModel

@end
@interface RLGSpeechEngine ()
{
    struct airecorder * recorder;
    struct aiplayer * player;
    struct skegn * engine;
    
    char app_key[64];
    char secret_key[64];
    char device_id[64];
    char user_id[64];
}
@property (nonatomic,copy) void (^timeBlock) (NSInteger recordTime);
@property (nonatomic,copy) void (^initBlock) (BOOL success);
@property (nonatomic,copy) void (^stopBlock) (void);
@property (nonatomic,copy) void (^speechEngineResultBlock) (RLGSpeechResultModel *resultModel);
@property(nonatomic,strong) RLGWeakTimer *timer;
@property (nonatomic,assign) NSInteger timeCount;
@property (nonatomic,assign) BOOL isInit;
@end

@implementation RLGSpeechEngine
char coreType[24] = {0};
char serialNumber[64] = {0};

#pragma mark cycle
+ (instancetype)shareInstance{
    static RLGSpeechEngine * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[RLGSpeechEngine alloc]init];
    });
    return macro;
}
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
#pragma mark static
static int _recorder_callback(const void * usrdata, const void * data, int size)
{
    printf("feed: %d\n", size);
    return skegn_feed((struct skegn*) usrdata, data, size);
}


static int _skegn_callback(const void *usrdata, const char *id, int type, const void *message, int size)
{
    if (type == SKEGN_MESSAGE_TYPE_JSON) {
        /* received score result in json formatting */
        [(__bridge RLGSpeechEngine *)usrdata performSelectorOnMainThread:@selector(showResult:) withObject:[[NSString alloc] initWithUTF8String:(char *)message] waitUntilDone:NO];
        
    }
    return 0;
}

#pragma mark public

- (void)initEngine{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf dispatchInitEngine];
    });
    [self addNotification];
}
- (void)deleteEngine{
    skegn_delete(engine);
    [self removeNotification];
    [self removeTimer];
}
- (void)stopEngine{
    airecorder_stop(recorder);
    skegn_stop(engine);
    [self removeTimer];
    if (self.stopBlock) {
        self.stopBlock();
    }
}
- (void)invalidateEngine{
    if (engine) {
        skegn_delete(engine);
        engine = NULL;
    }
    
    if (player) {
        aiplayer_delete(player);
        player = NULL;
    }
    
    if (recorder) {
        airecorder_delete(recorder);
        recorder = NULL;
    }
    [self removeNotification];
    [self removeTimer];
}
- (BOOL)isInitConfig{
    return self.isInit;
}
- (void)setMarkType:(RLGSpeechEngineMarkType)markType{
    _markType = markType;
    [self stopEngine];
    if (markType == RLGSpeechEngineMarkTypeWord) {
        strcpy(coreType, "word.eval");
    }else{
         strcpy(coreType, "sent.eval");
    }
}
- (void)startEngineAtRefText:(NSString *)refText complete:(void (^)(NSError *))complete{
    if (self.initBlock) {
        self.initBlock(self.isInit);
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"micAuthorization"]) {
        if (complete) {
            complete([NSError errorWithDomain:@"RLGSpeechEngineDomain" code:RLGSpeechEngineErrorTypeRecordAuthError userInfo:@{NSLocalizedDescriptionKey:@"麦克风权限未打开"}]);
        }
        return;
    }
    int rv = 0;
    refText = [refText stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    
    if (recorder == NULL || engine == NULL || [refText isEqualToString:@""]) {
        if (complete) {
            complete([NSError errorWithDomain:@"RLGSpeechEngineDomain" code:RLGSpeechEngineErrorTypeIniting userInfo:@{NSLocalizedDescriptionKey:@"语音评测参数有误"}]);
        }
        return;
    }
    NSString *data =[NSString stringWithFormat:@"{\"appKey\":\"%s\",\"secretKey\":\"%s\"}", app_key,secret_key];
    const char *charData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    char charArray[512] = {0};
    for (int i=0; i < strlen(charData); i++) {
        charArray[i] = charData[i];
    }
    
    printf("%s",charArray);
    NSString *str=[NSString stringWithCString:charArray  encoding:NSUTF8StringEncoding];
    NSLog(@"str=%@",str);
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSLog(@"dic=%@",dic);
    
    char wav_path[1024];
    char record_id[64] = {0};
    char param[4096];
    sprintf(param, "{\"coreProvideType\":\"native\",\"serialNumber\":\"%s\", \"app\": {\"userId\": \"this-is-user-id\"}, \"audio\": {\"audioType\": \"wav\", \"sampleRate\": 16000, \"channel\": 1, \"sampleBytes\": 2}, \"request\" : {\"coreType\": \"%s\", \"refText\": \"%s\", \"attachAudioUrl\": 1, \"dict_type\":\"KK\"}}}", serialNumber, coreType, [refText UTF8String]);
    rv = skegn_start(engine, param, record_id, (skegn_callback)_skegn_callback, (__bridge const void *)(self));
    if (rv) {
        printf("skegn_start() failed: %d\n", rv);
         if (complete) {
             complete([NSError errorWithDomain:@"RLGSpeechEngineDomain" code:RLGSpeechEngineErrorTypeEngineStartError userInfo:@{NSLocalizedDescriptionKey:@"语音评测启动失败"}]);
         }
        return;
    }
    sprintf(wav_path, "%s/%s.wav", [self.recordDirectory UTF8String], record_id);
    if((rv = airecorder_start(recorder, wav_path, _recorder_callback, engine, 100)) != 0) {
        printf("airecorder_start() failed: %d\n", rv);
        if (complete) {
            complete([NSError errorWithDomain:@"RLGSpeechEngineDomain" code:RLGSpeechEngineErrorTypeRecordStartError userInfo:@{NSLocalizedDescriptionKey:@"录音启动失败"}]);
        }
        return;
    }
     if (complete) {
         complete(nil);
     }
     [self.timer fire];
}
- (void)recordTime:(void (^)(NSInteger))timeBlock{
    _timeBlock = timeBlock;
}
- (void)initResult:(void (^)(BOOL))resultBlock{
    _initBlock = resultBlock;
}
- (void)stopEngine:(void (^)())stopBlock{
    _stopBlock = stopBlock;
}
- (void)speechEngineResult:(void (^)(RLGSpeechResultModel *))resultBlock{
    _speechEngineResultBlock = resultBlock;
}
- (void)playback:(void (^)(BOOL))playackBlock{
    if (recorder == NULL) {
        if (playackBlock) {
            playackBlock(NO);
        }
        return;
    }
    if (airecorder_playback(recorder) != 0) {
        if (playackBlock) {
            playackBlock(NO);
        }
        return;
    };
    if (playackBlock) {
        playackBlock(YES);
    }
}
- (void)removeRecordFileAtPath:(NSString *)path complete:(void (^)(BOOL))complete{
    NSError *error;
    [self.fileManager removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"删除录音文件失败: %@",error.localizedDescription]);
        if (complete) {
            complete(NO);
        }
    }else{
        if (complete) {
            complete(YES);
        }
    }
}
#pragma mark private
- (NSFileManager *)fileManager{
    return [NSFileManager defaultManager];
}
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 0;
}
- (void)showResult:(NSString *) result{
    [self removeTimer];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        RLGSpeechResultModel *model = [[RLGSpeechResultModel alloc] init];
        NSData *rdata = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rdata options:NSJSONReadingMutableLeaves  error:nil];
        model.speechID = [resultDic objectForKey:@"tokenId"];
        if ([result rangeOfString:@"errId"].length > 0) {
            [self stopEngine];
            model.isError = YES;
            model.errorMsg = [resultDic objectForKey:@"error"];
            model.totalScore = @"0";
            NSString *fullpath = [self.recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",model.speechID]];
            [self removeRecordFileAtPath:fullpath complete:nil];
        }else{
            NSDictionary *jsonresult = [resultDic objectForKey:@"result"];
             model.isError = NO;
             model.errorMsg = @"";
            
            NSString *str = @"";
            NSArray *arr0 = [NSArray arrayWithObjects:@"words", nil];
            NSArray *jsonwords = [jsonresult objectsForKeys:arr0 notFoundMarker:@"notFound"];
            
            if (strcmp(coreType, "word.eval") == 0) {
                NSArray *arr = [NSArray arrayWithObjects:@"phonemes",nil];
                NSDictionary *word = jsonwords[0][0];
                NSArray *ph = [word objectsForKeys:arr notFoundMarker:@"notFound"];
                if(![ph containsObject:@"notFound"])
                {
                    str = @"/";
                    for(int i=0; i<((NSArray *)ph[0]).count; i++)
                    {
                        str = [str  stringByAppendingString:[NSString stringWithFormat:@"%@:%@ /", [ph[0][i] objectForKey:@"phoneme"], [ph[0][i] objectForKey:@"pronunciation"]]];
                    }
                }
                model.phonemeScore = str;
            }else{
                model.integrityScore = [jsonresult objectForKey:@"integrity"];
                model.fluencyScore = [jsonresult objectForKey:@"fluency"];
                for(int i=0; i<((NSArray *)jsonwords[0]).count; i++)
                {
                    str = [str  stringByAppendingString:[NSString stringWithFormat:@"%@:%@ /", [[jsonwords[0][i] objectForKey:@"word"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]], [[jsonwords[0][i] objectForKey:@"scores"] objectForKey:@"overall"]]];
                }
                model.wordScore = str;
            }
            model.totalScore = [jsonresult objectForKey:@"overall"];
            model.pronunciationScore = [jsonresult objectForKey:@"pronunciation"];
        }
        if (weakSelf.speechEngineResultBlock) {
            weakSelf.speechEngineResultBlock(model);
        }
    });
}
- (NSArray *)recordFiles{
    NSError *error;
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.recordDirectory error:&error];
    if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"获取录音文件失败: %@",error.localizedDescription]);
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *name in fileList) {
        NSString *fullpath = [self.recordDirectory stringByAppendingPathComponent:name];
        [arr addObject:fullpath];
    }
    return arr;
}
- (NSArray *)recordNames{
    NSError *error;
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.recordDirectory error:&error];
    if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"获取录音文件失败: %@",error.localizedDescription]);
        return nil;
    }
    return fileList;
}
- (NSArray<RLGSpeechModel *> *)recordURLAssets{
    NSArray *paths = self.recordFiles;
    if (paths && paths.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *path in paths) {
            [arr addObject:[self parseVoiceFileAtPath:path]];
        }
        return arr;
    }
    return nil;
}
-(RLGSpeechModel *)parseVoiceFileAtPath:(NSString *) filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dictAtt = [fm attributesOfItemAtPath:filePath error:nil];
    //取得音频数据
    NSURL *fileURL=[NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    RLGSpeechModel *assetModel = [[RLGSpeechModel alloc] init];
    CMTime audioDuration = asset.duration;
    assetModel.duration = (NSInteger)CMTimeGetSeconds(audioDuration);
    assetModel.path = filePath;
    NSString *fileSize;//文件大小
    NSString *voiceStyle;//音质类型
    NSString *fileStyle;//文件类型
    NSString *creatDate;//创建日期
    float tempFlo = [[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024);
    fileSize = [NSString stringWithFormat:@"%.2fMB",[[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024)];
        NSString *tempStrr  = [NSString stringWithFormat:@"%@", [dictAtt objectForKey:@"NSFileCreationDate"]] ;
    creatDate = [tempStrr substringToIndex:19];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:creatDate];
    NSDate *refDate = [date initWithTimeIntervalSinceNow:8 * 60 * 60];
    assetModel.createTime = [dateformatter stringFromDate:refDate];
    
    NSString *fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
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
- (void)addNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initEngine) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopEngine) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateEngine) name:@"UIApplicationWillTerminateNotification" object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dispatchInitEngine{
    char cfg[4096];
    
    strcpy(app_key, "148757611600000f");
    strcpy(secret_key, "2d5356fe1d5f3f13eba43ca48c176647");
    strcpy(user_id, "this-is-user-id");
    strcpy(coreType, "word.eval");
    
    static char provision[1024];
    strcpy(provision, [[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithUTF8String:"skegn.provision"] ofType:NULL] UTF8String]);
    
    static char resource_path[1024];
    strcpy(resource_path, [[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithUTF8String:"native.res"] ofType:NULL] UTF8String]);
    
    sprintf(cfg, "{\"appKey\": \"%s\", \"secretKey\": \"%s\", \"provision\": \"%s\", \"native\":\"%s\"}", app_key, secret_key, provision, resource_path);
    
    
    engine = skegn_new(cfg);
    
    // 离线内核需要获取serialNumber，需要保存为以后使用
    char serialbuf[1024] = {0};
    strcpy(serialbuf, "{\"appKey\":\"148757611600000f\", \"secretKey\":\"2d5356fe1d5f3f13eba43ca48c176647\"}");
    skegn_opt(0, 6, serialbuf, sizeof(serialbuf));
    char *p = strstr(serialbuf, "serialNumber");
    char *p1 = NULL;
    if(p){
        p += strlen("serialNumber") + 3;
        p1 = strchr(p, '"');
        if(p1)*p1 = '\0';
        strcpy(serialNumber, p);
    }
    
    recorder = airecorder_new();
    player = aiplayer_new();
    
    printf("engine: %p\n", engine);
    printf("recorder: %p\n", recorder);
    printf("player: %p\n", player);
    self.isInit = YES;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.initBlock) {
            weakSelf.initBlock(YES);
        }
    });
}
- (NSString *)recordDirectory{
    NSString *recordDir = [NSString stringWithFormat:@"%@/Documents/record",NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return recordDir;
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
        if (weakSelf.timeBlock) {
            weakSelf.timeBlock(weakSelf.timeCount);
        }
    });
}
@end

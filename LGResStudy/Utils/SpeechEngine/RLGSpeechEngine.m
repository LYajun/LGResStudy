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
#import <objc/message.h>
#import "KYTestEngine.h"

@implementation RLGSpeechModel

@end
@implementation RLGSpeechResultModel
+ (instancetype)speechResultWithDictionary:(NSDictionary *)aDictionary{
    id objc = [[self alloc] init];
    unsigned int count;
    // 获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组取出对应的成员属性
        Ivar ivar = ivarList[i];
        // 获取成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 处理成员属性名->字典中的key
        // 从第一个角标开始截取
        NSString *key = [name substringFromIndex:1];
        // 根据成员属性名去字典中查找对应的value
        id value = aDictionary[key];
        if (value) { // 有值，才需要给模型的属性赋值
            // 利用KVC给模型中的属性赋值
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
- (NSDictionary *)rlg_JSONObject{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(RLGSpeechResultModel.class, &count);
    NSMutableDictionary *jsonModel = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKeyPath:key];
        if (!value || value == [NSNull null]) continue;
        [jsonModel setValue:value forKey:key];
    }
    return jsonModel;
}
@end
@interface RLGSpeechEngine ()
@property (nonatomic,copy) void (^timeBlock) (NSInteger recordTime);
@property (nonatomic,copy) void (^initBlock) (BOOL success);
@property (nonatomic,copy) void (^stopBlock) (void);
@property (nonatomic,copy) void (^speechEngineResultBlock) (RLGSpeechResultModel *resultModel);
@property(nonatomic,strong) RLGWeakTimer *timer;
@property (nonatomic,assign) NSInteger timeCount;
@property (nonatomic,assign) BOOL isInit;
@property (nonatomic,assign) RLGSpeechEngineMarkType markType;
@end

@implementation RLGSpeechEngine


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

#pragma mark public

- (void)initEngine{
    self.isInit = NO;
    //配置初始化引擎参数
    KYStartEngineConfig *startEngineConfig = [[KYStartEngineConfig alloc] init];
    startEngineConfig.appKey = @"148757611600000f";
    startEngineConfig.secretKey = @"2d5356fe1d5f3f13eba43ca48c176647";
    
    __weak typeof(self) weakSelf = self;
    //初始化引擎
    [[KYTestEngine sharedInstance] initEngine:KY_CloudEngine startEngineConfig:startEngineConfig finishBlock:^(BOOL isSuccess) {
        weakSelf.isInit = isSuccess;
        if (weakSelf.initBlock) {
            weakSelf.initBlock(isSuccess);
        }
    }];
//    [self addNotification];
}
- (void)deleteEngine{
    [[KYTestEngine sharedInstance] deleteEngine];
//    [self removeNotification];
    [self removeTimer];
}
- (void)stopEngine{
    [[KYTestEngine sharedInstance] stopEngine];
    [self removeTimer];
    if (self.stopBlock) {
        self.stopBlock();
    }
}
- (void)invalidateEngine{
    [[KYTestEngine sharedInstance] cancelEngine];
//    [self removeNotification];
    [self removeTimer];
}
- (BOOL)isInitConfig{
    return self.isInit;
}

- (void)startEngineAtRefText:(NSString *)refText markType:(RLGSpeechEngineMarkType) markType{
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    self.markType = markType;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"micAuthorization"]) {
        [self showResult:@"麦克风权限未打开"];
        return;
    }
    
    if (!refText || [refText isEqualToString:@""]) {
        [self showResult:@"语音评测参数有误"];
        return;
    }
    //配置评测参数
    KYTestConfig *config = [[KYTestConfig alloc] init];
    if (markType == RLGSpeechEngineMarkTypeWord) {
        config.coreType = KYTestType_Word;
    }else{
        config.coreType = KYTestType_Sentence;
    }
    config.refText = refText;
    config.phonemeOption = KYPhonemeOption_KK;
    config.audioType = @"wav";
    config.sampleRate = 16000;
    config.sampleBytes = 2;
    __weak typeof(self) weakSelf = self;
    [[KYTestEngine sharedInstance] startEngineWithTestConfig:config result:^(NSString *testResult) {
        [weakSelf showResult:testResult];
    }];
    
     [self.timer fire];
}
- (void)recordTime:(void (^)(NSInteger))timeBlock{
    _timeBlock = timeBlock;
}
- (void)initResult:(void (^)(BOOL))resultBlock{
    _initBlock = resultBlock;
}
- (void)stopEngine:(void (^)(void))stopBlock{
    _stopBlock = stopBlock;
}
- (void)speechEngineResult:(void (^)(RLGSpeechResultModel *))resultBlock{
    _speechEngineResultBlock = resultBlock;
}
- (void)playback{
     [[KYTestEngine sharedInstance] playback];
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
//    assetModel.createTime = creatDate;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:creatDate];
    NSDate *refDate = [date dateByAddingTimeInterval:8 * 60 * 60];
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
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self removeTimer];
    NSLog(@"评测结果:%@",result);
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        RLGSpeechResultModel *model = [[RLGSpeechResultModel alloc] init];
        if ([result containsString:@"tokenId"]) {
            NSData *rdata = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rdata options:NSJSONReadingMutableLeaves  error:nil];
            if ([result rangeOfString:@"errId"].length > 0) {
                [self stopEngine];
                model.isError = YES;
                model.errorMsg = [resultDic objectForKey:@"error"];
                model.totalScore = @"0";
                NSString *fullpath = [self.recordDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[resultDic objectForKey:@"tokenId"]]];
                [self removeRecordFileAtPath:fullpath complete:nil];
            }else{
                model.speechID = [resultDic objectForKey:@"tokenId"];
                NSDictionary *jsonresult = [resultDic objectForKey:@"result"];
                model.isError = NO;
                model.errorMsg = @"";
                
                NSString *str = @"";
                NSArray *arr0 = [NSArray arrayWithObjects:@"words", nil];
                NSArray *jsonwords = [jsonresult objectsForKeys:arr0 notFoundMarker:@"notFound"];
                
                if (self.markType == RLGSpeechEngineMarkTypeWord) {
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
        }else{
            [self stopEngine];
            model.isError = YES;
            model.errorMsg = result;
            model.totalScore = @"0";
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
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *name in fileList) {
        [arr addObject:[name componentsSeparatedByString:@"."].firstObject];
    }
    return arr;
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

//- (void)addNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initEngine) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopEngine) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateEngine) name:@"UIApplicationWillTerminateNotification" object:nil];
//}
//- (void)removeNotification{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

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

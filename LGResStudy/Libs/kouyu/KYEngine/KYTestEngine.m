//
//  KYTestEngine.m
//  KouyuDemo
//
//  Created by Attu on 2017/8/15.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "KYTestEngine.h"
#import "KYRecorder.h"
#import "zlib.h"

//证书是否为新的
#define KY_isNew @"ky_isNew"
//保存序列号的Key
#define KY_SerialNumber @"KY_SerialNumber"

@interface NSMutableDictionary (Additional)

- (instancetype)setNotEmptyValue:(id)object forKey:(NSString *)key;

@end

@implementation NSMutableDictionary (Additional)

- (instancetype)setNotEmptyValue:(id)object forKey:(NSString *)key {
    
    if ([object isKindOfClass:[NSString class]]) {
        if ([object length] != 0) {
            [self setValue:object forKey:key];
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object floatValue] != 0) {
            [self setValue:object forKey:key];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        if ([object count] != 0) {
            [self setValue:object forKey:key];
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        if ([object count] != 0) {
            [self setValue:object forKey:key];
        }
    }
    
    return self;
}

@end

@interface KYTestEngine ()

@property (nonatomic, assign) struct skegn *engine;

@property (nonatomic, strong) KYRecorder *recorder;

@property (nonatomic, copy) NSString *serialNumber;

@property (nonatomic, assign) KYEngineType engineType;

@property (nonatomic, strong) KYStartEngineConfig *startEngineConfig;

@property (nonatomic, copy) KYTestResultBlock testResultBlock;

@end

@implementation KYTestEngine

static int _skegn_callback(const void *usrdata, const char *id, int type, const void *message, int size)
{
    if (type == SKEGN_MESSAGE_TYPE_JSON) {
        /* received score result in json formatting */
        [(__bridge KYTestEngine *)usrdata performSelectorOnMainThread:@selector(showResult:) withObject:[[NSString alloc] initWithUTF8String:(char *)message] waitUntilDone:NO];
    }
    return 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/record"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}

#pragma mark - Init Method

+ (instancetype)sharedInstance {
    static KYTestEngine *engine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[KYTestEngine alloc] init];
    });
    return engine;
}

#pragma mark - Public Method

//初始化引擎
- (void)initEngine:(KYEngineType)engineType startEngineConfig:(KYStartEngineConfig *)startEngineConfig finishBlock:(void (^)(BOOL))finishBlock {
    self.startEngineConfig = startEngineConfig;
    self.engineType = engineType;
    
//    [self checkProvisionFile];
    
    if (self.recorder != NULL || self.engine != NULL) {
        [self stopEngine];
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char cfg[4096];

        strcpy(cfg, [self configInitEngineParamWith:startEngineConfig].UTF8String);
    
        weakSelf.engine = skegn_new(cfg);
//        if (weakSelf.engine) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:KY_isNew];
//        }
        
        weakSelf.recorder = [[KYRecorder alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                if (weakSelf.engine) {
                    finishBlock(YES);
                } else {
                    finishBlock(NO);
                }
            }
        });
    });
}

//开始评测
- (void)startEngineWithTestConfig:(KYTestConfig *)testConfig result:(KYTestResultBlock)testResultBlock {
    
    int rv = 0;
    
    if (self.recorder == NULL || self.engine == NULL) {
        return;
    }
    
    char record_id[64] = {0};
    char param[4096];
 
    strcpy(param, [self configParamRequestWith:testConfig].UTF8String);
    
    rv = skegn_start(self.engine, param, record_id, (skegn_callback)_skegn_callback, (__bridge const void *)(self));
    if (rv) {
        printf("skegn_start() failed: %d\n", rv);
        testResultBlock(@"语音评测启动失败");
        return;
    }
    
    NSString *wavPath = [NSString stringWithFormat:@"%@/Documents/record/%s.wav", NSHomeDirectory(), record_id];
    
    rv = [self.recorder startReocrdWith:wavPath engine:self.engine callbackInterval:100 recorderBlock:^(struct skegn *engine, const void *audioData, int size) {
        printf("feed: %d\n", size);
        skegn_feed(engine, audioData, size);
    }];
    
    if(rv != 0) {
        printf("airecorder_start() failed: %d\n", rv);
        testResultBlock(@"录音启动失败");
        return;
    }
    
    self.testResultBlock = testResultBlock;
}

- (void)stopEngine {
    if (self.recorder) {
        [self.recorder stopRecorder];
    }
    if (self.engine) {
        skegn_stop(self.engine);
    }
}

- (void)cancelEngine {
    if (self.recorder) {
        [self.recorder stopRecorder];
    }
    if (self.engine) {
        skegn_cancel(self.engine);
    }
}

- (void)deleteEngine {
    [self cancelEngine];
    if (self.engine) {
        skegn_delete(self.engine);
        self.engine = nil;
    }
    if (self.recorder) {
        self.recorder = nil;
    }
}

- (void)playback {
    if (self.recorder == NULL) {
        return;
    }
    [self.recorder playback];
}

#pragma mark - Private Method

//配置启动引擎参数
- (NSString *)configInitEngineParamWith:(KYStartEngineConfig *)startEngineConfig {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setNotEmptyValue:startEngineConfig.appKey forKey:@"appKey"];
    [paramDic setNotEmptyValue:startEngineConfig.secretKey forKey:@"secretKey"];
    [paramDic setNotEmptyValue:startEngineConfig.provison forKey:@"provision"];
    
    if (self.engineType == KY_CloudEngine) {
        NSMutableDictionary *cloudDic = [NSMutableDictionary dictionary];
        [cloudDic setNotEmptyValue:[NSNumber numberWithInteger:startEngineConfig.enable] forKey:@"enable"];
        [cloudDic setNotEmptyValue:startEngineConfig.server forKey:@"server"];
        [cloudDic setNotEmptyValue:startEngineConfig.serverList forKey:@"serverList"];
        [cloudDic setNotEmptyValue:[NSNumber numberWithFloat:startEngineConfig.connectTimeout] forKey:@"connectTimeout"];
        [cloudDic setNotEmptyValue:[NSNumber numberWithFloat:startEngineConfig.serverTimeout] forKey:@"serverTimeout"];
        
        [paramDic setNotEmptyValue:cloudDic forKey:@"cloud"];
    } else {
//        NSDictionary *prof = @{@"enable" : @1,
//                               @"output" : @""};
//
//        [paramDic setNotEmptyValue:prof forKey:@"prof"];
        [paramDic setNotEmptyValue:startEngineConfig.native forKey:@"native"];
        [paramDic setNotEmptyValue:startEngineConfig.provison forKey:@"provision"];
        
        [self loadSerialNumber:startEngineConfig];
    }
    
    NSMutableDictionary *vadDic = [NSMutableDictionary dictionary];
    [vadDic setNotEmptyValue:[NSNumber numberWithInteger:startEngineConfig.vadEnable] forKey:@"enable"];
    [vadDic setNotEmptyValue:[NSNumber numberWithFloat:startEngineConfig.seek] forKey:@"seek"];
    
    [paramDic setNotEmptyValue:vadDic forKey:@"vad"];
    
    NSString *jsonString = [self objectToJsonString:paramDic];
    return jsonString;
}

//获取序列号
- (void)loadSerialNumber:(KYStartEngineConfig *)startEngineConfig {
    self.serialNumber = [[NSUserDefaults standardUserDefaults] objectForKey:KY_SerialNumber];
    
    if (!self.serialNumber) {
        // 离线内核需要获取serialNumber，需要保存为以后使用
        char serialbuf[1024] = {0};
        NSString *keyString = [NSString stringWithFormat:@"{\"appKey\":\"%@\", \"secretKey\":\"%@\"}", startEngineConfig.appKey, startEngineConfig.secretKey];
        strcpy(serialbuf, [keyString UTF8String]);
        skegn_opt(0, 6, serialbuf, sizeof(serialbuf));
        char *p = strstr(serialbuf, "serialNumber");
        char *p1 = NULL;
        if(p){
            p += strlen("serialNumber") + 3;
            p1 = strchr(p, '"');
            if(p1)*p1 = '\0';
            
            static char serialNumber[1024];
            strcpy(serialNumber, p);
            self.serialNumber = [NSString stringWithCString:serialNumber encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:self.serialNumber forKey:KY_SerialNumber];
        }
    }
}

//配置评测请求参数
- (NSString *)configParamRequestWith:(KYTestConfig *)testConfig {
    NSMutableDictionary *appDic = [NSMutableDictionary dictionary];
    [appDic setNotEmptyValue:testConfig.userId forKey:@"userId"];
    
    NSMutableDictionary *audioDic = [NSMutableDictionary dictionary];
    [audioDic setNotEmptyValue:testConfig.audioType forKey:@"audioType"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.sampleRate] forKey:@"sampleRate"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.channel] forKey:@"channel"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.sampleBytes] forKey:@"sampleBytes"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.quality] forKey:@"quality"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.complexity] forKey:@"complexity"];
    [audioDic setNotEmptyValue:[self getCompressType:testConfig.compress] forKey:@"compress"];
    [audioDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.vbr] forKey:@"vbr"];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.getParam] forKey:@"getParam"];
    [requestDic setNotEmptyValue:[self getCoreType:testConfig.coreType] forKey:@"coreType"];
    [requestDic setNotEmptyValue:testConfig.refText forKey:@"refText"];
    [requestDic setNotEmptyValue:testConfig.refAudio forKey:@"refAudio"];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.attachAudioUrl] forKey:@"attachAudioUrl"];
    [requestDic setNotEmptyValue:[self getDicType:testConfig.phonemeOption] forKey:@"dict_type"];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.phoneme_output] forKey:@"phoneme_output"];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.ageGroup] forKey:@"agegroup"];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.paragraph_need_word_score] forKey:@"paragraph_need_word_score"];
    [requestDic setNotEmptyValue:[NSNumber numberWithFloat:testConfig.scale] forKey:@"scale"];
    [requestDic setNotEmptyValue:[NSNumber numberWithFloat:testConfig.precision] forKey:@"precision"];
    [requestDic setNotEmptyValue:[NSNumber numberWithFloat:testConfig.slack] forKey:@"slack"];
    [requestDic setNotEmptyValue:testConfig.keywords forKey:@"keywords"];
    [requestDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.openEvalOption] forKey:@"qType"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setNotEmptyValue:[NSNumber numberWithInteger:testConfig.soundIntensityEnable] forKey:@"soundIntensityEnable"];
    [paramDic setNotEmptyValue:appDic forKey:@"app"];
    [paramDic setNotEmptyValue:audioDic forKey:@"audio"];
    [paramDic setNotEmptyValue:requestDic forKey:@"request"];
    
    if (self.engineType == KY_CloudEngine) {
        // 云端评分配置
        [paramDic setValue:@"cloud" forKey:@"coreProvideType"];
    } else {
        // 离线评分配置
        [paramDic setValue:@"native" forKey:@"coreProvideType"];
        [paramDic setNotEmptyValue:self.serialNumber forKey:@"serialNumber"];
    }
    
    NSString *jsonString = [self objectToJsonString:paramDic];
    return jsonString;
}

//回调评测结果
- (void)showResult:(NSString *)result {
    if ([result containsString:@"errId"]) {
        [self stopEngine];
    }
    if (_testResultBlock) {
        self.testResultBlock(result);
    }
}

- (void)checkProvisionFile {
    BOOL isNew = [[[NSUserDefaults standardUserDefaults] objectForKey:KY_isNew] boolValue];
    if (!isNew) {
        //更新证书 -- KY
        [self downloadProvision];
    }
}

// 下载证书
- (void)downloadProvision {
    char serialbuf[1024] = {0};
    sprintf(serialbuf, "{\"appKey\":\"%s\", \"secretKey\":\"%s\"}", [self.startEngineConfig.appKey UTF8String], [self.startEngineConfig.secretKey UTF8String]);
    
    skegn_opt(0, 6, serialbuf, sizeof(serialbuf));
    char *p = strstr(serialbuf, "provision");
    
    if(!p){
        //网络问题导致获取证书失败，通知用户网络问题，请重新加载
        NSLog(@"语音评测初始化时网络出错");
        return;
    }
    
    NSString *jsonString = [NSString stringWithCString:serialbuf encoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    //保存序列号
    NSString *serialNumber = [jsonDic objectForKey:@"serialNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:serialNumber forKey:KY_SerialNumber];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"skegn.provision"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    //base64解码并写入文件
    NSString *provision = [jsonDic objectForKey:@"provision"];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:provision options:0];
    [decodedData writeToFile:path atomically:YES];
}

//字典、数组转换为JSON字符串
- (NSString *)objectToJsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - 枚举转String

- (NSString *)getCoreType:(KYTestType)testType {
    NSString *coreType;
    switch (testType) {
        case KYTestType_Word:
            coreType = @"word.eval";
            break;
        case KYTestType_Sentence:
            coreType = @"sent.eval";
            break;
        case KYTestType_Paragraph:
            coreType = @"para.eval";
            break;
        case KYTestType_Open:
            coreType = @"open.eval";
            break;
        case KYTestType_Choice:
            coreType = @"choice.rec";
            break;
        default:
            break;
    }
    return coreType;
}

- (NSString *)getDicType:(KYPhonemeOption)phonemeOption {
    NSString *dicType;
    switch (phonemeOption) {
        case KYPhonemeOption_KK:
            dicType = @"KK";
            break;
        case KYPhonemeOption_CMU:
            dicType = @"CMU";
            break;
        case KYPhonemeOption_IPA88:
            dicType = @"IPA88";
            break;
        default:
            break;
    }
    return dicType;
}

- (NSString *)getCompressType:(KYCompressType)compressType {
    NSString *compress;
    switch (compressType) {
        case KYCompress_Raw:
            compress = @"raw";
            break;
        case KYCompress_Speex:
            compress = @"speex";
            break;
        default:
            break;
    }
    return compress;
}

@end

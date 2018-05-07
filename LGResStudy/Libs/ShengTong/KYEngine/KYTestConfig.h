//
//  KYTestConfig.h
//  KouyuDemo
//
//  评测时需要配置的参数
//
//  Created by Attu on 2017/8/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//音频压缩配置
typedef enum : NSUInteger {
    KYCompress_Speex = 1,     //压缩
    KYCompress_Raw,       //不压缩
} KYCompressType;

//请求的内核类型
typedef enum : NSUInteger {
    KYTestType_Word,              //单词评测(1 个单词)
    KYTestType_Sentence,          //句子评测(40 单词内)
    KYTestType_Paragraph,         //段落评测(1000 单词内)
    KYTestType_Open,              //开放题型
    KYTestType_Choice             //(无限制)
} KYTestType;

//音素字典选项
typedef enum : NSUInteger {
    KYPhonemeOption_CMU = 1,
    KYPhonemeOption_KK,
    KYPhonemeOption_IPA88,
} KYPhonemeOption;

//年龄段支持
typedef enum : NSUInteger {
    KYAgeGroupSupportOption_Junior = 1,     //3~6years-old
    KYAgeGroupSupportOption_Middle,         //6~12years-old
    KYAgeGroupSupportOption_Senior,         //>12years-old
} KYAgeGroupSupportOption;

//开放题型选项
typedef enum : NSUInteger {
    KYOpenEvalOption_PassageReading,         //短文朗读
    KYOpenEvalOption_FollowReadPassage,      //短文跟读
    KYOpenEvalOption_SentenceTranslation,    //句子翻译
    KYOpenEvalOption_ParagraphTranslation,   //段落翻译
    KYOpenEvalOption_RepeatStory,            //故事复述
    KYOpenEvalOption_LookAndSay,             //看图说话
    KYOpenEvalOption_SituationalReply,       //情景问答
    KYOpenEvalOption_OralComposition,        //口头作文
} KYOpenEvalOption;


@interface KYTestConfig : NSObject

// 可选，默认 0，即不返回音强(SoundIntensity)值，可选 1，该值通过 callback 回调返回，参数为“sound_intensity”
@property (nonatomic, assign) BOOL soundIntensityEnable;

// 必选，配置为:"cloud",离线版为:"native"
@property (nonatomic, copy) NSString *coreProvideType;

// 可选，序列号
@property (nonatomic, copy) NSString *serialNumber;

// 可选, 用户在应用中的唯一标识
@property (nonatomic, copy) NSString *userId;



/****************  audio参数  *****************/

// 必须, 云端支持:wav, mp3, flv, ogg, amr 格式, 本地支持: wav 格式
@property (nonatomic, copy) NSString *audioType;

// 必须, 目前只支持单声道, 所以这里只能填 1
@property (nonatomic, assign) NSInteger channel;

// 必须, 每采样字节数, 支持单字节(8 位):1 和双字节(16 位):2
@property (nonatomic, assign) NSInteger sampleBytes;

// 必须, 采样率, 必须与音频本身采样率一致，不同语音服务有不同的要求, wav 格式要求必须是 16k
@property (nonatomic, assign) NSInteger sampleRate;

// 可选, 默认 8，取值范围 1~10. 若不在取值范围之内，则默认配置 8.
@property (nonatomic, assign) NSInteger quality;

// 可选，默认 2
@property (nonatomic, assign) NSInteger complexity;

// 可选, 音频压缩配置, speex:speex 压缩(默认配置), raw:不压缩
@property (nonatomic, assign) KYCompressType compress;

// 可选, vbr 配置，默认值 NO,若设置为 YES，则 quality 值作为 vbr quality 配置
@property (nonatomic, assign) BOOL vbr;

/******************************************/



/****************  request参数  *****************/

// 可选，在返回结果时同时返回请求参数，默认 NO 关闭，可选 YES 开启
@property (nonatomic, assign) BOOL getParam;

// 必须，请求的内核类型 目前支持 word.eval(1 个单词)/sent.eval(40 单词内)/para.eval(1000 单词内)/open.eval/choice.rec(无限制)
@property (nonatomic, assign) KYTestType coreType;

// 必须，参考文本，多个参考答案用竖线(|)隔开, refText 格式要求请参阅 “参考文本传入格式要求.pdf”
@property (nonatomic, copy) NSString *refText;

// 标准音频文件的绝对/相对路 径，使用音频比对内核时可选
@property (nonatomic, copy) NSString *refAudio;

// 可选，使用云服务时可选，指定服务器使返回结果附带音频下载地址
@property (nonatomic, assign) BOOL attachAudioUrl;

// 可选，音素字典选项，默认 CMU，可选 CMU/KK/IPA88
@property (nonatomic, assign) KYPhonemeOption phonemeOption;

// 可选，音素纬度开关，默认 1 开，0 为关闭
@property (nonatomic, assign) BOOL phoneme_output;

// 可选，单词句子段落内核可选，年龄段支持，可选值 1:3~6years-old， 2:6~12years-old，3:>12years-old，默认为 3
@property (nonatomic, assign) KYAgeGroupSupportOption ageGroup;

// para.eval时有效，YES时返回每个单词得分
@property (nonatomic, assign) BOOL paragraph_need_word_score;

// 可选，分制，取值范围(0,100]
@property (nonatomic, assign) CGFloat scale;

// 可选，精度，建议取值的范围(0,1]
@property (nonatomic, assign) CGFloat precision;

// 可选，人工干预单词的得分，取值范围[-1,1]，干预后每个单词得分取值范 围[0,100]
@property (nonatomic, assign) CGFloat slack;

// 可选，关键字，open.eval 题型有效
@property (nonatomic, copy) NSString *keywords;

// 可选，题型，open.eval 题型必须，0 短文朗读;1 短文跟读;2 句子翻译;3 段落翻译;4 故事复述;5 看图说话;6 情景问答;7 口头作文
@property (nonatomic, assign) KYOpenEvalOption openEvalOption;

@end

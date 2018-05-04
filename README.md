# LGResStudy
英语文本类资料（浏览、人工朗读学习模式），英语声文类资料（泛听、跟读学习模式），英语视文类资料（浏览、配音学习模式）。

>	文本

<div align="left">
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/text1.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/text2.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/text3.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/text4.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/text5.PNG" width ="160" height ="288" >
 </div>
 >	声文

<div align="left">
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/voice1.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/voice2.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/voice3.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/voice4.PNG" width ="160" height ="288" >
 </div>
 >	视文

<div align="left">
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/video1.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/video2.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/video3.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGResStudy/blob/master/Assets/video4.PNG" width ="160" height ="288" >
 </div>
 
## 使用方式
 
### 1、集成(手动集成)
- 下载项目
- 将LGResStudy整个文件夹拖入工程中
- Cocoapods添加依赖库

```objective-c
platform :ios,'8.0'
use_frameworks!
target 'LGResStudyDemo’ do
pod 'Masonry'
pod 'MJExtension'
pod 'LGAlertUtil'
pod 'LGDic'
end
```
- Build Phase 添加系统库

![Build Phase](https://github.com/LYajun/LGResStudy/blob/master/Assets/config1.png)

### 2、使用
- 初始化配置

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[LGResConfig() initSpeechEngine];
   [LGAlert config];
}
```
- 调用参数

```
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

```
![调用参数](https://github.com/LYajun/LGResStudy/blob/master/Assets/config1.png)
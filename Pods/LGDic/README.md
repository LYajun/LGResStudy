# LGDic
电子词典（基于知识点课件）
<div align="left">
<img src="https://github.com/LYajun/LGDic/blob/master/Assets/dic1.PNG" width ="375" height ="667" >
<img src="https://github.com/LYajun/LGDic/blob/master/Assets/dic2.PNG" width ="375" height ="667" >
 </div>

## 使用方式

1、集成:

```
pod 'LGDic'
```

2、配置

```objective-c
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
```

3、使用

```objective-c
#import <LGDic/LGDic.h>

LGDicConfig().wordUrl = @"http://zh.lancooecp.com:8019/API/Resources/GetCourseware";
LGDicConfig().userID = @"110";
LGDicConfig().parameters = @{
      @"Knowledge":@"",
      @"levelCode":@""
};
LGDicConfig().wordKey = @"Knowledge";
LGDicConfig().QueryBlock = ^(NSString *word) {
      NSLog(@"搜索回调:%@",word);
};
[self.navigationController pushViewController:LGDicHomeController() animated:YES];
```
# LGAlertUtil
提示工具

Alert:

<div align="left">
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert0.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert1.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert2.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert3.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert4.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert5.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert6.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/alert7.PNG" width ="160" height ="288" >
 </div>
 
 HUD:
 
 <div align="left">
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud1.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud2.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud3.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud4.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud5.PNG" width ="160" height ="288" >
<img src="https://github.com/LYajun/LGAlertUtil/blob/master/Assets/hud6.PNG" width ="160" height ="288" >
 </div>
 
## 使用方式

1、集成:

```
pod 'LGAlertUtil'
```

2、配置(建议在应用启动代理方法中调用)

```
[LGAlert config];
```

默认设置（使用者可以在该方法修改设置，自定义风格）

```
//设置YJAlertView样式
    YJAlertView *alert = [YJAlertView appearance];
    
    // 背景
    alert.layerCornerRadius = 3;
    alert.backgroundColor = [UIColor whiteColor];
    alert.coverColor = [UIColor colorWithWhite:0 alpha:0.6];
    alert.separatorsColor = LGA_Color(0x1379EC);
    
    // 标题
    alert.titleFont = [UIFont systemFontOfSize:17];
    alert.titleTextColor = LGA_Color(0x333333);
    
    // 内容
    alert.messageFont = [UIFont systemFontOfSize:14];
    alert.messageTextColor = LGA_Color(0x333333);
    
    // 普通按钮
    alert.buttonsBackgroundColor = [UIColor whiteColor];
    alert.buttonsBackgroundColorHighlighted = LGA_Color(0xEEEEEE);
    alert.buttonsTitleColor = alert.separatorsColor;
    alert.buttonsTitleColorHighlighted = alert.buttonsTitleColor;
    alert.buttonsFont = [UIFont systemFontOfSize:15];
    
    // 取消按钮
    alert.cancelButtonBackgroundColor = [UIColor whiteColor];
    alert.cancelButtonBackgroundColorHighlighted = LGA_Color(0xEEEEEE);
    alert.cancelButtonTitleColor = alert.separatorsColor;
    alert.cancelButtonTitleColorHighlighted =  alert.cancelButtonTitleColor;
    alert.cancelButtonFont = [UIFont systemFontOfSize:15];
    
    // 确定按钮
    alert.destructiveButtonBackgroundColor = alert.separatorsColor;
    alert.destructiveButtonBackgroundColorHighlighted = LGA_Color(0x0960EC);
    alert.destructiveButtonTitleColor = [UIColor whiteColor];
    alert.destructiveButtonTitleColorDisabled = [UIColor whiteColor];
    alert.destructiveButtonFont = alert.cancelButtonFont;
    
    // 按钮默认标题
    _cancelTitle = @"取消";
    _confirmTitle = @"确定";

```

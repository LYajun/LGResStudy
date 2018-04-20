//
//  DLGCommon.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DLGConfig.h"



static NSString *DLGPlayerDidFinishPlayNotification = @"DLGPlayerDidFinishPlayNotification";

BOOL DLG_IsEmpty(id obj);

NSString *DLG_GETBundleResource(NSString *fileName);

UIColor *DLG_Color(NSInteger hex);
NSAttributedString *DLG_AttributedString(NSString *htmlStr,CGFloat font);
CGFloat DLG_AttributedStringHeight(NSString *htmlStr,CGFloat displayWidth,CGFloat font);
void DLG_Log(NSString *msg);
DLGConfig *LGDicConfig(void);
UIViewController *LGDicHomeController(void);
CGFloat DLG_ScreenWidth(void);
CGFloat DLG_ScreenHeight(void);
CGFloat DLG_NaviBarHeight(UIViewController *vc);
NSArray *DLG_VoiceGifs(void);

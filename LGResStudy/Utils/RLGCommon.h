//
//  DLGCommon.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

BOOL RLG_IsEmpty(id obj);

NSString *RLG_GETBundleResource(NSString *fileName);
UIColor *RLG_Color(NSInteger hex);
NSAttributedString *RLG_AttributedString(NSString *htmlStr,CGFloat font);
void RLG_Log(NSString *msg);
CGFloat RLG_ScreenWidth(void);
CGFloat RLG_ScreenHeight(void);
CGFloat RLG_NaviBarHeight(UIViewController *vc);

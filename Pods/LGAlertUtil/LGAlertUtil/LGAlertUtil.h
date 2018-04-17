//
//  LGAlertUtil.h
//  LGAlertUtilDemo
//
//  Created by 刘亚军 on 2018/4/11.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LGAlert [LGAlertUtil shareInstance]
@interface LGAlertUtil : NSObject
+ (LGAlertUtil *)shareInstance;
/** 风格设置 */
- (void)config;

/** AlertView */


/** 1、默认按钮标题 */

/** 1.1、图标代替标题 */
- (void)alertWarningWithMessage:(NSString *) msg
                   confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertWarningWithMessage:(NSString *) msg
                    cancelBlock:(void (^)(void)) cancelBlock
                   confirmBlock:(void (^)(void)) confirmBlock;

- (void)alertTipWithMessage:(NSString *) msg
               confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertTipWithMessage:(NSString *) msg
                    cancelBlock:(void (^)(void)) cancelBlock
                   confirmBlock:(void (^)(void)) confirmBlock;

- (void)alertSuccessWithMessage:(NSString *) msg
               confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertSuccessWithMessage:(NSString *) msg
                cancelBlock:(void (^)(void)) cancelBlock
               confirmBlock:(void (^)(void)) confirmBlock;

/** 1.2、自定义标题 */
- (void)alertWithTitle:(NSString *) title
               message:(NSString *) msg
          confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertWithTitle:(NSString *) title
               message:(NSString *) msg
           cancelBlock:(void (^)(void)) cancelBlock
          confirmBlock:(void (^)(void)) confirmBlock;

/** 2、自定义按钮标题 */
/** 2.1、图标代替标题 */
- (void)alertWarningWithMessage:(NSString *) msg
                   confirmTitle:(NSString *) confirmTitle
                   confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertWarningWithMessage:(NSString *) msg
                     canceTitle:(NSString *) canceTitle
                   confirmTitle:(NSString *) confirmTitle
                    cancelBlock:(void (^)(void)) cancelBlock
                   confirmBlock:(void (^)(void)) confirmBlock;

- (void)alertTipWithMessage:(NSString *) msg
               confirmTitle:(NSString *) confirmTitle
               confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertTipWithMessage:(NSString *) msg
                 canceTitle:(NSString *) canceTitle
               confirmTitle:(NSString *) confirmTitle
                cancelBlock:(void (^)(void)) cancelBlock
               confirmBlock:(void (^)(void)) confirmBlock;

/** 2.2、自定义标题 */
- (void)alertWithTitle:(NSString *) title
               message:(NSString *) msg
          confirmTitle:(NSString *) confirmTitle
          confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertWithTitle:(NSString *) title
               message:(NSString *) msg
            canceTitle:(NSString *) canceTitle
          confirmTitle:(NSString *) confirmTitle
           cancelBlock:(void (^)(void)) cancelBlock
          confirmBlock:(void (^)(void)) confirmBlock;
- (void)alertWithTitle:(NSString *) title
          attributeMsg:(NSAttributedString *) attributeMsg
            canceTitle:(NSString *) canceTitle
          confirmTitle:(NSString *) confirmTitle
           cancelBlock:(void (^)(void)) cancelBlock
          confirmBlock:(void (^)(void)) confirmBlock;



/** ActionSheet */

/** 固定两个按钮（YES，NO） */
- (void)alertSheetWithTitle:(NSString *) title
                    message:(NSString *) msg
                 canceTitle:(NSString *)canceTitle
               confirmTitle:(NSString *) confirmTitle
                cancelBlock:(void (^)(void)) cancelBlock
               confirmBlock:(void (^)(void)) confirmBlock
               atController:(UIViewController *) controller;
/** 多个按钮（YES，fun1,fun2...） */
- (void)alertSheetWithTitle:(NSString *) title
                    message:(NSString *) msg
                 canceTitle:(NSString *) canceTitle
               buttonTitles:(NSArray *)buttonTitles
                buttonBlock:(void (^) (NSInteger index)) buttonBlock
               cancelBlock:(void (^)(void)) cancelBlock
               atController:(UIViewController *) controller;

/** HUD */
/** 菊花 */
- (void)showIndeterminate;
- (void)showIndeterminateWithStatus:(NSString *) status;

/** 成功 */
- (void)showSuccessWithStatus:(NSString *) status;
/** 失败 */
- (void)showErrorWithStatus:(NSString *) status;
- (void)showErrorWithError:(NSError *) error;
/** 警告 */
- (void)showInfoWithStatus:(NSString *) status;

/** 文字提示 */
- (void)showStatus:(NSString *) status;
- (void)showRedStatus:(NSString *) status;

/** 进度条 */
- (void)showBarDeterminateWithProgress:(CGFloat) progress;
- (void)showBarDeterminateWithProgress:(CGFloat) progress status:(NSString *)status;

/** 隐藏 */
- (void)hide;
@end

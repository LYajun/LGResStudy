//
//  LGAlertUtil.m
//  LGAlertUtilDemo
//
//  Created by 刘亚军 on 2018/4/11.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGAlertUtil.h"
#import "YJAlertView.h"
#import "LGProgressHUD.h"

@interface LGAlertUtil ()
{
    LGProgressHUD *_hud;
    NSString *_cancelTitle;
    NSString *_confirmTitle;
}
@end
@implementation LGAlertUtil
+ (LGAlertUtil *)shareInstance{
    static LGAlertUtil * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGAlertUtil alloc]init];
    });
    return macro;
}
#pragma mark - public
- (void)config{
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
}
- (void)alertWarningWithMessage:(NSString *)msg confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_warn" message:msg canceTitle:nil confirmTitle:_confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertWarningWithMessage:(NSString *)msg cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_warn" message:msg canceTitle:_cancelTitle confirmTitle:_confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}
- (void)alertTipWithMessage:(NSString *)msg confirmBlock:(void (^)(void))confirmBlock{
     [self alertWithIconName:@"lg_tip" message:msg canceTitle:nil confirmTitle:_confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertTipWithMessage:(NSString *)msg cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_tip" message:msg canceTitle:_cancelTitle confirmTitle:_confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}
- (void)alertSuccessWithMessage:(NSString *)msg confirmBlock:(void (^)(void))confirmBlock{
     [self alertWithIconName:@"lg_success" message:msg canceTitle:nil confirmTitle:_confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertSuccessWithMessage:(NSString *)msg cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_success" message:msg canceTitle:_cancelTitle confirmTitle:_confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}

- (void)alertWithIconName:(NSString *) name message:(NSString *)msg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    YJAlertView *alertView = [[YJAlertView alloc] initWithViewAndTitle:nil message:nil style:YJAlertViewStyleAlert view:view buttonTitles:nil cancelButtonTitle:canceTitle destructiveButtonTitle:confirmTitle actionHandler:nil cancelHandler:^(YJAlertView * _Nonnull alertView) {
        if (cancelBlock) {
            cancelBlock();
        }
    } destructiveHandler:^(YJAlertView * _Nonnull alertView) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    view.frame = CGRectMake(0, 0, alertView.width, 90);
    UIImageView *imgCaution = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, alertView.width, 30)];
    imgCaution.image = [UIImage imageNamed:LG_GETBundleResource(name)];
    imgCaution.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgCaution];
    CGFloat labMsgWidth = alertView.width-20;
    CGFloat labMsgY = CGRectGetMaxY(imgCaution.frame) + 8;
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, labMsgY, labMsgWidth, view.frame.size.height - labMsgY)];
    labMsg.numberOfLines = 0;
    labMsg.textAlignment = NSTextAlignmentCenter;
    labMsg.font = [YJAlertView appearance].messageFont;
    labMsg.textColor = [YJAlertView appearance].messageTextColor;
    labMsg.text = msg;
    [view addSubview:labMsg];
    [alertView showAnimated];
}
- (void)alertWithTitle:(NSString *)title message:(NSString *)msg confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithTitle:title message:msg canceTitle:nil confirmTitle:_confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertWithTitle:(NSString *)title message:(NSString *)msg cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithTitle:title message:msg canceTitle:_cancelTitle confirmTitle:_confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}

- (void)alertWarningWithMessage:(NSString *)msg confirmTitle:(NSString *)confirmTitle confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_warn" message:msg canceTitle:nil confirmTitle:confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertWarningWithMessage:(NSString *)msg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_warn" message:msg canceTitle:canceTitle confirmTitle:confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}
- (void)alertTipWithMessage:(NSString *)msg confirmTitle:(NSString *)confirmTitle confirmBlock:(void (^)(void))confirmBlock{
     [self alertWithIconName:@"lg_tip" message:msg canceTitle:nil confirmTitle:confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertTipWithMessage:(NSString *)msg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithIconName:@"lg_tip" message:msg canceTitle:canceTitle confirmTitle:confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
}
- (void)alertWithTitle:(NSString *)title message:(NSString *)msg confirmTitle:(NSString *)confirmTitle confirmBlock:(void (^)(void))confirmBlock{
    [self alertWithTitle:title message:msg canceTitle:nil confirmTitle:confirmTitle cancelBlock:nil confirmBlock:confirmBlock];
}
- (void)alertWithTitle:(NSString *)title message:(NSString *)msg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    [[[YJAlertView alloc]initWithTitle:title message:msg style:YJAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:canceTitle destructiveButtonTitle:confirmTitle actionHandler:nil cancelHandler:^(YJAlertView *alertView) {
        if (cancelBlock) {
            cancelBlock();
        }
    } destructiveHandler:^(YJAlertView *alertView) {
        if (confirmBlock) {
            confirmBlock();
        }
    }] showAnimated];
}
- (void)alertWithTitle:(NSString *)title attributeMsg:(NSAttributedString *)attributeMsg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock{
    UITextView *textView = [UITextView new];
    YJAlertView *alertView = [[YJAlertView alloc] initWithViewAndTitle:title message:nil style:YJAlertViewStyleAlert view:textView buttonTitles:nil cancelButtonTitle:canceTitle destructiveButtonTitle:confirmTitle actionHandler:nil cancelHandler:^(YJAlertView * _Nonnull alertView) {
        if (cancelBlock) {
            cancelBlock();
        }
    } destructiveHandler:^(YJAlertView * _Nonnull alertView) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    textView.frame = CGRectMake(0, 0, alertView.width-10, [UIScreen mainScreen].bounds.size.height*0.3);
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.selectable = NO;
    textView.font = [YJAlertView appearance].messageFont;
    textView.textColor = [YJAlertView appearance].messageTextColor;
    textView.attributedText = attributeMsg;
    [alertView showAnimated];
}

- (void)alertSheetWithTitle:(NSString *)title message:(NSString *) msg canceTitle:(NSString *)canceTitle confirmTitle:(NSString *)confirmTitle cancelBlock:(void (^)(void))cancelBlock confirmBlock:(void (^)(void))confirmBlock atController:(UIViewController *)controller{
    if (LGA_IsIpad()) {
        [self alertWithTitle:title message:msg canceTitle:canceTitle confirmTitle:confirmTitle cancelBlock:cancelBlock confirmBlock:confirmBlock];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmBlock) {
                confirmBlock();
            }
        }];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:canceTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelButton];
        [alertController addAction:confirmButton];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)alertSheetWithTitle:(NSString *)title message:(NSString *) msg canceTitle:(NSString *)canceTitle buttonTitles:(NSArray *)buttonTitles buttonBlock:(void (^)(NSInteger))buttonBlock cancelBlock:(void (^)(void))cancelBlock atController:(UIViewController *)controller{
    if (LGA_IsIpad()) {
        [[[YJAlertView alloc]initWithTitle:title message:msg style:YJAlertViewStyleAlert buttonTitles:buttonTitles cancelButtonTitle:canceTitle destructiveButtonTitle:nil actionHandler:^(YJAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if (buttonBlock) {
                buttonBlock(index);
            }
        } cancelHandler:^(YJAlertView * _Nonnull alertView) {
            if (cancelBlock) {
                cancelBlock();
            }
        } destructiveHandler:nil] showAnimated];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:canceTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelButton];
        for (int i = 0; i < buttonTitles.count; i++) {
            NSString *btnTitle = buttonTitles[i];
            UIAlertAction *button = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (buttonBlock) {
                    buttonBlock(i);
                }
            }];
            [alertController addAction:button];
        }
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - HUD
- (void)showIndeterminate{
    [self showIndeterminateWithStatus:nil];
}
- (void)showIndeterminateWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    if (status) {
        _hud.detailsLabelText = status;
    }else{
        _hud.detailsLabelText = @"请稍等...";
    }
}
- (void)showSuccessWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = LGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:LG_GETBundleResource(@"lg_hud_success")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showErrorWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = LGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:LG_GETBundleResource(@"lg_hud_error")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
     [_hud hide:YES afterDelay:2.0f];
}
- (void)showErrorWithError:(NSError *)error{
    NSString *errorDesc = error.localizedDescription;
    if (!errorDesc || errorDesc.length == 0) {
        errorDesc = @"未知错误";
    }
    [self showErrorWithStatus:errorDesc];
}
- (void)showInfoWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = LGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:LG_GETBundleResource(@"lg_hud_warning")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = LGProgressHUDModeText;
    _hud.detailsLabelText = status;
    _hud.yOffset = ([UIScreen mainScreen].bounds.size.height -64)/2 - 100;
     [_hud hide:YES afterDelay:2.0f];
}
- (void)showRedStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = LGProgressHUDModeText;
    _hud.detailsLabelText = status;
     _hud.detailsLabelColor = [UIColor redColor];
    _hud.yOffset = ([UIScreen mainScreen].bounds.size.height -64)/2 - 100;
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showBarDeterminateWithProgress:(CGFloat)progress{
    [self showBarDeterminateWithProgress:progress status:@"上传中..."];
}
- (void)showBarDeterminateWithProgress:(CGFloat)progress status:(NSString *)status{
    if (_hud && _hud.mode != LGProgressHUDModeDeterminateHorizontalBar) {
        [self hide];
    }
    if (!_hud) {
        _hud = [LGProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
        _hud.detailsLabelText = status;
        _hud.mode = LGProgressHUDModeDeterminateHorizontalBar;
    }
    _hud.progress = progress;
    if (progress >= 1) {
        _hud.detailsLabelText = @"已完成";
        [self hide];
    }
}
- (void)hide{
    [_hud hide:YES];
    _hud = nil;
}
#pragma mark - private
- (UIView *)keyWindow{
    return [[[UIApplication sharedApplication] delegate] window];
}
BOOL LGA_IsIpad(){
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}
UIColor *LGA_Color(NSInteger hex){
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
NSString *LG_GETBundleResource(NSString *fileName){
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/LGAlertUtil.framework/LGAlertUtil.bundle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGAlertUtil.bundle"];
    }
    NSBundle *resoureBundle = [NSBundle bundleWithPath:bundlePath];
    if (resoureBundle && fileName){
        NSString * bundlePath = [[resoureBundle resourcePath] stringByAppendingPathComponent:fileName];
        return bundlePath;
    }
    return nil ;
}
@end

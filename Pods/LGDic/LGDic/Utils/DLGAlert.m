//
//  DLGAlert.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGAlert.h"
#import "DLGProgressHUD.h"
#import "DLGCommon.h"

@interface DLGAlert ()
{
    DLGProgressHUD *_hud;
}
@end
@implementation DLGAlert
+ (DLGAlert *)shareInstance{
    static DLGAlert * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[DLGAlert alloc]init];
    });
    return macro;
}
- (void)showIndeterminate{
    [self showIndeterminateWithStatus:nil];
}
- (void)showIndeterminateWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [DLGProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    if (status) {
        _hud.detailsLabelText = status;
    }else{
        _hud.detailsLabelText = @"请稍等...";
    }
}
- (void)showStatus:(NSString *)Status{
    if (_hud) {
        [self hide];
    }
    _hud = [DLGProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = DLGProgressHUDModeText;
    _hud.detailsLabelText = Status;
    _hud.yOffset = ([UIScreen mainScreen].bounds.size.height -64)/2 - 100;
    [_hud hide:YES afterDelay:2.f];
    
}
- (void)showSuccessWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [DLGProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = DLGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:DLG_GETBundleResource(@"lg_hud_success")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [_hud hide:YES afterDelay:2.f];
}
- (void)showErrorWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [DLGProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = DLGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:DLG_GETBundleResource(@"lg_hud_error")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [_hud hide:YES afterDelay:2.f];
}
- (void)showInfoWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [DLGProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = DLGProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:DLG_GETBundleResource(@"lg_hud_warning")] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [_hud hide:YES afterDelay:2.f];
}
- (void)hide{
    [_hud hide:YES];
    _hud = nil;
}
- (UIView *)currentView{
    return [[UIApplication sharedApplication].delegate window];
}
@end

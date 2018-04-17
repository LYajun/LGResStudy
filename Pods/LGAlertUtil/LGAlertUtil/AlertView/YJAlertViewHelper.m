//
//  YJAlertViewHelper.m
//  YJAlertView
//
//
//

#import "YJAlertViewHelper.h"
#import "YJAlertView.h"

#pragma mark - Constants

CGFloat const YJAlertViewPaddingWidth = 10.0;
CGFloat const YJAlertViewPaddingHeight = 8.0;
CGFloat const YJAlertViewButtonImageOffsetFromTitle = 8.0;

#pragma mark - Implementation

@implementation YJAlertViewHelper

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations {
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? CGRectGetHeight([notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]) : 0.0);

    if (!keyboardHeight) return;

    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (animations) {
        animations(keyboardHeight);
    }

    [UIView commitAnimations];
}

+ (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;

    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (BOOL)isNotRetina {
    static BOOL isNotRetina;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        isNotRetina = (UIScreen.mainScreen.scale == 1.0);
    });

    return isNotRetina;
}

+ (BOOL)isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (CGFloat)statusBarHeight {
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    return sharedApplication.isStatusBarHidden ? 0.0 : CGRectGetHeight(sharedApplication.statusBarFrame);
}

+ (CGFloat)separatorHeight {
    return self.isNotRetina ? 1.0 : 0.5;
}

+ (BOOL)isPadAndNotForce:(YJAlertView *)alertView {
    return self.isPad && !alertView.isPadShowsActionSheetFromBottom;
}

+ (BOOL)isCancelButtonSeparate:(YJAlertView *)alertView {
    return alertView.style == YJAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.0 && ![self isPadAndNotForce:alertView];
}

+ (CGFloat)systemVersion {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

+ (UIWindow *)appWindow {
    return [UIApplication sharedApplication].windows[0];
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (BOOL)isViewControllerBasedStatusBarAppearance {
    static BOOL isViewControllerBasedStatusBarAppearance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
            isViewControllerBasedStatusBarAppearance = YES;
        }
        else {
            NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
            isViewControllerBasedStatusBarAppearance = (viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue);
        }
    });

    return isViewControllerBasedStatusBarAppearance;
}

@end

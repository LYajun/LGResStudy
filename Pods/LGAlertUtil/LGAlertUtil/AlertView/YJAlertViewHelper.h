//
//  YJAlertViewHelper.h
//  YJAlertView
//
//
//

#import <UIKit/UIKit.h>

@class YJAlertView;

#pragma mark - Constants

extern CGFloat const YJAlertViewPaddingWidth;
extern CGFloat const YJAlertViewPaddingHeight;
extern CGFloat const YJAlertViewButtonImageOffsetFromTitle;

#pragma mark - Interface

@interface YJAlertViewHelper : NSObject

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion;

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations;

+ (UIImage *)image1x1WithColor:(UIColor *)color;

+ (BOOL)isNotRetina;

+ (BOOL)isPad;

+ (CGFloat)statusBarHeight;

+ (CGFloat)separatorHeight;

+ (BOOL)isPadAndNotForce:(YJAlertView *)alertView;

+ (BOOL)isCancelButtonSeparate:(YJAlertView *)alertView;

+ (CGFloat)systemVersion;

+ (UIWindow *)appWindow;
+ (UIWindow *)keyWindow;

+ (BOOL)isViewControllerBasedStatusBarAppearance;

@end

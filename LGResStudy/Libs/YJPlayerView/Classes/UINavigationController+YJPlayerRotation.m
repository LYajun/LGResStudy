//
//  UINavigationController+YJPlayerRotation.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/15.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "UINavigationController+YJPlayerRotation.h"

@implementation UINavigationController (YJPlayerRotation)
/**
 * 如果window的根视图是UINavigationController，则会先调用这个Category，然后调用UIViewController+YJPlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end

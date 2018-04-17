//
//  UIWindow+YJAlertView.h
//  YJAlertView
//
//
//

#import "UIWindow+YJAlertView.h"

@implementation UIWindow (YJAlertView)

- (nullable UIViewController *)currentViewController {
    UIViewController *viewController = self.rootViewController;

    if (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

@end

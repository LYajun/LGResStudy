//
//  YJAlertViewWindowContainer.h
//  YJAlertView
//
//
//

#import <UIKit/UIKit.h>

@interface YJAlertViewWindowContainer : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;

+ (instancetype)containerWithWindow:(UIWindow *)window;

@property (weak, nonatomic) UIWindow *window;

@end

//
//  YJAlertViewWindowsObserver.h
//  YJAlertView
//
//
//

#import <UIKit/UIKit.h>

@interface YJAlertViewWindowsObserver : NSObject

+ (instancetype)sharedInstance;

- (void)startObserving;

@end

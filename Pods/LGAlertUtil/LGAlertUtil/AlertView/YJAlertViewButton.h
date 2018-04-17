//
//  YJAlertViewButton.h
//  YJAlertView
//
//
//

#import <UIKit/UIKit.h>
#import "YJAlertViewShared.h"

@interface YJAlertViewButton : UIButton

@property (assign, nonatomic) YJAlertViewButtonIconPosition iconPosition;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end

//
//  YJAlertViewWindowContainer.m
//  YJAlertView
//
//
//

#import "YJAlertViewWindowContainer.h"

@implementation YJAlertViewWindowContainer

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

+ (instancetype)containerWithWindow:(UIWindow *)window {
    return [[self alloc] initWithWindow:window];
}

@end

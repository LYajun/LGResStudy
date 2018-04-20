//
//  DLGAlert.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGAlert : NSObject
+ (DLGAlert *)shareInstance;
- (void)showIndeterminate;
- (void)showIndeterminateWithStatus:(NSString *)status;
- (void)showStatus:(NSString *)Status;
- (void)showSuccessWithStatus:(NSString *)status;
- (void)showErrorWithStatus:(NSString *)status;
- (void)showInfoWithStatus:(NSString *)status;
- (void)hide;
@end

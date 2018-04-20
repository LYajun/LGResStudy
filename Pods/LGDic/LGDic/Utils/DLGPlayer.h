//
//  DLGPlayer.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGPlayer : NSObject
+ (DLGPlayer *)shareInstance;
- (void)play;
- (void)stop;
- (void)startPlayWithUrl:(NSString *) url;
@end

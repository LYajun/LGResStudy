//
//  KYRecorder.h
//  KouyuDemo
//
//  Created by Attu on 2017/12/26.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "skegn.h"

typedef void(^KYRecorderBlock)(struct skegn *engine, const void *audioData, int size);

@interface KYRecorder : NSObject

- (int)startReocrdWith:(NSString *)wavPath engine:(struct skegn *)engine callbackInterval:(NSInteger)interval recorderBlock:(KYRecorderBlock)recorderBlock;

- (void)stopRecorder;

- (void)playback;

@end

//
//  RLGVoiceOperateView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGStudyOperateView.h"
@class RLGResModel;
@interface RLGVoiceOperateView : RLGStudyOperateView
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,assign) BOOL isNeedRecord;
@property (nonatomic,copy) void (^PlayIndexBlock) (NSInteger index);
@property (nonatomic,copy) void (^MicroClickBlock) (void);
@property (nonatomic,copy) void (^PlayRecordIndexBlock) (NSInteger index);
- (void)setCurrentPlayIndex:(NSInteger) index;
- (instancetype)initWithFrame:(CGRect)frame voiceUrl:(NSString *) voiceUrl;
- (void)stopPlay;
- (void)play;
- (void)pause;
- (void)updateInfo;
- (void)resetSetup;
@end

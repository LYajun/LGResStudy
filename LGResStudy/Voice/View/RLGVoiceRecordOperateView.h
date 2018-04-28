//
//  RLGVoiceRecordOperateView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGStudyOperateView.h"

@interface RLGVoiceRecordOperateView : RLGStudyOperateView

@property (nonatomic,copy) void (^RecordIndexBlock) (NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame totalRecordNum:(NSInteger) totalRecordNum;
- (void)setCurrentRecordIndex:(NSInteger) index;

@end

//
//  RLGVideoDubOperateView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/5/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGStudyOperateView.h"

@interface RLGVideoDubOperateView : RLGStudyOperateView
@property (nonatomic,copy) void (^dubIndexBlock) (NSInteger index);
@property (nonatomic,copy) void (^previewBlock) (void);
/** 是否可以预览 */
@property (nonatomic,assign) BOOL previewEnable;
- (instancetype)initWithFrame:(CGRect)frame totalDubNum:(NSInteger) totalDubNum;
@end

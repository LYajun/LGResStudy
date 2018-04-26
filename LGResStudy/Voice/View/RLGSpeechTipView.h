//
//  RLGSpeechTipView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/26.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RLGSpeechTipView : UIView
@property (nonatomic,copy) void (^speechFinishBlock) (void);
- (instancetype)initWithFrame:(CGRect)frame refText:(NSString *) refText recordTime:(NSInteger) recordTime;
@end

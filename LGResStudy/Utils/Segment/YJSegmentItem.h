//
//  YJSegmentItem.h
//  LGSegment
//
//  Created by 刘亚军 on 2017/4/9.
//  Copyright © 2017年 LiGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJSegmentItem : UIView
@property (nonatomic,assign) BOOL isSelect;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *) title selectColor:(UIColor *) selectColor norColor:(UIColor *) norColor;
- (void)clickEventBlock:(void (^) (void)) block;
@end

//
//  YJDynamicSegment.h
//  LGSegment
//
//  Created by 刘亚军 on 2017/4/9.
//  Copyright © 2017年 LiGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJDynamicSegment;
@protocol YJDynamicSegmentDelegate <NSObject>
@optional
- (void)yj_dynamicSegment:(YJDynamicSegment *) dynamicSegment didSelectItemAtIndex:(NSInteger)index;
@end
@interface YJDynamicSegment : UIView
@property (nonatomic,strong) NSArray *viewControllers;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) float titleViewHeight;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,assign) NSInteger pageItems;
@property (nonatomic,assign) id<YJDynamicSegmentDelegate> delegate;
@end

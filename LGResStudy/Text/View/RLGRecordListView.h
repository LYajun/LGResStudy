//
//  RLGRecordListView.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLGRecordListView : UIView
@property (nonatomic,copy) void (^DismissBlock) (void);

+ (instancetype)showRecordListView;
@end

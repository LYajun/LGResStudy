//
//  RLGTapTableView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTapTableView.h"
@interface RLGTapTableView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIView *wTouchView;
}
@end
@implementation RLGTapTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longAction)];
        longPress.delegate = self;
        [self addGestureRecognizer:longPress];
    }
    return self;
}
- (void)longAction{
    if (wTouchView) {
        [self touchCellIndex:wTouchView.tag];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"RLGTextView"]) {
        wTouchView = touch.view;
    }
    return  YES;
}
- (void)touchCellIndex:(NSInteger)index{    
}
@end

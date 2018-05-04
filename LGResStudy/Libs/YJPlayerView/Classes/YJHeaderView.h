//
//  YJHeaderView.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/13.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YJHeaderViewDelegate <NSObject>
@optional
- (void)backBtnDidClick;
@end
@interface YJHeaderView : UIView
/** 是否全屏模式 */
@property (nonatomic,assign) BOOL isFullScreen;
/** 是否正在显示 */
@property (nonatomic,assign) BOOL isShowing;
/** 是否隐藏返回按钮 */
@property (nonatomic,assign) BOOL isHideBakcBtn;
/** 标题 */
@property (nonatomic,copy) NSString *videoTitle;

@property (nonatomic,assign) id<YJHeaderViewDelegate> delegate;

- (void)show;
- (void)hide;
@end

//
//  YJOrientationView.h
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/15.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPlayModel.h"
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
@interface YJBasePlayerView : UIView
@property (nonatomic, strong) YJPlayModel *playModel;
/** 父视图 */
@property (nonatomic,weak) UIView *fatherView;
/** 是否是全屏 */
@property(nonatomic,assign) BOOL isFullScreen;
/** 是否是用户手动全屏 */
@property(nonatomic,assign) BOOL isFullScreenByUser;
/** 自动选择开关 */
@property (nonatomic,assign) BOOL autoRotationDisable;
/** 系统音量 */
@property (nonatomic,assign) CGFloat volumeValue;
/** 用户手动旋转 */
- (void)userRotationAction;
/** 手动旋转 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;
/**销毁播放器*/
-(void)destroyPlayer;
/** 点击手势 */
- (void)singleTap:(UITapGestureRecognizer *)tap;
/** 双击手势 */
-(void)doubleTap:(UITapGestureRecognizer *)tap;
/** 平移手势 */
-(void)panDirection:(UIPanGestureRecognizer *)pan;
/** 平移手势开关 */
@property (nonatomic,assign) BOOL panEnable;
/** 相关通知方法 */
- (void)appDidEnterBackground:(NSNotification *)note;
- (void)appDidEnterPlayground:(NSNotification *)note;
@end

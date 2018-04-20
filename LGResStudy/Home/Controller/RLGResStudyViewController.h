//
//  LGResStudyViewController.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RLGResStudyViewController : UIViewController


- (void)setViewLoadingShow:(BOOL)show;
@property (nonatomic,copy) NSString *noDataText;
- (void)setViewNoDataShow:(BOOL)show;
- (void)setViewLoadErrorShow:(BOOL)show;
@end

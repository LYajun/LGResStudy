//
//  RLGWordCell.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/22.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLGWordCell : UITableViewCell
@property (nonatomic,strong) id wordSenModel;
@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,copy) void (^PlayBlock) (void);
- (void)stop;
@end

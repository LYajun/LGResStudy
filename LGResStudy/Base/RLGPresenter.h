//
//  LGPresenter.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLGPresenter : NSObject
@property (nonatomic,weak) id view;
- (instancetype)initWithView:(id) view;
- (void)bindView:(id) view;
- (void)unbindView;
@end

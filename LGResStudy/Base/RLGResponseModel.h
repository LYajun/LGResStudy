//
//  LGResponseModel.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLGResponseModel : NSObject
/** 状态 */
@property (nonatomic,assign) NSInteger Status;
/** 状态描述 */
@property (nonatomic,copy) NSString *StatusDescription;
/** 编码 */
@property (nonatomic,copy) NSString *ContentEncoding;
/** 类型 */
@property (nonatomic,copy) NSString *ContentType;
/** 数据 */
@property (nonatomic,strong) id Data;
@end

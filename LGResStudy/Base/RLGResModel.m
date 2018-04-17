//
//  LGResModel.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGResModel.h"
@implementation RLGResVideoModel

@end
@implementation RLGResContentModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"VideoTrainSynInfo":[RLGResVideoModel class]};
}
@end
@implementation RLGResModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Reslist":[RLGResContentModel class]};
}
@end

//
//  LGResModel.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGResModel.h"
#import "RLGCommon.h"

@implementation RLGResVideoModel

@end
@implementation RLGResContentModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"VideoTrainSynInfo":[RLGResVideoModel class]};
}
- (void)setResContent:(NSString *)ResContent{
    _ResContent = ResContent;
    _ResContent_attr = RLG_AttributedString(ResContent, 16);
}
@end
@implementation RLGResModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Reslist":[RLGResContentModel class]};
}
- (RLGResType)rlgResType{
    switch (self.ResType.integerValue) {
        case 1:
            return text;
            break;
        case 5:
            return voice;
            break;
        case 6:
            return video;
            break;
        default:
            return unknow;
            break;
    }
}
- (NSArray *)rlgSegmentTitles{
    switch (self.rlgResType) {
        case text:
            return @[@"浏览",@"人工朗读"];
            break;
        case voice:
            return @[@"泛听",@"跟读"];
            break;
        case video:
            return @[@"浏览",@"配音"];
            break;
        default:
            return @[@"--",@"--"];
            break;
    }
}
- (NSArray *)rlgImporKnTexts{
    if (self.ImporKnText && self.ImporKnText.length > 0) {
        return [self.ImporKnText componentsSeparatedByString:@"|"];
    }
    return nil;
}
@end

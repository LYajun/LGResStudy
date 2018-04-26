//
//  LGResModel.h
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RLGResType){
    text,           // 文本类
    voice,          // 声文类
    video,          // 视文类
    unknow          // 不支持类
};


@interface RLGResVideoModel : NSObject
@property (nonatomic,copy) NSString *SenID;
@property (nonatomic,copy) NSString *OrgID;
@property (nonatomic,copy) NSString *TraID;
@property (nonatomic,copy) NSString *Starttime;
@property (nonatomic,copy) NSString *Timelength;
@property (nonatomic,copy) NSString *Ehtml;
@property (nonatomic,copy) NSString *Chtml;
@property (nonatomic,copy) NSString *Etext;
@property (nonatomic,strong) NSMutableAttributedString *Etext_attr;
@property (nonatomic,copy) NSString *Ctext;
@end

@interface RLGResContentModel : NSObject
@property (nonatomic,copy) NSString *ResContent;
@property (nonatomic,strong) NSMutableAttributedString *ResContent_attr;
@property (nonatomic,copy) NSString *ResTranContent;
@property (nonatomic,copy) NSString *ResMediaPath;
@property (nonatomic,copy) NSString *ResMediaLength;
@property (nonatomic,strong) NSArray<RLGResVideoModel *> *VideoTrainSynInfo;
@end


@interface RLGResModel : NSObject
@property (nonatomic,copy) NSString *ResCode;
@property (nonatomic,copy) NSString *ResName;
@property (nonatomic,copy) NSString *IconPath;
@property (nonatomic,copy) NSString *ResType;
@property (nonatomic,copy) NSString *StoreDate;
@property (nonatomic,copy) NSString *SpecicalCode;
@property (nonatomic,copy) NSString *SpecicalName;
@property (nonatomic,copy) NSString *ThemeCode;
@property (nonatomic,copy) NSString *ThemeText;
@property (nonatomic,copy) NSString *ImporKnCode;
@property (nonatomic,copy) NSString *ImporKnText;
@property (nonatomic,copy) NSString *MainKnCode;
@property (nonatomic,copy) NSString *MainKnText;
@property (nonatomic,copy) NSString *UnitNum;
@property (nonatomic,copy) NSString *ResClass;
@property (nonatomic,copy) NSString *ResLevel;
@property (nonatomic,copy) NSString *LibCode;
@property (nonatomic,copy) NSString *ResFtpPath;
@property (nonatomic,copy) NSString *IsExsitMedia;
@property (nonatomic,copy) NSString *IsDownload;
@property (nonatomic,copy) NSString *ResZipPackFile;
@property (nonatomic,copy) NSString *Uploadby;
@property (nonatomic,copy) NSString *ResDesc;

@property (nonatomic,assign) NSInteger IsCollect;
@property (nonatomic,assign) NSInteger StudyTime;

@property (nonatomic,strong) NSArray<RLGResContentModel *> *Reslist;

- (RLGResType)rlgResType;
- (NSArray *)rlgSegmentTitles;
- (NSArray *)rlgImporKnTexts;
@end

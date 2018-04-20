//
//  DLGWordModel.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SenCollectionModel : NSObject
@property (nonatomic, copy) NSString *sentenceEn;
@property (nonatomic, copy) NSString *sViocePath;
@property (nonatomic, copy) NSString *sTranslation;
//@property (nonatomic, strong,readonly) NSAttributedString *sentenceEn_attr; // 新增
//@property (nonatomic, strong,readonly) NSAttributedString *sTranslation_attr; // 新增
@end

@interface ColtCollectionModel : NSObject
@property (nonatomic,copy) NSString *coltEn;
@property (nonatomic,copy) NSString *coltCn;
//@property (nonatomic, strong,readonly) NSAttributedString *coltEn_attr; // 新增
//@property (nonatomic, strong,readonly) NSAttributedString *coltCn_attr; // 新增
@property (nonatomic,strong)NSArray<SenCollectionModel *> *senCollection;
@end

@interface RltCollectionModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *resource;
//@property (nonatomic, strong,readonly) NSAttributedString *title_attr; // 新增
//@property (nonatomic, strong,readonly) NSAttributedString *content_attr; // 新增
@end

@interface ClassicCollectionModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *resource;

//@property (nonatomic, strong,readonly) NSAttributedString *title_attr; // 新增
//@property (nonatomic, strong,readonly) NSAttributedString *content_attr; // 新增
@end


@interface MeanCollectionModel : NSObject
@property (nonatomic,copy) NSString *chineseMeaning;
@property (nonatomic,copy) NSString *englishMeaning;
//@property (nonatomic, strong,readonly) NSAttributedString *chineseMeaning_attr; // 新增
//@property (nonatomic, strong,readonly) NSAttributedString *englishMeaning_attr; // 新增
@property (nonatomic,strong)NSArray<ColtCollectionModel *> *coltCollection;
@property (nonatomic,strong)NSArray<RltCollectionModel *> *rltCollection;
@property (nonatomic,strong)NSArray<SenCollectionModel *> *senCollection;
@property (nonatomic,strong)NSArray<ClassicCollectionModel *> *classicCollection;
@end

@interface CxCollectionModel : NSObject
@property (nonatomic, copy) NSString *cxChinese;
@property (nonatomic, copy) NSString *cxEnglish;
@property (nonatomic, copy) NSString *morphology;
@property (nonatomic,strong)NSArray<MeanCollectionModel *> *meanCollection;
@end

@interface RLGWordModel : NSObject
@property (nonatomic, copy) NSString *unPVoice;
@property (nonatomic, copy) NSString *unPText;
@property (nonatomic, copy) NSString *cwName;
@property (nonatomic, copy) NSString *usPVoice;
@property (nonatomic, copy) NSString *usPText;
@property (nonatomic,strong)NSArray<CxCollectionModel *> *cxCollection;


- (NSString *)wordChineseMean;

@end

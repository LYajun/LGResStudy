//
//  DLGViewTransferProtocol.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RLGViewTransferProtocol <NSObject>

@optional
/** 数据刷新 */
- (void)updateData:(id) data;
/** 切换segment */
- (void)studyModelChangeAtIndex:(NSInteger) index;
/** 点击更多 */
- (void)clickNavBarMoreTool;
/** 点击重要知识点按钮 */
- (void)enterImportantWord;

/** 重要知识点查询 */
- (void)selectImporKnText:(NSString *) text;
- (void)updateWordModel:(id) wordModel;

/** 声文资料 */
- (void)playToIndex:(NSInteger) index;
- (void)speechDidFinish;
- (void)speechRecordDidDelete;

/** 视文资料 */
- (void)enterDubModel;
- (void)enterWordInquire;
@end

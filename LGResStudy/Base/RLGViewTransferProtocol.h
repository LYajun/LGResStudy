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
- (void)studyModelChangeAtIndex:(NSInteger) index;

/** 重要知识点查询 */
- (void)selectImporKnText:(NSString *) text;
- (void)updateWordModel:(id) wordModel;
@end

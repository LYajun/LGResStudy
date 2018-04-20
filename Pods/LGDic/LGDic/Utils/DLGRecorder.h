//
//  DLGRecorder.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGRecorder : NSObject
+ (DLGRecorder *)shareInstance;
- (NSInteger)recordCount;
- (NSArray *)recordList;
- (void)deleteRecordAtIndex:(NSInteger) index;
- (void)addRecordWithWord:(NSString *) word meaning:(NSString *) meaning;
@end

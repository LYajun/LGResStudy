//
//  DLGViewTransferProtocol.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGViewTransferProtocol <NSObject>

@optional
- (void)endEdit;
- (void)searchWord:(NSString *) word;
- (void)updateData:(id) data;
@end

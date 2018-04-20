//
//  DLGResultTableParseProtocol.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGResultTableParseProtocol <NSObject>

@optional
- (void)parseDidFinishWithResult:(id) result;
- (void)expandOrFoldAtIndex:(NSInteger) index;
- (void)allExpand:(BOOL) expand;

@end

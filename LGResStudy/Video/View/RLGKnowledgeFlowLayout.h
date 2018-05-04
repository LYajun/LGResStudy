//
//  RLGKnowledgeFlowLayout.h
//  YJWritting
//
//  Created by 刘亚军 on 16/8/23.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RLGKnowledgeFlowLayout;

@protocol RLGKnowledgeFlowLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(RLGKnowledgeFlowLayout *)collectionViewLayout
 widthForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(RLGKnowledgeFlowLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface RLGKnowledgeFlowLayout : UICollectionViewLayout
@property (nonatomic,assign) id<RLGKnowledgeFlowLayoutDelegate> delegate;
// 宽度
@property (nonatomic,assign)  CGFloat itemHeight;
// 顶部间距
@property (nonatomic) CGFloat topInset;
// 尾部间距
@property (nonatomic) CGFloat bottomInset;
// 分区头视图是否悬浮
@property (nonatomic) BOOL stickyHeader;
@end

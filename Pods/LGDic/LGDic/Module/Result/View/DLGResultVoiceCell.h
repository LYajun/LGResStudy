//
//  DLGResultVoiceCell.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGWordCategoryModel;
@interface DLGResultVoiceCell : UITableViewCell

- (void)setTextModel:(DLGWordCategoryModel *) textModel adIndexPath:(NSIndexPath *) indexPath;
@end

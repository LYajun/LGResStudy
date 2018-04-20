//
//  DLGResultTextCell.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGResultTextCell.h"
#import <Masonry/Masonry.h>
#import "DLGWordCategoryModel.h"
#import "DLGWordModel.h"

@interface DLGResultTextCell ()
@property (strong, nonatomic) UILabel *titleL;
@end
@implementation DLGResultTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [view addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.top.equalTo(view).offset(3);
    }];
}
- (void)setText:(NSAttributedString *)text{
    self.titleL.attributedText = text;
}
- (void)setTextModel:(DLGWordCategoryModel *)textModel adIndexPath:(NSIndexPath *)indexPath{
    switch (textModel.categoryType) {
        case DLGWordCategoryTypeColt:
        {
            SenCollectionModel *senModel = textModel.categoryList[indexPath.row];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:senModel.sentenceEn_attr];
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            [att appendAttributedString:senModel.sTranslation_attr];
            self.titleL.attributedText = att;
        }
            break;
        case DLGWordCategoryTypeClassic:
        {
            ClassicCollectionModel *classicModel = textModel.categoryList[indexPath.row];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:classicModel.title_attr];
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            [att appendAttributedString:classicModel.content_attr];
            self.titleL.attributedText = att;
        }
            break;
        case DDLGWordCategoryTypeRlt:
        {
            RltCollectionModel *rltModel = textModel.categoryList[indexPath.row];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:rltModel.title_attr];
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            [att appendAttributedString:rltModel.content_attr];
            self.titleL.attributedText = att;
        }
            break;
        default:
            break;
    }
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.numberOfLines = 0;
        _titleL.textColor = [UIColor darkGrayColor];
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
@end

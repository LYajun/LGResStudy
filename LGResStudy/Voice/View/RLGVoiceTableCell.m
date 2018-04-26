//
//  RLGVoiceTableCell.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceTableCell.h"
#import "RLGTextView.h"
#import <Masonry/Masonry.h>
#import "RLGCommon.h"

@interface RLGVoiceTableCell ()
@property (nonatomic,strong) RLGTextView *textView;
@end
@implementation RLGVoiceTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.top.equalTo(self.contentView).offset(0);
        }];
    }
    return self;
}
- (void)setIndex:(NSInteger)index{
    _index = index;
    self.textView.tag = index;
}
- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    UIColor *color = [UIColor darkGrayColor];
    if (isChoice) {
        color = [UIColor orangeColor];
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,attr.length)];
    self.textView.attributedText = attr;
}
- (void)setOwnController:(UIViewController<RLGViewTransferProtocol> *)ownController{
    _ownController = ownController;
    self.textView.ownController = ownController;
}
- (void)setTextAttribute:(NSMutableAttributedString *)textAttribute withImporKnTexts:(NSArray *)imporKnTexts{
    [self.textView setTextAttribute:textAttribute withImporKnTexts:imporKnTexts];
}
- (RLGTextView *)textView{
    if (!_textView) {
        _textView = [[RLGTextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
    }
    return _textView;
}
@end

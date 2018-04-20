//
//  DLGRecordCell.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGRecordCell.h"
#import <Masonry/Masonry.h>

@interface DLGRecordCell ()
@property (strong, nonatomic)UILabel *wordL;
@property (strong, nonatomic)UILabel *meanL;
@end
@implementation DLGRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.meanL];
    [self.meanL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(12);
    }];
    
    [self.contentView addSubview:self.wordL];
    [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.meanL.mas_top);
    }];
}
- (void)setWord:(NSString *)word{
    self.wordL.text = word;
}
- (void)setWordMeaning:(NSString *)wordMeaning{
    self.meanL.text = wordMeaning;
}
- (UILabel *)wordL{
    if (!_wordL) {
        _wordL = [UILabel new];
        _wordL.font = [UIFont systemFontOfSize:16];
        _wordL.textColor = [UIColor darkGrayColor];
    }
    return _wordL;
}
- (UILabel *)meanL{
    if (!_meanL) {
        _meanL = [UILabel new];
        _meanL.font = [UIFont systemFontOfSize:12];
        _meanL.textColor = [UIColor lightGrayColor];
    }
    return _meanL;
}
@end

//
//  RLGVoiceTableHeader.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/25.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGVoiceTableHeader.h"
#import <Masonry/Masonry.h>

@interface RLGVoiceTableHeader ()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation RLGVoiceTableHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:20];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
@end

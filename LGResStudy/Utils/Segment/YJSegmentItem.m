//
//  YJSegmentItem.m
//  LGSegment
//
//  Created by 刘亚军 on 2017/4/9.
//  Copyright © 2017年 LiGo. All rights reserved.
//

#import "YJSegmentItem.h"
#import "Masonry.h"

@interface YJSegmentItem ()
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,copy) void (^block) (void);
@end
@implementation YJSegmentItem
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *) title selectColor:(UIColor *) selectColor norColor:(UIColor *) norColor{
    if (self = [super initWithFrame:frame]) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn setTitle:title forState:UIControlStateNormal];
        [self.btn setTitleColor:norColor forState:UIControlStateNormal];
        [self.btn setTitleColor:selectColor forState:UIControlStateSelected];
        //新增字体大小0919
        self.btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.left.equalTo(self).mas_offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(2);
        }];
        self.line = [UIView new];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_offset(2);
        }];
         self.line.layer.cornerRadius = 1;
         self.line.layer.masksToBounds = YES;
        self.line.hidden = YES;
        self.line.backgroundColor = selectColor;
    }
    return self;
}
- (void)buttonClick{
    if (self.block) {
        self.block();
    }
}
- (void)clickEventBlock:(void (^)(void))block{
    _block = block;
}
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.btn.selected = _isSelect;
    self.line.hidden = !_isSelect;
}
@end

//
//  RLGTipButton.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/19.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTipButton.h"
#import <Masonry/Masonry.h>

@interface RLGTipView : UIView

@end
@implementation RLGTipView
- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat radiu = rect.size.height/2;
    // 设置颜色
    [[UIColor redColor] setFill];
    // 圆
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(radiu, radiu) radius:radiu startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [arcPath addArcWithCenter:CGPointMake(width - radiu, radiu) radius:radiu startAngle:0 endAngle:M_PI*2 clockwise:YES];
    // 填充
    [arcPath fill];
    // 矩形
    UIBezierPath* aPath = [UIBezierPath bezierPathWithRect:CGRectMake(radiu, 0, width - radiu*2, height)];
    // 填充
    [aPath fill];
}
@end
@interface RLGTipButton ()
@property (nonatomic,strong)UILabel *tipLab;
@property (nonatomic,strong)RLGTipView *tipView;
@end
@implementation RLGTipButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tipView];
        [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(3);
        }];
        [self.tipView addSubview:self.tipLab];
        [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tipView);
            make.height.mas_equalTo(15);
            make.width.mas_greaterThanOrEqualTo(15);
        }];
    }
    return self;
}
- (void)setTipEnable:(BOOL)tipEnable{
    _tipEnable = tipEnable;
    self.tipView.hidden = !tipEnable;
}
- (void)setTipCount:(NSInteger)tipCount{
    self.tipEnable = YES;
    self.tipLab.text = [NSString stringWithFormat:@"%li",tipCount];
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [UILabel new];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.font = [UIFont systemFontOfSize:10];
        _tipLab.textColor = [UIColor whiteColor];
    }
    return _tipLab;
}
- (RLGTipView *)tipView{
    if (!_tipView) {
        _tipView = [RLGTipView new];
        _tipView.backgroundColor = [UIColor clearColor];
    }
    return _tipView;
}
@end

//
//  RLGFlowLabelCell.m
//  FlowLayoutLabel
//
//  Created by 刘亚军 on 16/5/24.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import "RLGFlowLabelCell.h"
#import <Masonry/Masonry.h>
#import "RLGCommon.h"

@interface RLGFlowLabelCell ()
@property (strong, nonatomic) UILabel *contentL;
@end
@implementation RLGFlowLabelCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentL = [[UILabel alloc] init];
        self.contentL.textAlignment = NSTextAlignmentCenter;
        self.contentL.font = [UIFont systemFontOfSize:16];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor darkGrayColor];
        self.contentL.backgroundColor = RLG_Color(0xeceef7);
        [self.contentView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.contentL.layer.cornerRadius = 3;
        self.contentL.layer.masksToBounds = YES;
    }
    return self;
}
- (void)setText:(NSString *)text{
    _text = text;
    self.contentL.text = text;
}
@end

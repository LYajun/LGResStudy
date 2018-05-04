//
//  YJDynamicSegment.m
//  LGSegment
//
//  Created by 刘亚军 on 2017/4/9.
//  Copyright © 2017年 LiGo. All rights reserved.
//

#import "YJDynamicSegment.h"
#import "YJSegmentItem.h"
#import "Masonry.h"

@interface YJDynamicSegment ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *titleList;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *titleScrollView;

@end
@implementation YJDynamicSegment
- (void)setViewControllers:(NSArray *)viewControllers{
    _viewControllers = viewControllers;
    for (UIViewController *vc in viewControllers) {
        [self.titleList addObject:vc.title];
    }
    [self addItems];
    [self setContentScrollView];
}
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self.titleList addObjectsFromArray:titles];
    [self addItems];
}
- (NSInteger)pageItems{
    if (_pageItems > 0) {
        return _pageItems;
    }
    return 3;
}
- (float)titleViewHeight{
    if (_titleViewHeight > 0) {
        return _titleViewHeight;
    }else{
        return 44;
    }
}
- (UIColor *)selectColor{
    if (!_selectColor) {
        return [UIColor orangeColor];
    }else{
        return _selectColor;
    }
}
- (UIColor *)normalColor{
    if (!_normalColor) {
        return [UIColor lightGrayColor];
    }else{
        return _normalColor;;
    }
}
- (void)addItems{
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectZero];
    sv.backgroundColor = [UIColor whiteColor];
    [self addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_offset(44);
    }];
    sv.bounces = NO;
    sv.showsHorizontalScrollIndicator = NO;
    UIView *contentV = [UIView new];
    [sv addSubview:contentV];
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv);
        make.height.equalTo(sv);
    }];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = screenW/self.pageItems;
    int count = (int)self.titleList.count;
    for (int i = 0; i < count; i++) {
        YJSegmentItem *item = [[YJSegmentItem alloc] initWithFrame:CGRectZero title:self.titleList[i] selectColor:self.selectColor norColor:self.normalColor];
        __weak __typeof(&*self)wSelf = self;
        [item clickEventBlock:^{
            [wSelf buttonClick:item];
        }];
        item.tag = i;
        [contentV addSubview:item];
        [self.buttonList addObject:item]; 
        if (i == 0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.height.equalTo(contentV);
                make.width.mas_equalTo(btnW);
            }];
        }else{
            YJSegmentItem *lastBtn = self.buttonList[i-1];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.height.equalTo(contentV);
                make.left.equalTo(lastBtn.mas_right);
                make.width.mas_equalTo(btnW);
            }];
            if (i == self.titleList.count - 1) {
                [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(item.mas_right);
                }];
            }
        }
        if (i == 0) {
            item.isSelect = YES;
        }
    }
    self.titleScrollView = sv;
}
-(void)buttonClick:(YJSegmentItem *)item {
    if (self.viewControllers.count > 0) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        self.contentScrollView.contentOffset = CGPointMake(screenW*item.tag, 0);
    }else{
        [self didSelectButton:item];
    }
}
- (void)setContentScrollView{
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [self addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self).offset(44);
    }];
    sv.bounces = NO;
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    UIView *contentV = [UIView new];
    [sv addSubview:contentV];
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv);
        make.height.equalTo(sv);
    }];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    for (int i=0; i < self.viewControllers.count; i++) {
        UIViewController * vc = self.viewControllers[i];
        [contentV addSubview:vc.view];
        if (i == 0) {
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.height.equalTo(contentV);
                make.width.mas_equalTo(screenW);
            }];
        }else{
            UIViewController *lastVc = self.viewControllers[i-1];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.height.equalTo(contentV);
                make.left.equalTo(lastVc.view.mas_right);
                make.width.mas_equalTo(screenW);
            }];
        }
        if (i == self.viewControllers.count - 1) {
            [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(vc.view.mas_right);
            }];
        }
    }
    self.contentScrollView = sv;
}
//点击按钮后改变字体颜色
-(void)didSelectButton:(YJSegmentItem*)item {
    for (YJSegmentItem *segment in self.buttonList) {
        if (segment.tag == item.tag) {
            if (!segment.isSelect) {
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(yj_dynamicSegment:didSelectItemAtIndex:)]) {
                    [self.delegate yj_dynamicSegment:self didSelectItemAtIndex:item.tag];
                }
            }
            segment.isSelect = YES;
        }else{
            segment.isSelect = NO;
        }
    }
}
#pragma mark - UIScrollViewDelegate
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self moveToOffsetX:offsetX];
}
-(void)moveToOffsetX:(CGFloat)offsetX {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = screenW/self.pageItems;
    CGFloat addX = offsetX/screenW*btnW;
    NSInteger btnTag = round(offsetX/screenW);
    for (YJSegmentItem *btn in self.buttonList) {
        if (btnTag == btn.tag) {
            [self didSelectButton:btn];
            break;
        }
    }
    CGFloat titleOffset = addX - btnW;
    [self.titleScrollView scrollRectToVisible:CGRectMake(titleOffset, 0, screenW, self.titleViewHeight) animated:YES];
}
#pragma mark - 懒加载
- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (NSMutableArray *)titleList
{
    if (!_titleList)
    {
        _titleList = [NSMutableArray array];
    }
    return _titleList;
}

@end

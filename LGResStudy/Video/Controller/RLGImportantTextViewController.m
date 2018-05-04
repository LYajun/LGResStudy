//
//  RLGImportantTextViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/28.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGImportantTextViewController.h"
#import "RLGKnowledgeFlowLayout.h"
#import "RLGCommon.h"
#import "RLGFlowLabelCell.h"
#import <Masonry/Masonry.h>
#import "RLGWordViewController.h"

@interface RLGImportantTextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RLGKnowledgeFlowLayoutDelegate>
@property (nonatomic,strong) NSArray *importantTexts;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation RLGImportantTextViewController
- (instancetype)initWithImportantTexts:(NSArray *) importantTexts{
    if (self = [super init]) {
        self.importantTexts = importantTexts;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RLG_Color(0xF4F4F4);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.bottom.left.centerX.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.importantTexts.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RLGFlowLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RLGFlowLabelCell class]) forIndexPath:indexPath];
    cell.text = self.importantTexts[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.ownController respondsToSelector:@selector(enterWordInquire)]) {
        [self.ownController enterWordInquire];
    }
    NSString *word = self.importantTexts[indexPath.row];
    RLGWordViewController *wordVC = [[RLGWordViewController alloc] initWithWord:word];
    [self.ownController.navigationController pushViewController:wordVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(RLGKnowledgeFlowLayout *)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.importantTexts[indexPath.row];
    CGSize stringSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return stringSize.width+16;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(RLGKnowledgeFlowLayout *)collectionViewLayout heightForHeaderAtIndexPath:(NSIndexPath *)indexPath{
    return 6;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        RLGKnowledgeFlowLayout *layout = [[RLGKnowledgeFlowLayout alloc] init];
        layout.topInset = 1;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [ self.collectionView registerClass:[RLGFlowLabelCell class] forCellWithReuseIdentifier:NSStringFromClass([RLGFlowLabelCell class])];
    }
    return _collectionView;
}
@end

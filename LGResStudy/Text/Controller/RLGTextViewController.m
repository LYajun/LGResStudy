//
//  RLGTextViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTextViewController.h"

#import "RLGResModel.h"
#import "RLGTextView.h"
#import <Masonry/Masonry.h>
#import "RLGTextPresenter.h"
#import "RLGCommon.h"
#import "RLGTextWordView.h"
#import "RLGAudioRecorder.h"
#import "RLGTextOperateView.h"

@interface RLGTextViewController ()
@property (nonatomic,strong) RLGTextView *textView;
@property (nonatomic,strong) RLGResModel *resModel;
@property (nonatomic,strong) RLGTextPresenter *presenter;
@property (nonatomic,strong) RLGTextOperateView *operateView;

@end

@implementation RLGTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)dealloc{
    RLG_Log(@"RLGTextViewController dealloc");
}
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)layoutUI{
    [self.view addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.centerX.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerX.equalTo(self.view);
        make.bottom.equalTo(self.operateView.mas_top);
    }];
    RLGResContentModel *contentModel = self.resModel.Reslist.firstObject;
    [self.textView setTextAttribute:contentModel.ResContent_attr withImporKnTexts:self.resModel.rlgImporKnTexts];
}
- (void)updateData:(RLGResModel *)data{
    self.resModel = data;
    [self layoutUI];
}
- (void)selectImporKnText:(NSString *)text{
    RLG_StopPlayer();
    [self.presenter startRequestWithWord:text];
}
- (void)studyModelChangeAtIndex:(NSInteger)index{
     __weak typeof(self) weakSelf = self;
    if (index == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.operateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }];
    }else{
        RLG_MicrophoneAuthorization();
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.operateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }];
    }
}

- (void)updateWordModel:(id)wordModel{
    [RLGTextWordView showTextWordViewWithWordModel:wordModel];
}
#pragma mark getter
- (RLGTextPresenter *)presenter{
    if (!_presenter) {
        _presenter = [[RLGTextPresenter alloc] initWithView:self];
    }
    return _presenter;
}
- (RLGTextView *)textView{
    if (!_textView) {
        _textView = [[RLGTextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.ownController = self;
    }
    return _textView;
}
- (RLGTextOperateView *)operateView{
    if (!_operateView) {
        _operateView = [[RLGTextOperateView alloc] initWithFrame:CGRectZero];
    }
    return _operateView;
}
@end

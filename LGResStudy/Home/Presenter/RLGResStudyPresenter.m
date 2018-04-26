//
//  RLGResStudyPresenter.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGResStudyPresenter.h"
#import "RLGTextViewController.h"
#import "RLGCommon.h"
#import "RLGResStudyViewController.h"
#import "RLGResponseModel.h"
#import "RLGResModel.h"
#import <MJExtension/MJExtension.h>
#import "RLGViewTransferProtocol.h"
#import "RLGVoiceViewController.h"

@interface RLGResStudyPresenter ()
{
    RLGTextViewController *wTextVC;
    RLGVoiceViewController *wVoiceVC;
}
@end
@implementation RLGResStudyPresenter
- (void)startRequest{
    [(RLGResStudyViewController *)self.view setViewLoadingShow:YES];
    [self.httpClient get:LGResConfig().resUrl parameters:LGResConfig().configParams];
}
- (void)studyModelChangeAtIndex:(NSInteger)index resType:(NSInteger)resType{
    switch (resType) {
        case text:
        {
            if ([wTextVC respondsToSelector:@selector(studyModelChangeAtIndex:)]) {
                [wTextVC studyModelChangeAtIndex:index];
            }
        }
            break;
        case voice:
        {
            if ([wVoiceVC respondsToSelector:@selector(studyModelChangeAtIndex:)]) {
                [wVoiceVC studyModelChangeAtIndex:index];
            }
        }
            break;
        case video:
            
            break;
        default:
            break;
    }
}
- (void)enterResDetailModuleWithResModel:(RLGResModel *) resModel{
    RLGResStudyViewController *studyVC = self.view;
    switch (resModel.rlgResType) {
        case text:
        {
            wTextVC = [[RLGTextViewController alloc] init];
            wTextVC.view.frame = CGRectMake(0, 0, RLG_ScreenWidth(), RLG_ScreenHeight()- RLG_NaviBarHeight(self.view));
            [studyVC.view addSubview:wTextVC.view];
            [studyVC addChildViewController:wTextVC];
            if ([wTextVC respondsToSelector:@selector(updateData:)]) {
                [wTextVC updateData:resModel];
            }
        }
            break;
        case voice:
        {
            wVoiceVC = [[RLGVoiceViewController alloc] init];
            wVoiceVC.view.frame = CGRectMake(0, 0, RLG_ScreenWidth(), RLG_ScreenHeight()- RLG_NaviBarHeight(self.view));
            [studyVC.view addSubview:wVoiceVC.view];
            [studyVC addChildViewController:wVoiceVC];
            if ([wVoiceVC respondsToSelector:@selector(updateData:)]) {
                [wVoiceVC updateData:resModel];
            }
        }
            break;
        case video:
            
            break;
        default:
            break;
    }
}

- (void)success:(RLGResponseModel *)responseObject{
    if (responseObject.Status == 1) {
        [(RLGResStudyViewController *)self.view setViewLoadingShow:NO];
        RLGResModel *resModel = [RLGResModel mj_objectWithKeyValues:responseObject.Data];
        [self enterResDetailModuleWithResModel:resModel];
        if ([self.view respondsToSelector:@selector(updateData:)]) {
            [self.view updateData:resModel];
        }
    }else{
        [(RLGResStudyViewController *)self.view setNoDataText:responseObject.StatusDescription];
        [(RLGResStudyViewController *)self.view setViewNoDataShow:YES];
    }
}

- (void)failure:(NSError *)error{
     [(RLGResStudyViewController *)self.view setViewLoadErrorShow:YES];
}

@end

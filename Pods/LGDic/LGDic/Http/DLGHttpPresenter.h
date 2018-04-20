//
//  DLGHttpPresenter.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGBasePresenter.h"
#import "DLGHttpResponseProtocol.h"
#import "DLGHttpClient.h"
@interface DLGHttpPresenter : DLGBasePresenter<DLGHttpResponseProtocol>
@property (nonatomic,strong)DLGHttpClient *httpClient;
@end

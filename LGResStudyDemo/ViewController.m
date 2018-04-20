//
//  ViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "ViewController.h"
#import "LGResStudy.h"
#import <LGAlertUtil/LGAlertUtil.h>

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LGAlert config];
    
}
- (IBAction)text:(UIButton *)sender {
    [self startResStudywithGUID:@"CCAD05022CIA100000F"];
}

- (IBAction)voice:(UIButton *)sender {
    [self startResStudywithGUID:@"CCAE13101CIA50001Ez"];
}

- (IBAction)video:(UIButton *)sender {
    [self startResStudywithGUID:@"CCAE19162CIB60005PW"];
}

- (void)startResStudywithGUID:(NSString *) GUID{
    LGResConfig().resUrl = @"http://zh.lancooecp.com:8031/FreeStudyCloudApi/Resources/GetNewStudyResInfo";
    LGResConfig().GUID = GUID;
    LGResConfig().UserID = @"tcstu1";
    LGResConfig().Token = @"F8DD8993-BC3D-4ACA-A125-71D04AC77E52";
    LGResConfig().Source = @"I";
    
    LGResConfig().wordUrl = @"http://zh.lancooecp.com:8031/FreeStudyCloudApi/Resources/GetCourseware";
    LGResConfig().parameters = @{
                                 @"Knowledge":@"",
                                 @"levelCode":@""
                                 };
    LGResConfig().wordKey = @"Knowledge";
    LGResConfig().NoteEntryBlock = ^{
        NSLog(@"点击笔记");
    };
    [self.navigationController pushViewController:LGResStudyController() animated:YES];
}
@end

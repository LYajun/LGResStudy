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
#import "TestEngineViewController.h"




@interface ViewController ()
{
    NSString *wHttpIp;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LGAlert config];
    wHttpIp = @"http://192.168.129.44:8050";
}
- (IBAction)pushacton:(id)sender {
    TestEngineViewController *testVC = [[TestEngineViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
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
- (IBAction)segment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        wHttpIp = @"http://192.168.129.44:8050";
    }else{
        wHttpIp = @"http://zh.lancooecp.com:8031";
    }
}
- (void)startResStudywithGUID:(NSString *) GUID{
    LGResConfig().resUrl = [wHttpIp stringByAppendingString:@"/FreeStudyCloudApi/Resources/GetNewStudyResInfo"];
    LGResConfig().GUID = GUID;
    LGResConfig().UserID = @"tcstu1";
    LGResConfig().Token = @"F8DD8993-BC3D-4ACA-A125-71D04AC77E52";
    LGResConfig().Source = @"I";
    
    LGResConfig().wordUrl = [wHttpIp stringByAppendingString:@"/FreeStudyCloudApi/Resources/GetCourseware"];
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

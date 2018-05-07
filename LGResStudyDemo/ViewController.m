//
//  ViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/16.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "ViewController.h"
#import "LGResStudy.h"

#import "TestEngineViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
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
- (void)startResStudywithGUID:(NSString *) GUID{
    LGResConfig().resUrl = @"http://192.168.3.158:8111/api/Resources/GetNewStudyResInfo";
    LGResConfig().GUID = GUID;
    LGResConfig().UserID = @"zxstu81";
    LGResConfig().Token = @"6EF0A4C1-2A8D-4641-A9E4-F17C923E6CED";
    LGResConfig().Source = @"I";
    
    LGResConfig().wordUrl = @"http://192.168.3.158:8111/api/Resources/GetCourseware";
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

//
//  TestEngineViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/24.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "TestEngineViewController.h"
#import "RLGSpeechEngine.h"
#import "RLGCommon.h"
@interface TestEngineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UITextField *refTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playbackBtn;
@property (weak, nonatomic) IBOutlet UILabel *playStateLab;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (nonatomic,assign) RLGSpeechEngineMarkType markType;
@end

@implementation TestEngineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.recordBtn addTarget:self action:@selector(recordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playbackBtn addTarget:self action:@selector(playbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    self.stateLab.text = [[RLGSpeechEngine shareInstance] isInitConfig] ? @"已配置好": @"配置中...";
    [[RLGSpeechEngine shareInstance] initResult:^(BOOL success) {
        if (success) {
            weakSelf.stateLab.text = @"已配置好";
        }else{
            weakSelf.stateLab.text = @"配置中...";
        }
    }];
    [[RLGSpeechEngine shareInstance] recordTime:^(NSInteger recordTime) {
        weakSelf.playStateLab.text = [NSString stringWithFormat:@"录音中...%li",recordTime];
    }];
    RLG_MicrophoneAuthorization();
    self.playStateLab.text = @"";
    self.resultTextView.text = @"";
    [[RLGSpeechEngine shareInstance] speechEngineResult:^(RLGSpeechResultModel *resultModel) {
        weakSelf.recordBtn.selected = NO;
        weakSelf.playStateLab.text = @"完成";
        if (resultModel.isError) {
            weakSelf.resultTextView.text = resultModel.errorMsg;
        }else{
            weakSelf.resultTextView.text = [NSString stringWithFormat:@"得分: %@分",resultModel.totalScore];
        }
    }];
    self.markType = RLGSpeechEngineMarkTypeWord;
}
- (IBAction)segment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.markType = RLGSpeechEngineMarkTypeWord;
    }else{
        self.markType = RLGSpeechEngineMarkTypeSen;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)recordPressed:(UIButton *) btn{
    if (btn.selected) {
        self.playStateLab.text = @"评分中...";
        btn.selected = NO;
        [[RLGSpeechEngine shareInstance] stopEngine];
    }else{
        self.resultTextView.text = @"";;
        self.playStateLab.text = @"准备录音";
        __weak typeof(self) weakSelf = self;
        [[RLGSpeechEngine shareInstance] startEngineAtRefText:self.refTextField.text markType:self.markType complete:^(NSError *error) {
            if (error) {
                weakSelf.recordBtn.selected = NO;
                weakSelf.playStateLab.text = error.localizedDescription;
            }
        }];
        btn.selected = YES;
    }
}

- (void)playbackPressed:(UIButton *) btn{
    [[RLGSpeechEngine shareInstance] playback];
}
@end

//
//  DLGSearchTextField.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGSearchTextField.h"
#import "DLGCommon.h"
#import "DLGAlert.h"

@interface DLGSearchTextField ()<UITextFieldDelegate>
{
    NSString *wSearchString;
}
@end
@implementation DLGSearchTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
- (void)config{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DLG_GETBundleResource(@"search")]];
    imageView.contentMode = UIViewContentModeCenter;
    CGRect frame = imageView.frame;
    frame.size.width = imageView.frame.size.width + 10;
    imageView.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor lightGrayColor];
    self.placeholder = @"请输入要查询的单词";
    self.font = [UIFont systemFontOfSize:14];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeySearch;
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = self;
}
// 使textField不把输入的拼音认作文本编辑框的内容
- (void)textFieldDidChange:(UITextField *) textField{
    UITextRange *selectedRange = [textField markedTextRange];
    NSString *newText = [textField textInRange:selectedRange];
    if (newText.length <= 0) {
        wSearchString = [[textField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (wSearchString.length > 0) {
        [textField resignFirstResponder];
        if (self.dlgDelegate && [self.dlgDelegate respondsToSelector:@selector(dlg_textFieldDidSearch:word:)]) {
            [self.dlgDelegate dlg_textFieldDidSearch:self word:wSearchString];
        }
    }else{
        [[DLGAlert shareInstance] showInfoWithStatus:@"输入不能为空"];
    }
    return NO;
}
@end

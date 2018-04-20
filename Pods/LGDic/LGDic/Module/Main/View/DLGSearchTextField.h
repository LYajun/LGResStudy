//
//  DLGSearchTextField.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLGSearchTextField;
@protocol DLGSearchTextFieldDelegate <NSObject>
- (void)dlg_textFieldDidSearch:(DLGSearchTextField *)textField word:(NSString *) word;
@end

@interface DLGSearchTextField : UITextField
@property (nonatomic,assign) id<DLGSearchTextFieldDelegate> dlgDelegate;
@end

//
//  RLGTextView.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/17.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGTextView.h"
#import "RLGCommon.h"


@interface RLGTextView ()<UITextViewDelegate>
{
    NSArray *wImporKnTexts;
}
@end
@implementation RLGTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}
- (void)setTextAttribute:(NSMutableAttributedString *)textAttribute withImporKnTexts:(NSArray *)imporKnTexts{
    wImporKnTexts = imporKnTexts;
    NSMutableAttributedString *attr = textAttribute.mutableCopy;
    NSMutableArray *allKeys = [NSMutableArray array];
    for (NSString *substr in imporKnTexts) {
        if ([substr containsString:@" "] &&
            [attr.string containsString:substr]) {
            NSRange range = [attr.string rangeOfString:substr];
            NSInteger index = [imporKnTexts indexOfObject:substr];
            [attr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"text://%li",index] range:range];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
            [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
            [attr addAttribute:NSUnderlineColorAttributeName value:RLG_ThemeColor() range:range];
        }else{
            [allKeys addObject:substr];
        }
    }
    [attr.string enumerateSubstringsInRange:NSMakeRange(0, attr.string.length-1) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if ([allKeys containsObject:substring] || [allKeys containsObject:substring.lowercaseString] || [allKeys containsObject:substring.uppercaseString]) {
            NSInteger index = NSIntegerMax;
            if ([allKeys containsObject:substring]) {
                index = [imporKnTexts indexOfObject:substring];
            }else if ([allKeys containsObject:substring.lowercaseString]){
                index = [imporKnTexts indexOfObject:substring.lowercaseString];
            }else if ([allKeys containsObject:substring.uppercaseString]){
                index = [imporKnTexts indexOfObject:substring.uppercaseString];
            }
            [attr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"text://%li",index] range:substringRange];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:substringRange];
            [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:substringRange];
            [attr addAttribute:NSUnderlineColorAttributeName value:RLG_ThemeColor() range:substringRange];
        }
    }];
    self.attributedText = attr;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
     NSInteger index = [URL.absoluteString componentsSeparatedByString:@"//"].lastObject.integerValue;
    if (index < wImporKnTexts.count) {
        NSString *word = [wImporKnTexts objectAtIndex:index];
        if ([self.ownController respondsToSelector:@selector(selectImporKnText:)]) {
            [self.ownController selectImporKnText:word];
        }
    }
    return NO;
}
//  iOS 10.0 or newer
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
//    if (interaction == UITextItemInteractionInvokeDefaultAction) {
//        NSInteger index = URL.absoluteString.integerValue;
//        RLG_Log([NSString stringWithFormat:@"索引2:%zi",index]);
//         return YES;
//    }else{
//         return NO;
//    }
//}
@end

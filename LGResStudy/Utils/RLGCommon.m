//
//  DLGCommon.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLGCommon.h"
#import "RLGResStudyViewController.h"

BOOL RLG_IsEmpty(id obj){
    if (obj == nil) return YES;
    if ([obj isEqual:[NSNull null]]) return YES;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)obj;
        if ([str isEqualToString:@""]) return YES;
        return NO;
    }else if ([obj isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *)obj;
        if (arr.count == 0) return YES;
        return NO;
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = (NSDictionary *)obj;
        if (dic.count == 0) return YES;
        return NO;
    }else{
        return NO;
    }
}
NSString *RLG_GETBundleResource(NSString *fileName){
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/LGResStudy.framework/LGResStudy.bundle"];
     if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
         bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGResStudy.bundle"];
     }
    NSBundle *resoureBundle = [NSBundle bundleWithPath:bundlePath];
    if (resoureBundle && fileName)
    {
        NSString * bundlePath = [[resoureBundle resourcePath] stringByAppendingPathComponent:fileName];
        
        return bundlePath;
    }
    return nil ;
}

UIColor *RLG_Color(NSInteger hex){
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

NSMutableAttributedString *RLG_AttributedString(NSString *htmlStr,CGFloat font){
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font]range:NSMakeRange(0,attrStr.length)];
    return attrStr;
}


void RLG_Log(NSString *msg){
#if DEBUG
    NSLog(@"\n***********电子教材**************\n%@\n******************************",msg);
#else
    NSLog(@"");
#endif
}

CGFloat RLG_ScreenWidth(void){
    return [UIScreen mainScreen].bounds.size.width;
}
CGFloat RLG_ScreenHeight(void){
    return [UIScreen mainScreen].bounds.size.height;
}
CGFloat RLG_NaviBarHeight(UIViewController *vc){
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = vc.navigationController.navigationBar.frame;
    return statusRect.size.height+navRect.size.height;
}
RLGConfig *LGResConfig(void){
    return [RLGConfig shareInstance];
}
UIViewController *LGResStudyController(void){
    return [[RLGResStudyViewController alloc] init];
}
BOOL RLG_PredicateMatch(NSString *text,NSString *matchFormat){
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}
NSArray *RLG_VoiceGifs(void){
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Frameworks/LGResStudy.framework/LGResStudy.bundle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGResStudy.bundle"];
    }
    return @[[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice01.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice02.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice03.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice04.png",bundlePath]]];
}
UIColor *RLG_ThemeColor(void){
    return RLG_Color(0x1379EC);
}
NSString *RLG_Time(NSInteger timeCount){
    if (timeCount < 60*60) {
        NSInteger minute = timeCount % (60*60) / 60;
        NSInteger second = timeCount % (60*60) % 60;
        return [NSString stringWithFormat:@"%02li:%02li",minute,second];
    }else{
        NSInteger hour = timeCount / (60*60);
        NSInteger minute = timeCount % (60*60) / 60;
        NSInteger second = timeCount % (60*60) % 60;
        return [NSString stringWithFormat:@"%02li:%02li:%02li",hour,minute,second];
    }
}

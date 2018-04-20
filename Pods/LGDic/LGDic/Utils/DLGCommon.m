//
//  DLGCommon.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGCommon.h"
#import "DLGDicViewController.h"

BOOL DLG_IsEmpty(id obj){
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
NSString *DLG_GETBundleResource(NSString *fileName){
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/LGDic.framework/LGDic.bundle"];
     if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
         bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGDic.bundle"];
     }
    NSBundle *resoureBundle = [NSBundle bundleWithPath:bundlePath];
    if (resoureBundle && fileName)
    {
        NSString * bundlePath = [[resoureBundle resourcePath] stringByAppendingPathComponent:fileName];
        
        return bundlePath;
    }
    return nil ;
}

UIColor *DLG_Color(NSInteger hex){
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

NSAttributedString *DLG_AttributedString(NSString *htmlStr,CGFloat font){
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font]range:NSMakeRange(0,attrStr.length)];
    return attrStr;
}

CGFloat DLG_AttributedStringHeight(NSString *htmlStr,CGFloat displayWidth,CGFloat font){
    NSMutableAttributedString *attrStr = (NSMutableAttributedString *)DLG_AttributedString(htmlStr, font);
    CGSize sizeToFit = [attrStr boundingRectWithSize:CGSizeMake(displayWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return sizeToFit.height;
}

void DLG_Log(NSString *msg){
#if DEBUG
    NSLog(@"\n***********电子词典**************\n%@\n******************************",msg);
#else
    NSLog(@"");
#endif
}

DLGConfig *LGDicConfig(){
    return [DLGConfig shareInstance];
}
UIViewController *LGDicHomeController(void){
    return [[DLGDicViewController alloc] init];
}
CGFloat DLG_ScreenWidth(void){
    return [UIScreen mainScreen].bounds.size.width;
}
CGFloat DLG_ScreenHeight(void){
    return [UIScreen mainScreen].bounds.size.height;
}
CGFloat DLG_NaviBarHeight(UIViewController *vc){
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = vc.navigationController.navigationBar.frame;
    return statusRect.size.height+navRect.size.height;
}
NSArray *DLG_VoiceGifs(void){
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Frameworks/LGDic.framework/LGDic.bundle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGDic.bundle"];
    }
    return @[[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice01.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice02.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice03.png",bundlePath]],[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/voice04.png",bundlePath]]];
}

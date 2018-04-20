//
//  LGDic.h
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/2.
//  Copyright © 2018年 刘亚军. All rights reserved.
//


#import "DLGCommon.h"








NSString *dlg_BundleResourcePath(NSString *fileName){
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGDic.bundle"] ;
    NSBundle *resoureBundle = [NSBundle bundleWithPath:bundlePath];
    if (resoureBundle && fileName)
    {
        NSString * bundlePath = [[resoureBundle resourcePath] stringByAppendingPathComponent:fileName];
        
        return bundlePath;
    }
    return nil ;
}

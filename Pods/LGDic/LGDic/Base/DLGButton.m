//
//  DLGITButton.m
//  LGDicDemo
//
//  Created by 刘亚军 on 2018/4/4.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "DLGButton.h"

@implementation DLGITButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
- (void)config{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = contentRect.size.height;
    CGFloat titleW = contentRect.size.width - contentRect.size.height;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, 0, titleW, titleH);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(0, 0, imageW, imageH);
    
}

@end


@implementation DLGTIButton
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
- (void)config{
    self.imageView.contentMode = UIViewContentModeCenter;
     self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width - contentRect.size.height;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, 0, titleW, titleH);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width - contentRect.size.height;
    return CGRectMake(imageX, 5, imageW-10, imageH-10);
    
}

@end

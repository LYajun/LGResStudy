//
//  YJBrightnessView.m
//  YJPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJBrightnessView.h"
#import <Masonry/Masonry.h>

@interface YJBrightnessView ()

@property (nonatomic, strong) UIImageView		*backImage;
@property (nonatomic, strong) UILabel			*title;
@property (nonatomic, strong) UIView			*brightnessLevelView;
@property (nonatomic, strong) NSMutableArray	*tipArray;
@property (nonatomic, strong) NSTimer			*timer;

@end

@implementation YJBrightnessView

#pragma mark - 单例
+ (void)showBrightnessViewAtView:(UIView *)fatherView{
    YJBrightnessView *brightnessView = [YJBrightnessView new];
    [fatherView addSubview:brightnessView];
    [brightnessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(fatherView);
        make.size.mas_equalTo(CGSizeMake(155, 155));
    }];
}
- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.layer.cornerRadius  = 10;
    self.layer.masksToBounds = YES;
    // 毛玻璃效果
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.translucent = YES;
    [self addSubview:toolbar];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.backImage];
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(79, 76));
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.equalTo(self);
        make.top.equalTo(self).mas_offset(5);
        make.height.mas_equalTo(30);
    }];
    [self addSubview:self.brightnessLevelView];
    [self.brightnessLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(13);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
        make.height.mas_equalTo(7);
    }];
    [self createTips];
    [self addKVOObserver];
    
    self.alpha = 0.0;
}

#pragma makr - 创建 Tips
- (void)createTips {
	self.tipArray = [NSMutableArray arrayWithCapacity:16];
	CGFloat tipW = (132 - 17) / 16;
	CGFloat tipH = 5;
	CGFloat tipY = 1;
    for (int i = 0; i < 16; i++) {
        CGFloat tipX   = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
		[self.brightnessLevelView addSubview:image];
		[self.tipArray addObject:image];
	}
	[self updateBrightnessLevel:[UIScreen mainScreen].brightness];
}


- (void)addKVOObserver {
	[[UIScreen mainScreen] addObserver:self
							forKeyPath:@"brightness"
							   options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat levelValue = [change[@"new"] floatValue];

    [self removeTimer];
    [self appearBrightnessView];
    [self updateBrightnessLevel:levelValue];
}

#pragma mark - Brightness显示 隐藏
- (void)appearBrightnessView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self addtimer];
    }];
}

- (void)disAppearBrightnessView {
    if (self.alpha == 1.0) {
		[UIView animateWithDuration:0.5 animations:^{
			self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeTimer];
		}];
	}
}

#pragma mark - 定时器
- (void)addtimer {
	if (self.timer) {
		return;
	}
	self.timer = [NSTimer timerWithTimeInterval:2
										 target:self
									   selector:@selector(disAppearBrightnessView)
									   userInfo:nil
										repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 更新亮度值
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel {
	CGFloat stage = 1 / 15.0;
	NSInteger level = brightnessLevel / stage;
    for (int i = 0; i < self.tipArray.count; i++) {
		UIImageView *img = self.tipArray[i];
        if (i <= level) {
			img.hidden = NO;
		} else {
			img.hidden = YES;
		}
	}
}
#pragma mark - 获取bundle资源
NSString* getResourceFromBundleFileName( NSString * filename) {
    NSString * vodPlayerBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"YJPlayerView.bundle"] ;
    NSBundle *resoureBundle = [NSBundle bundleWithPath:vodPlayerBundle];
    
    if (resoureBundle && filename)
    {
        NSString * bundlePath = [[resoureBundle resourcePath ] stringByAppendingPathComponent:filename];
        
        return bundlePath;
    }
    return nil ;
}

#pragma mark - 销毁
- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
}
#pragma mark - 懒加载
-(UILabel *)title {
    if (!_title) {
        _title   = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font  = [UIFont boldSystemFontOfSize:16];
        _title.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text   = @"亮度";
    }
    return _title;
}

- (UIImageView *)backImage {
    
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backImage.image  = [UIImage imageNamed:getResourceFromBundleFileName(@"brightness")];
    }
    return _backImage;
}

-(UIView *)brightnessLevelView {
    
    if (!_brightnessLevelView) {
        _brightnessLevelView  = [[UIView alloc]initWithFrame:CGRectZero];
        _brightnessLevelView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
    }
    return _brightnessLevelView;
}
@end

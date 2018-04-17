//
//  RLGActivityIndicatorView.h
//  RLGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RLGActivityIndicatorAnimationType) {
    RLGActivityIndicatorAnimationTypeNineDots,
    RLGActivityIndicatorAnimationTypeTriplePulse,
    RLGActivityIndicatorAnimationTypeFiveDots,
    RLGActivityIndicatorAnimationTypeRotatingSquares,
    RLGActivityIndicatorAnimationTypeDoubleBounce,
    RLGActivityIndicatorAnimationTypeTwoDots,
    RLGActivityIndicatorAnimationTypeThreeDots,
    RLGActivityIndicatorAnimationTypeBallPulse,
    RLGActivityIndicatorAnimationTypeBallClipRotate,
    RLGActivityIndicatorAnimationTypeBallClipRotatePulse,
    RLGActivityIndicatorAnimationTypeBallClipRotateMultiple,
    RLGActivityIndicatorAnimationTypeBallRotate,
    RLGActivityIndicatorAnimationTypeBallZigZag,
    RLGActivityIndicatorAnimationTypeBallZigZagDeflect,
    RLGActivityIndicatorAnimationTypeBallTrianglePath,
    RLGActivityIndicatorAnimationTypeBallScale,
    RLGActivityIndicatorAnimationTypeLineScale,
    RLGActivityIndicatorAnimationTypeLineScaleParty,
    RLGActivityIndicatorAnimationTypeBallScaleMultiple,
    RLGActivityIndicatorAnimationTypeBallPulseSync,
    RLGActivityIndicatorAnimationTypeBallBeat,
    RLGActivityIndicatorAnimationTypeLineScalePulseOut,
    RLGActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    RLGActivityIndicatorAnimationTypeBallScaleRipple,
    RLGActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    RLGActivityIndicatorAnimationTypeTriangleSkewSpin,
    RLGActivityIndicatorAnimationTypeBallGridBeat,
    RLGActivityIndicatorAnimationTypeBallGridPulse,
    RLGActivityIndicatorAnimationTypeRotatingSandglass,
    RLGActivityIndicatorAnimationTypeRotatingTrigons,
    RLGActivityIndicatorAnimationTypeTripleRings,
    RLGActivityIndicatorAnimationTypeCookieTerminator,
    RLGActivityIndicatorAnimationTypeBallSpinFadeLoader
};

@interface RLGActivityIndicatorView : UIView

- (id)initWithType:(RLGActivityIndicatorAnimationType)type;
- (id)initWithType:(RLGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(RLGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) RLGActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end

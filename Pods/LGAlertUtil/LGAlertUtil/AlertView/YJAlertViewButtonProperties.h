//
//  YJAlertViewButtonProperties.h
//  YJAlertView
//
//
//

#import <UIKit/UIKit.h>
#import "YJAlertViewShared.h"

@interface YJAlertViewButtonProperties : NSObject

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColor;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (strong, nonatomic, nullable) UIImage *iconImage;
@property (strong, nonatomic, nullable) UIImage *iconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *iconImageDisabled;

@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (strong, nonatomic, nullable) UIFont *font;
@property (assign, nonatomic) NSUInteger numberOfLines;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) CGFloat minimumScaleFactor;
@property (assign, nonatomic, getter=isAdjustsFontSizeToFitWidth) BOOL adjustsFontSizeToFitWidth;
@property (assign, nonatomic) YJAlertViewButtonIconPosition iconPosition;

@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

@property (assign, nonatomic, readonly, getter=isUserTitleColor)                 BOOL userTitleColor;
@property (assign, nonatomic, readonly, getter=isUserTitleColorHighlighted)      BOOL userTitleColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserTitleColorDisabled)         BOOL userTitleColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColor)            BOOL userBackgroundColor;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorHighlighted) BOOL userBackgroundColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorDisabled)    BOOL userBackgroundColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserIconImage)                  BOOL userIconImage;
@property (assign, nonatomic, readonly, getter=isUserIconImageHighlighted)       BOOL userIconImageHighlighted;
@property (assign, nonatomic, readonly, getter=isUserIconImageDisabled)          BOOL userIconImageDisabled;
@property (assign, nonatomic, readonly, getter=isUserTextAlignment)              BOOL userTextAlignment;
@property (assign, nonatomic, readonly, getter=isUserFont)                       BOOL userFont;
@property (assign, nonatomic, readonly, getter=isUserNumberOfLines)              BOOL userNumberOfLines;
@property (assign, nonatomic, readonly, getter=isUserLineBreakMode)              BOOL userLineBreakMode;
@property (assign, nonatomic, readonly, getter=isUserMinimimScaleFactor)         BOOL userMinimumScaleFactor;
@property (assign, nonatomic, readonly, getter=isUserAdjustsFontSizeTofitWidth)  BOOL userAdjustsFontSizeTofitWidth;
@property (assign, nonatomic, readonly, getter=isUserIconPosition)               BOOL userIconPosition;
@property (assign, nonatomic, readonly, getter=isUserEnabled)                    BOOL userEnabled;

@end

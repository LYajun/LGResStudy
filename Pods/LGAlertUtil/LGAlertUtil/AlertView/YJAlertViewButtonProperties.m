//
//  YJAlertViewButtonProperties.m
//  YJAlertView
//
//
//

#import "YJAlertViewButtonProperties.h"

@interface YJAlertViewButtonProperties ()

@property (readwrite) BOOL userTitleColor;
@property (readwrite) BOOL userTitleColorHighlighted;
@property (readwrite) BOOL userTitleColorDisabled;
@property (readwrite) BOOL userBackgroundColor;
@property (readwrite) BOOL userBackgroundColorHighlighted;
@property (readwrite) BOOL userBackgroundColorDisabled;
@property (readwrite) BOOL userIconImage;
@property (readwrite) BOOL userIconImageHighlighted;
@property (readwrite) BOOL userIconImageDisabled;
@property (readwrite) BOOL userTextAlignment;
@property (readwrite) BOOL userFont;
@property (readwrite) BOOL userNumberOfLines;
@property (readwrite) BOOL userLineBreakMode;
@property (readwrite) BOOL userMinimumScaleFactor;
@property (readwrite) BOOL userAdjustsFontSizeTofitWidth;
@property (readwrite) BOOL userIconPosition;
@property (readwrite) BOOL userEnabled;

@end

@implementation YJAlertViewButtonProperties

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.titleColor = [coder decodeObjectForKey:@"titleColor"];
        self.titleColorHighlighted = [coder decodeObjectForKey:@"titleColorHighlighted"];
        self.titleColorDisabled = [coder decodeObjectForKey:@"titleColorDisabled"];
        self.backgroundColor = [coder decodeObjectForKey:@"backgroundColor"];
        self.backgroundColorHighlighted = [coder decodeObjectForKey:@"backgroundColorHighlighted"];
        self.backgroundColorDisabled = [coder decodeObjectForKey:@"backgroundColorDisabled"];
        self.iconImage = [coder decodeObjectForKey:@"iconImage"];
        self.iconImageHighlighted = [coder decodeObjectForKey:@"iconImageHighlighted"];
        self.iconImageDisabled = [coder decodeObjectForKey:@"iconImageDisabled"];
        self.font = [coder decodeObjectForKey:@"font"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.titleColor forKey:@"titleColor"];
    [coder encodeObject:self.titleColorHighlighted forKey:@"titleColorHighlighted"];
    [coder encodeObject:self.titleColorDisabled forKey:@"titleColorDisabled"];
    [coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
    [coder encodeObject:self.backgroundColorHighlighted forKey:@"backgroundColorHighlighted"];
    [coder encodeObject:self.backgroundColorDisabled forKey:@"backgroundColorDisabled"];
    [coder encodeObject:self.iconImage forKey:@"iconImage"];
    [coder encodeObject:self.iconImageHighlighted forKey:@"iconImageHighlighted"];
    [coder encodeObject:self.iconImageDisabled forKey:@"iconImageDisabled"];
    [coder encodeObject:self.font forKey:@"font"];
}

#pragma mark -

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.userTitleColor = YES;
}

- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted {
    _titleColorHighlighted = titleColorHighlighted;
    self.userTitleColorHighlighted = YES;
}

- (void)setTitleColorDisabled:(UIColor *)titleColorDisabled {
    _titleColorDisabled = titleColorDisabled;
    self.userTitleColorDisabled = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.userBackgroundColor = YES;
}

- (void)setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted {
    _backgroundColorHighlighted = backgroundColorHighlighted;
    self.userBackgroundColorHighlighted = YES;
}

- (void)setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled {
    _backgroundColorDisabled = backgroundColorDisabled;
    self.userBackgroundColorDisabled = YES;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.userIconImage = YES;
}

- (void)setIconImageHighlighted:(UIImage *)iconImageHighlighted {
    _iconImageHighlighted = iconImageHighlighted;
    self.userIconImageHighlighted = YES;
}

- (void)seticonImageDisabled:(UIImage *)iconImageDisabled {
    _iconImageDisabled = iconImageDisabled;
    self.userIconImageDisabled = YES;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.userTextAlignment = YES;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.userFont = YES;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.userNumberOfLines = YES;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.userLineBreakMode = YES;
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    _minimumScaleFactor = minimumScaleFactor;
    self.userMinimumScaleFactor = YES;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    self.userAdjustsFontSizeTofitWidth = YES;
}

- (void)setIconPosition:(YJAlertViewButtonIconPosition)iconPosition {
    _iconPosition = iconPosition;
    self.userIconPosition = YES;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.userEnabled = YES;
}

@end

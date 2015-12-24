//
//  FWButton.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-21.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#ifdef __IPHONE_6_0 // iOS6 and later
#  define UITextAlignmentCenter    NSTextAlignmentCenter
#  define UITextAlignmentLeft      NSTextAlignmentLeft
#  define UITextAlignmentRight     NSTextAlignmentRight
#  define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#  define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif

#define kButtonOffset 35.f
#define kTopPadding 5.f

#import "FWButton.h"

@interface FWButton ()

@property (nonatomic, strong) UIImage *highlightedButtonImage;
@property (nonatomic, strong) UIImage *normalButtonImage;

@end

@implementation FWButton

+ (FWButton *)button
{
    return [super buttonWithType:UIButtonTypeCustom];
}

+ (FWButton *)buttonWithType:(UIButtonType)type
{
    return [FWButton button];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cornerRadius = 10.f;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4f];
        self.backgroundColorHighlighted = [UIColor colorWithWhite:0.f alpha:0.6f];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.normalButtonImage == nil || self.highlightedButtonImage == nil) {
        self.normalButtonImage = [self imageForState:UIControlStateNormal];
        self.highlightedButtonImage = [self imageForState:UIControlStateHighlighted];
        [self.imageView removeFromSuperview];
    }
    
    if (self.normalTextColor == nil) {
        self.normalTextColor = [UIColor whiteColor];
    }
    if (self.highlightedTextColor == nil) {
        self.highlightedTextColor = [UIColor whiteColor];
    }
    
    UIImage *buttonImage;
    if (self.state == UIControlStateNormal) {
        buttonImage = self.normalButtonImage;
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    }
    else {
        CGContextSetFillColorWithColor(context, self.backgroundColorHighlighted.CGColor);
        if (self.titleLabel.text.length > 0) {
            //            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        }
        if (self.normalButtonImage != self.highlightedButtonImage && self.highlightedButtonImage != nil) {
            buttonImage = self.highlightedButtonImage;
        }
        else{
            buttonImage = self.normalButtonImage;
        }
    }
    
    // Draw button content view
    CGRect buttonRect = CGRectMake(0.f, 0.f, rect.size.width, rect.size.height);
    UIBezierPath *buttonBezier = [UIBezierPath bezierPathWithRoundedRect:buttonRect cornerRadius:self.cornerRadius];
    [buttonBezier addClip];
    CGContextFillRect(context, buttonRect);
    
    // Draw button image
    if (buttonImage != nil) {
        CGImageRef buttonCGImage = buttonImage.CGImage;
        CGSize imageSize = CGSizeMake(CGImageGetWidth(buttonCGImage)/[self scale], CGImageGetHeight(buttonCGImage)/[self scale]);
        CGFloat buttonYOffset = (rect.size.height-kButtonOffset)/2.f - imageSize.height/2.f + kTopPadding;
        if (self.titleLabel.text.length == 0) {
            buttonYOffset = rect.size.height/2.f - imageSize.height/2.f;
        }
        [buttonImage drawInRect:CGRectMake(rect.size.width/2. - imageSize.width/2.f,
                                           buttonYOffset,
                                           imageSize.width,
                                           imageSize.height)];
    }
    
    // Draw button title
    if (self.titleLabel.text.length > 0) {
        if (self.state == UIControlStateNormal) {
            CGContextSetFillColorWithColor(context, self.normalTextColor.CGColor);
        }else {
            CGContextSetFillColorWithColor(context, self.highlightedTextColor.CGColor);
        }
        [self.titleLabel.text drawInRect:CGRectMake(0.f, (buttonImage != nil ? rect.size.height-kButtonOffset+self.topPading *kTopPadding: rect.size.height/2 - 10.f), rect.size.width, 20.f)
                                withFont:self.titleLabel.font
                           lineBreakMode:self.titleLabel.lineBreakMode
                               alignment:UITextAlignmentCenter];
    }
    
    [self.titleLabel removeFromSuperview];
}

- (void)setBackgroundColor:(UIColor *)color
{
    _backgroundColor = color;
}

- (void)setBackgroundColorHighlighted:(UIColor *)color
{
    _backgroundColorHighlighted = color;
}

- (CGFloat)scale
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        return [[UIScreen mainScreen] scale];
    }
    return 1.0f;
}


@end

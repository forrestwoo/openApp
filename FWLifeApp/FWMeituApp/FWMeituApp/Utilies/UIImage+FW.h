//
//  UIImage+FW.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-11.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FW)

- (UIImage *)cropImageWithBounds:(CGRect)bounds;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end

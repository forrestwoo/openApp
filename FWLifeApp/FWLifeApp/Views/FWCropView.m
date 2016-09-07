//
//  FWCropView.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-5.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWCropView.h"
#import "FWCropRectView.h"

@interface FWCropView ()

<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) FWCropRectView *cropRectView;
@property (nonatomic) UIView *topOverlayView;
@property (nonatomic) UIView *leftOverlayView;
@property (nonatomic) UIView *rightOverlayView;
@property (nonatomic) UIView *bottomOverlayView;

@property (nonatomic) CGRect insetRect;
@property (nonatomic) CGRect editingRect;

@property (nonatomic, getter = isResizing) BOOL resizing;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

@implementation FWCropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.image) {
        return;
    }
    
    self.editingRect = CGRectInset(self.bounds, 20, 37);
    
    if (!self.imageView) {
        [self setupImageView];
    }
    
    if (!self.isResizing) {
//        [self layoutCropRectViewWithCropRect:self.frame];
        
    }
}

- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect
{
    self.cropRectView.frame = cropRect;
}

- (void)setupImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    
    [self addSubview:self.imageView];
    
    self.cropRectView = [[FWCropRectView alloc] initWithFrame:[self bounds]];
    
    self.cropRectView.delegate = self;
    self.cropRectView.showsGridMajor = YES;
    [self addSubview:self.cropRectView];
}

#pragma mark -
- (UIImage *)croppedImage
{
//    CGRect cropRect = self.cropRectView.bounds;
//    CGSize size = self.image.size;
//    
//    CGFloat ratio = 1.0f;
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(orientation)) {
//        ratio = CGRectGetWidth(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.width;
//    } else {
//        ratio = CGRectGetHeight(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.height;
//    }
//    
//    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
//                                       cropRect.origin.y / ratio,
//                                       cropRect.size.width / ratio,
//                                       cropRect.size.height / ratio);
//    
//    UIImage *rotatedImage = [self rotatedImageWithImage:self.image transform:self.imageView.transform];
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(self.image.CGImage, self.cropRectView.bounds);
    UIImage *image = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    
    return image;
}

//- (UIImage *)rotatedImageWithImage:(UIImage *)image transform:(CGAffineTransform)transform
//{
//    CGSize size = image.size;
//    
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
//    CGContextConcatCTM(context, transform);
//    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
//    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
//    
//    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return rotatedImage;
//}

- (CGRect)cappedCropRectInImageRectWithCropRectView:(FWCropRectView *)cropRectView
{
    CGRect cropRect = cropRectView.frame;
    
    CGRect rect = [self convertRect:cropRect toView:self.superview];
    if (CGRectGetMinX(rect) < CGRectGetMinX(self.frame)) {
        cropRect.origin.x = CGRectGetMinX([self.superview convertRect:self.frame toView:self]);
        cropRect.size.width = CGRectGetMaxX(rect);
    }
    if (CGRectGetMinY(rect) < CGRectGetMinY(self.frame)) {
        cropRect.origin.y = CGRectGetMinY([self.superview convertRect:self.frame toView:self]);
        cropRect.size.height = CGRectGetMaxY(rect);
    }
    if (CGRectGetMaxX(rect) > CGRectGetMaxX(self.frame)) {
        cropRect.size.width = CGRectGetMaxX([self.superview convertRect:self.frame toView:self]) - CGRectGetMinX(cropRect);
    }
    if (CGRectGetMaxY(rect) > CGRectGetMaxY(self.frame)) {
        cropRect.size.height = CGRectGetMaxY([self.superview convertRect:self.frame toView:self]) - CGRectGetMinY(cropRect);
    }
//    NSLog(@"cropRectView,rect %@", NSStringFromCGRect(cropRectView.frame));
//    NSLog(@"rect minx=%f,miny=%f,maxx=%f,maxy=%f%@",CGRectGetMinX(rect),CGRectGetMinY(rect), CGRectGetMaxX(rect) ,CGRectGetMaxY(rect) ,NSStringFromCGRect(self.frame));
//    NSLog(@"self minx=%f,miny=%f,maxx=%f,maxy=%f%@",CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), CGRectGetMaxX(self.frame) ,CGRectGetMaxY(self.frame) ,NSStringFromCGRect(self.frame));
//    NSLog(@"----------------------------------!");
    //self,rect {{57.5, 64}, {260, 460}}
    //superview,rect {{0, 0}, {375, 667}}
    //
    return cropRect;
}

#pragma mark -

- (void)cropRectViewDidBeginEditing:(FWCropRectView *)cropRectView
{
    self.resizing = YES;
}

- (void)cropRectViewEditingChanged:(FWCropRectView *)cropRectView
{
    if (cropRectView.frame.origin.x < 0 || cropRectView.frame.origin.y < 0) {
        return;
    }
    CGRect cropRect = [self cappedCropRectInImageRectWithCropRectView:cropRectView];
    
    [self layoutCropRectViewWithCropRect:cropRect];
}

- (void)cropRectViewDidEndEditing:(FWCropRectView *)cropRectView
{
    self.resizing = NO;
    //    [self zoomToCropRect:self.cropRectView.frame];
}

@end

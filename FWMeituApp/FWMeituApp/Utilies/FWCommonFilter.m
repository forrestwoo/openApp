//
//  FWCommonFilter.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWCommonFilter.h"
#import "FWCommonTools.h"

@implementation FWCommonFilter

+ (UIImage *)changeValueForBrightnessFilter:(float)value image:(UIImage *)image;
{
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];

    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForContrastFilter:(float)value image:(UIImage *)image;
{
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
    filter.contrast = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForHightlightFilter:(float)value image:(UIImage *)image;
{
    GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
    filter.highlights = value;
    filter.shadows = 0.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForLowlightFilter:(float)value image:(UIImage *)image
{
    GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
    filter.highlights = 1.0;
    filter.shadows = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForSaturationFilter:(float)value image:(UIImage *)image;
{
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
    filter.saturation = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForExposureFilter:(float)value image:(UIImage *)image
{
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init];
    filter.exposure = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForWhiteBalanceFilter:(float)value image:(UIImage *)image
{
    GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc] init];
    filter.temperature = value;
    filter.tint = 0.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyToLookupFilter:(UIImage *)image
{
    GPUImageAmatorkaFilter *filter = [[GPUImageAmatorkaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForMissEtikateFilter:(float)value image:(UIImage *)image
{
    GPUImageMissEtikateFilter *filter = [[GPUImageMissEtikateFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForSoftEleganceFilter:(float)value image:(UIImage *)image
{
    GPUImageSoftEleganceFilter *filter = [[GPUImageSoftEleganceFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)autoBeautyFilter:(UIImage *)image
{
    UIImage *tempImage = [FWCommonFilter changeValueForContrastFilter:1.3 image:image];
    
    return tempImage;
}

@end

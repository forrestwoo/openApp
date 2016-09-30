//
//  FWCommonFilter.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWApplyFilter.h"
#import "FWCommonTools.h"
#import "FWNashvilleFilter.h"
#import "FWLordKelvinFilter.h"
#import "GPUImageVibranceFilter.h"
#import "FWAmaroFilter.h"
#import "FWRiseFilter.h"
#import "FWHudsonFilter.h"
#import "FW1977Filter.h"
#import "FWValenciaFilter.h"
#import "FWXproIIFilter.h"
#import "FWWaldenFilter.h"
#import "FWLomofiFilter.h"
#import "FWInkwellFilter.h"
#import "FWSierraFilter.h"
#import "FWEarlybirdFilter.h"
#import "FWSutroFilter.h"
#import "FWToasterFilter.h"
#import "FWBrannanFilter.h"
#import "FWHefeFilter.h"
#import "FWLOMOFilter1.h"


@implementation FWApplyFilter

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

+ (UIImage *)changeValueForVibranceFilter:(float)value image:(UIImage *)image
{
    GPUImageVibranceFilter *filter = [[GPUImageVibranceFilter alloc] init];
    filter.vibrance = value;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)changeValueForSharpenilter:(float)value image:(UIImage *)image
{
    GPUImageSharpenFilter *filter = [[GPUImageSharpenFilter alloc] init];
    filter.sharpness = value;
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
    UIImage *tempImage = [FWApplyFilter changeValueForContrastFilter:1.3 image:image];
    
    return tempImage;
}

+ (UIImage *)applyToLookupFilter:(UIImage *)image
{
    FWLordKelvinFilter *filter = [[FWLordKelvinFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//静物
+ (UIImage *)applyStaticFilter:(UIImage *)image
{
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = 0.1;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

//风景
+ (UIImage *)applyViewFilter:(UIImage *)image
{
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
    filter.saturation = 1.4;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyAmatorkaFilter:(UIImage *)image
{
    GPUImageAmatorkaFilter *filter = [[GPUImageAmatorkaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyMissetikateFilter:(UIImage *)image
{
    GPUImageMissEtikateFilter *filter = [[GPUImageMissEtikateFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applySoftEleganceFilter:(UIImage *)image
{
    GPUImageSoftEleganceFilter *filter = [[GPUImageSoftEleganceFilter alloc] init];
    [filter forceProcessingAtSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyNashvilleFilter:(UIImage *)image
{
    FWNashvilleFilter *filter = [[FWNashvilleFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}
//Kelvin能使整张照片的整体风格设置得既富有个性又色彩浓重,非常适合摩登都市颜色绚丽多姿的特点，不过唯一的缺点就是颜色显得太过浓烈时照片就会缺少层次感，看着会像一幅画。

+ (UIImage *)applyLordKelvinFilter:(UIImage *)image
{
    FWLordKelvinFilter *filter = [[FWLordKelvinFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyAmaroFilter:(UIImage *)image
{
    FWAmaroFilter *filter = [[FWAmaroFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyRiseFilter:(UIImage *)image
{
    FWRiseFilter *filter = [[FWRiseFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//Hudson能制造一种在明亮光线环境下拍摄的感觉，能使食物颜色鲜明，并拍出美味的感觉。此外，从侧面拍摄能够拍出食物的立体感。
+ (UIImage *)applyHudsonFilter:(UIImage *)image
{
    FWHudsonFilter *filter = [[FWHudsonFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//X-PRO II是适合在飞机上拍的照片的滤镜，在空中拍的照片往往比较柔和,X-PRO II也是第一款Instagram滤镜， X-pro = Cross-Processing 即摄影中的交叉处理。也很适合云层，雨天的照片，能增强对比度，它是最为和谐的增亮滤镜，不会造成刺眼感。
+ (UIImage *)applyXproIIFilter:(UIImage *)image
{
    FWXproIIFilter *filter = [[FWXproIIFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)apply1977Filter:(UIImage *)image
{
    FW1977Filter *filter = [[FW1977Filter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//Valencia是我们经常使用的一款滤镜，如果我们拍的一张照片在色彩上非常接近我们肉眼所看的颜色，而照片却加重照片的色彩饱和度，我们可以用Valencia来稍微降低饱和度，让淡雅的色彩更加突出，让整张照片充满活力，使照片显得更加柔和，也更接近天空和沙滩的真实色彩。
+ (UIImage *)applyValenciaFilter:(UIImage *)image
{
    FWValenciaFilter *filter = [[FWValenciaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}
+ (UIImage *)applyWaldenFilter:(UIImage *)image
{
    FWWaldenFilter *filter = [[FWWaldenFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyLomofiFilter:(UIImage *)image
{
    FWLomofiFilter *filter = [[FWLomofiFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyLomo1Filter:(UIImage *)image
{
    FWLOMOFilter1 *filter = [[FWLOMOFilter1 alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyInkwellFilter:(UIImage *)image
{
    FWInkwellFilter *filter = [[FWInkwellFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applySierraFilter:(UIImage *)image
{
    FWSierraFilter *filter = [[FWSierraFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyEarlybirdFilter:(UIImage *)image
{
    FWEarlybirdFilter *filter = [[FWEarlybirdFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//Sutro这个滤镜能着重棕色和绿色两种颜色。Sutro能使丛林照片显得更加有戏剧般的色彩，在突出绿色的同时也不会显得照片过于暗沉。
+ (UIImage *)applySutroFilter:(UIImage *)image
{
    FWSutroFilter *filter = [[FWSutroFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyToasterFilter:(UIImage *)image
{
    FWToasterFilter*filter = [[FWToasterFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//Brannan滤镜的特点是能带有一种淡灰色的色调，使得游艇，天空的搭配显得非常有金属质感，而且加重了阴影。
+ (UIImage *)applyBrannanFilter:(UIImage *)image
{
    FWBrannanFilter *filter = [[FWBrannanFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

//Hefe是适合山丘，山庄，山峰，动植物，石头等照片的滤镜，它的色调能营造一种迷蒙辽远的氛围，适合拍摄旷远的山河景致。
+ (UIImage *)applyHefeFilter:(UIImage *)image
{
    FWHefeFilter *filter = [[FWHefeFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyGlassFilter:(UIImage *)image
{
    GPUImageGlassSphereFilter *filter = [[GPUImageGlassSphereFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyBoxBlur:(UIImage *)image
{
    GPUImageBoxBlurFilter *filter = [[GPUImageBoxBlurFilter alloc] init];
//    GPUImageGaussianBlurFilter
//    GPUImageGaussianSelectiveBlurFilter
//    GPUImageTiltShiftFilter
//    GPUImageMedianFilter
    
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyGaussianBlur:(UIImage *)image
{
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
//    filter.texelSpacingMultiplier = 5.0;
    filter.blurRadiusInPixels = 5.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyGaussianSelectiveBlur:(UIImage *)image
{
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    //    filter.texelSpacingMultiplier = 5.0;
    filter.excludeCircleRadius = 50 / 320.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyiOSBlur:(UIImage *)image
{
//    GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];
//    //    filter.texelSpacingMultiplier = 5.0;
//    
//    [filter forceProcessingAtSize:image.size];
//    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
//    [pic addTarget:filter];
//    [pic processImage];
//    [filter useNextFrameForImageCapture];
//    return [filter imageFromCurrentFramebuffer];
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    //    filter.texelSpacingMultiplier = 5.0;
    filter.excludeCircleRadius = 200 / 320.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyMotionBlur:(UIImage *)image
{
//    GPUImageMotionBlurFilter *filter = [[GPUImageMotionBlurFilter alloc] init];
//    //    filter.texelSpacingMultiplier = 5.0;
//    
//    [filter forceProcessingAtSize:image.size];
//    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
//    [pic addTarget:filter];
//    [pic processImage];
//    [filter useNextFrameForImageCapture];
//    return [filter imageFromCurrentFramebuffer];
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    //    filter.texelSpacingMultiplier = 5.0;
    filter.excludeCircleRadius = 10 / 320.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyZoomBlur:(UIImage *)image
{
//    GPUImageZoomBlurFilter *filter = [[GPUImageZoomBlurFilter alloc] init];
//    //    filter.texelSpacingMultiplier = 5.0;
//
//    [filter forceProcessingAtSize:image.size];
//    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
//    [pic addTarget:filter];
//    [pic processImage];
//    [filter useNextFrameForImageCapture];
//    return [filter imageFromCurrentFramebuffer];
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    //    filter.texelSpacingMultiplier = 5.0;
    filter.excludeCircleRadius = 320 / 320.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}
+ (UIImage *)applyColorInvertFilter:(UIImage *)image
{
    GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applySepiaFilter:(UIImage *)image
{
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyHistogramFilter:(UIImage *)image
{
    GPUImageHistogramGenerator *filter = [[GPUImageHistogramGenerator alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}


+ (UIImage *)applyRGBFilter:(UIImage *)image
{
    GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
    filter.red = 0.3;
    filter.green = 0.3;
    filter.blue = 0.3;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyToneCurveFilter:(UIImage *)image
{
    GPUImageToneCurveFilter *filter = [[GPUImageToneCurveFilter alloc] init];

    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

//素描效果
+ (UIImage *)applySketchFilter:(UIImage *)image
{
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    
    [filter forceProcessingAtSize:CGSizeMake(image.size.width / 3.0, image.size.height / 3.0)];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (UIImage *)applyLocalBinaryPatternFilter:(UIImage *)image
{
    GPUImageLocalBinaryPatternFilter *filter = [[GPUImageLocalBinaryPatternFilter alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}
@end

//
//  FWCommonTools.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-6.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWCommonTools.h"
#import <CloudKit/CloudKit.h>

@implementation FWCommonTools

+ (NSDictionary *)getPlistDictionaryForButton
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"effectViewInfo" ofType:@"plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];;
}

+ (UIImage *)getImageWithFilter:(GPUImageFilter *)filter image:(UIImage *)originalImage method:(NSString *)methodName value:(float)value
{
    UIImage *image = originalImage;
//    [filter performSelector:NSSelectorFromString(methodName) withObject:[NSString stringWithFormat:@"%f",value]];
    [filter forceProcessingAtSize:originalImage.size];
    GPUImagePicture *stillImage = [[GPUImagePicture alloc] initWithImage:image];
    [stillImage addTarget:filter];
    [stillImage processImage];
    [filter useNextFrameForImageCapture];

    return [filter imageFromCurrentFramebuffer];
}

@end

//
//  FWCommonFilter.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWCommonFilter : NSObject

//亮度
+ (UIImage *)changeValueForBrightnessFilter:(float)value image:(UIImage *)image;

//对比度
+ (UIImage *)changeValueForContrastFilter:(float)value image:(UIImage *)image;

//饱和度
+ (UIImage *)changeValueForSaturationFilter:(float)value image:(UIImage *)image;

//高光
+ (UIImage *)changeValueForHightlightFilter:(float)value image:(UIImage *)image;

//暗部
+ (UIImage *)changeValueForLowlightFilter:(float)value image:(UIImage *)image;
//- (void)changeValueForBrightnessFilter:(float)value;
//- (void)changeValueForBrightnessFilter:(float)value;
//- (void)changeValueForBrightnessFilter:(float)value;
//智能补光
+ (UIImage *)changeValueForExposureFilter:(float)value image:(UIImage *)image;

//色温
+ (UIImage *)changeValueForWhiteBalanceFilter:(float)value image:(UIImage *)image;

+ (UIImage *)applyToLookupFilter:(UIImage *)image;

+ (UIImage *)changeValueForMissEtikateFilter:(float)value image:(UIImage *)image;

+ (UIImage *)changeValueForSoftEleganceFilter:(float)value image:(UIImage *)image;

//智能优化
+ (UIImage *)autoBeautyFilter:(UIImage *)image;

@end

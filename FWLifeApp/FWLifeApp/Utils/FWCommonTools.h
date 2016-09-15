//
//  FWCommonTools.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-6.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//
#define kCN @"className"
#define kpn @"propertyName"
#define kPV @"propertyValue"
#define kIM @"imageName"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface FWCommonTools : NSObject

+ (NSDictionary *)getPlistDictionaryForButton;

/*
 *filter class name
 *class property name
 *property value
 *image name
 *
 */
+ (UIImage *)getImageWithFilter:(GPUImageFilter *)filter image:(UIImage *)originalImage method:(NSString *)methodName value:(float)value;

+ (CGFloat)widthOfDeviceScreen;
+ (CGFloat)heightOfDeviceScreen;
@end

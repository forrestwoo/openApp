//
//  ConstantsConfig.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-16.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#ifndef FWMeituApp_ConstantsConfig_h
#define FWMeituApp_ConstantsConfig_h

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define kBarHeight 55
#define kTitleWidth 60
#define kTitleHeight 20
#define kCancelHeight 30

#define kCN @"className"
#define kpn @"propertyName"
#define kPV @"propertyValue"
#define kIM @"imageName"

#endif

typedef enum {
    FW_NORMAL_FILTER,
    FW_AMARO_FILTER,
    FW_RISE_FILTER,
    FW_HUDSON_FILTER,
    FW_XPROII_FILTER,
    FW_SIERRA_FILTER,
    FW_LOMOFI_FILTER,
    FW_EARLYBIRD_FILTER,
    FW_SUTRO_FILTER,
    FW_TOASTER_FILTER,
    FW_BRANNAN_FILTER,
    FW_INKWELL_FILTER,
    FW_WALDEN_FILTER,
    FW_HEFE_FILTER,
    FW_VALENCIA_FILTER,
    FW_NASHVILLE_FILTER,
    FW_1977_FILTER,
    FW_LORDKELVIN_FILTER,
    FW_FILTER_TOTAL_NUMBER
} FWFilterType;

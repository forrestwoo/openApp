//
//  FWFunctionViewController.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-23.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWEffectBarItem.h"
#import "FWEffectBar.h"
#import "FWSlider.h"

typedef NS_ENUM(NSInteger, FWBeautyProcessType)
{
    //智能优化
    FWBeautyProcessTypeAutoBeauty,
    //编辑
    FWBeautyProcessTypeEdit,
    //增强
    FWBeautyProcessTypeColorList,
    //特效
    FWBeautyProcessTypeFilter,
    //边框
    FWBeautyProcessTypeBolder,
    //魔幻笔
    FWBeautyProcessTypeMagicPen,
    //马赛克
    FWBeautyProcessTypeMosaic,
    //文字
    FWBeautyProcessTypeText,
    //背景虚化
    FWBeautyProcessTypeBlur
};

@interface FWFunctionViewController : UIViewController <FWEffectBarDelegate>

- (id)initWithImage:(UIImage *)image type:(FWBeautyProcessType)type;
- (void)displayAutoBeautyPage;
- (void)displayColorListPage;
- (void)displayEditPage;

@end

//
//  FWSlider.h
//  FWMeituApp
//
//  Created by hzkmn on 15/12/31.
//  Copyright © 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTipView : UIView

@property (nonatomic, strong) UILabel* currentValueLabel;

@end


@interface FWSlider : UISlider

@property (nonatomic, strong) FWTipView *tipView;

@end

//
//  FWAutoBeautyViewController.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWEffectBar.h"

@interface FWAutoBeautyViewController : UIViewController <FWEffectBarDelegate>

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end

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

@interface FWFunctionViewController : UIViewController <FWEffectBarDelegate>

@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) FWEffectBar *effectBar;
@property (nonatomic, strong) FWEffectBar *typeBar;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) NSArray *normalImageArr;
@property (nonatomic, strong) NSArray *hightlightedImageArr;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSString *FunctionType;
@property (nonatomic, strong) UIImage *image;

- (id)initWithImage:(UIImage *)image normalImageArr:(NSArray *)normalImageArray highlightedImageArr:(NSArray *)highlightedImageArr textArr:(NSArray *)textArray type:(NSString *)type;
- (void)setupTypeBarWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setupEffectBarWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setupSliderWithFrame:(CGRect)frame;
- (void)setupButtonsWithFrame:(CGRect)frame;
- (void)setupImageView;
- (void)setupSEView;

@end

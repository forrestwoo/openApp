//
//  FWButton.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-21.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWButton : UIButton

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroundColorHighlighted;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, assign) float topPading;
@end

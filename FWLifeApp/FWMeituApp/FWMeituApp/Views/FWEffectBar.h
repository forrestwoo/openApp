//
//  FWEffectBar.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-23.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWEffectBarItem.h"

@class FWEffectBar;

@protocol FWEffectBarDelegate <NSObject>

- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index;

@end

@interface FWEffectBar : UIScrollView

@property (nonatomic, assign) id<FWEffectBarDelegate> effectBarDelegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) FWEffectBarItem *selectedItem;
@property CGFloat margin;
@property (nonatomic) CGFloat itemWidth;
@property CGFloat itemBeginX;
/**
 * Sets the height of tab bar.
 */
- (void)setHeight:(CGFloat)height;

@end

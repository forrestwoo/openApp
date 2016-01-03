//
//  FWEffectBar.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-23.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FWEffectBar, FWEffectBarItem;

@protocol FWEffectBarDelegate <NSObject>

- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index;

@end

@interface FWEffectBar : UIScrollView

@property (nonatomic, assign) id<FWEffectBarDelegate> effectBardelegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) FWEffectBarItem *selectedItem;
@property UIEdgeInsets contentEdgeInsets;

/**
 * Sets the height of tab bar.
 */
- (void)setHeight:(CGFloat)height;

/**
 * Returns the minimum height of tab bar's items.
 */
- (CGFloat)minimumContentHeight;

@end

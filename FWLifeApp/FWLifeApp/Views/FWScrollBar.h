//
//  FWScrollBar.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/5.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWScrollBar;
@protocol FWScrollBarDelegate <NSObject>

- (void)scrollBar:(nullable FWScrollBar *)bar didSelectItemAtIndex:(NSInteger)index;

@end

@interface FWScrollBar : UIScrollView

@property (nullable, nonatomic, copy) NSArray *items;
@property (nullable, nonatomic, weak) id<FWScrollBarDelegate> scrollBarDelegate;
@property (nullable, nonatomic, assign) UITabBarItem *selectedItem;
@property CGFloat margin;

@end

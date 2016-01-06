//
//  FWScrollBar.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/5.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWScrollBar.h"

@implementation FWScrollBar

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews
{
    
}

- (void)setItems:(NSArray *)items
{
    for (UITabBarItem *item in _items) {
//        [item re]
    }
}

- (void)drawRect:(CGRect)rect
{
//    UITabBar
}

@end

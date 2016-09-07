//
//  FWEffectBar.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-23.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWEffectBar.h"

@interface FWEffectBar ()

@end

@implementation FWEffectBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)commonInit
{
    self.bounces = NO;
    self.margin = 15;
    self.itemWidth = 50;
    self.itemBeginX = 15;
}

- (void)layoutSubviews
{
    CGSize frameSize = self.frame.size;
    
    NSInteger index = 0;
    
    // Layout items
    
    for (FWEffectBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        [item setFrame:CGRectMake(_itemBeginX + index * (_itemWidth + _margin),
                                  0,
                                  self.itemWidth, self.frame.size.height)];
        [item setNeedsDisplay];
//        NSLog(@"item frame is :%@", NSStringFromCGRect(item.frame));
        
        index++;
    }
    
    CGSize contentSize = CGSizeMake(_itemBeginX + [_items count] * _itemWidth + ([_items count] - 1) * _margin, self.frame.size.height);
    self.contentSize = contentSize;
}

#pragma mark - Configuration

- (void)setItems:(NSArray *)items
{
    for (FWEffectBarItem *item in _items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (FWEffectBarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
    
}

- (void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender
{
    [self setSelectedItem:sender];
    
    if ([[self effectBarDelegate] respondsToSelector:@selector(effectBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self effectBarDelegate] effectBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(FWEffectBarItem *)selectedItem
{
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

@end

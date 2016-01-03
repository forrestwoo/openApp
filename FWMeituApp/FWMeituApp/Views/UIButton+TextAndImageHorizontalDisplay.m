//
//  UIButton+TextAndImageHorizontalDisplay.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-6.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "UIButton+TextAndImageHorizontalDisplay.h"

@implementation UIButton (TextAndImageHorizontalDisplay)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)state {    
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -5.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:state];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -10.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:state];
}


@end

//
//  FWTriangleView.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-11.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWTriangleView.h"

@implementation FWTriangleView

- (id)initWithFrame:(CGRect)frame
{
    CGRect frame1 = CGRectMake(0, 0, 30, 30);

    if (self = [super initWithFrame:frame1]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] set];
    UIRectFill(self.bounds);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), 0);
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds));

    CGContextClosePath(context);
    
    [[UIColor colorWithRed:245 / 255.0 green:144 / 255.0 blue:19 / 255.0 alpha:1.0] setFill];
    CGContextDrawPath(context, kCGPathFill);
}



@end

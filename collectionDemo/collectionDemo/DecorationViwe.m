//
//  DecorationViwe.m
//  collectionDemo
//
//  Created by hzkmn on 16/2/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "DecorationViwe.h"

@implementation DecorationViwe

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:frame];
        img.image = [UIImage imageNamed:@"2"];
        [self addSubview:img];
    }
    
    return self;
}

@end

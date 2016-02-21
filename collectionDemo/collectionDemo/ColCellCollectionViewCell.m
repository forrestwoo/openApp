//
//  ColCellCollectionViewCell.m
//  collectionDemo
//
//  Created by hzkmn on 16/2/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "ColCellCollectionViewCell.h"

@implementation ColCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        img.image = [UIImage imageNamed:@"chuci"];
        [self addSubview:img];
    }
    
    return self;
}

@end

//
//  FWBookShelfDecarationViewCollectionReusableView.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/18.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWBookShelfDecarationView.h"

@implementation FWBookShelfDecarationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 216)];
        img.image = [UIImage imageNamed:@"boolshelf.png"];
        [self addSubview:img];
    }
    
    return self;
}
@end

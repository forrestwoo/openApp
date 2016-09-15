//
//  FWImageCell.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWImageCell.h"

@implementation FWImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.FirstImageView = [[UIImageView alloc] init];
        self.FirstImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.FirstImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.FirstImageView];
        
        self.secondImageView = [[UIImageView alloc] init];
        self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.secondImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.secondImageView];
        
        self.FirstImageView.frame = CGRectMake(5, 5,  ([[UIScreen mainScreen] bounds].size.width  - 15) / 2, 150);
        self.secondImageView.frame = CGRectMake(10 + ([[UIScreen mainScreen] bounds].size.width  - 15) / 2, 5,  ([[UIScreen mainScreen] bounds].size.width  - 15) / 2, 150);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.FirstImageView.userInteractionEnabled =  YES;
        self.secondImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];

        [self.FirstImageView addGestureRecognizer:tapGes];
        [self.secondImageView addGestureRecognizer:tapGes1];
        
    }
    
    return self;
}

- (void)tap:(UIGestureRecognizer *)ges
{
    if (ges.view && [self.gesturedelegate respondsToSelector:@selector(gestureImage:)] && [ges.view isKindOfClass:[UIImageView class]]) {
        UIImageView *iv = (UIImageView *)ges.view;
        [self.gesturedelegate performSelector:@selector(gestureImage:) withObject:iv.image];
    }
}

- (void)setViews
{
    
}


@end

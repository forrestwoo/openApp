//
//  FWTopView.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-18.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//
#define HEART_WIDTH 35
#define HEART_HEIGHT 35

#import "FWTopView.h"
#import "ConstantsConfig.h"

@implementation FWTopView

- (void)initView:(NSString *)numberString
{
    self.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, HEART_WIDTH, HEART_HEIGHT)];
    self.textNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 18, 18)];
    self.textNumberLabel.textColor = [UIColor redColor];
    //        [self.textView setFont:[UIFont fontWithName:@"helveica-boldoblique" size:1]];
    [self.textNumberLabel setFont:[UIFont systemFontOfSize:10]];
    self.textNumberLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.heartImageView];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_colours_flag@2x.png"]];
    self.heartImageView.image = [UIImage imageNamed:@"icon_blur_heart@2x.png"];
    self.textNumberLabel.text = numberString;
}

@end

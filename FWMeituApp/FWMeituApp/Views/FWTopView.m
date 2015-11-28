//
//  FWTopView.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-18.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWTopView.h"
#import "ConstantsConfig.h"

@implementation FWTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 13, HEART_WIDTH, HEART_HEIGHT)];
        self.textNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 25, 18, 18)];
        self.textNumberLabel.textColor = [UIColor redColor];
        //        [self.textView setFont:[UIFont fontWithName:@"helveica-boldoblique" size:1]];
        [self.textNumberLabel setFont:[UIFont systemFontOfSize:10]];
        self.textNumberLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.heartImageView];
        [self addSubview:self.textNumberLabel];
    }
    return self;
}

- (void)initView:(NSString *)numberString
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_colours_flag@2x.png"]];
    self.heartImageView.image = [UIImage imageNamed:@"icon_blur_heart@2x.png"];
    self.textNumberLabel.text = numberString;
}

@end

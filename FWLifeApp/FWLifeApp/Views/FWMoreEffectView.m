//
//  FWMoreEffectView.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-11.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWMoreEffectView.h"

@interface FWMoreEffectView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label1;

@end

@implementation FWMoreEffectView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initView];
        self.backgroundColor = [UIColor colorWithRed:16.0 / 255 green:80.0 / 255 blue:252.0 / 255 alpha:1.0];
    }
    
    return self;
}

- (void)initView
{
    //50.75
    self.tv = [[FWTriangleView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.tv];
    
    self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 15, 25, 25)];
    self.iv.image = [UIImage imageNamed:@"icon_more_download_wihte@2x.png"];
    [self addSubview:self.iv];
    
    self.la = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 50, 20)];
    self.la.text = @"更多特效";
    [self.la  setFont:[UIFont systemFontOfSize:10]];
    self.la.textColor = [UIColor whiteColor];
    self.la.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.la];
    
    self.la1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 20, 14)];
//    NSLog(@"%@...", NSStringFromCGPoint(self.la1.center));
    self.la1.text = @"免费";
    self.la1.transform = CGAffineTransformMakeRotation((M_PI *(-45.0)) / 180);
    self.la1.textColor = [UIColor whiteColor];
    [self.la1 setFont:[UIFont boldSystemFontOfSize:10]];
    
    [self addSubview:self.la1];
}

-(void)setImage:(UIImage *)image text:(NSString *)text
{
    [self.tv removeFromSuperview];
    [self.la1 removeFromSuperview];
    self.iv.frame = self.bounds;
    self.iv.image = image;
    self.iv.contentMode = UIViewContentModeScaleAspectFit;
    
    self.la.text = text;
}

- (void)setImage:(UIImage *)image
{
    [self.tv removeFromSuperview];
    [self.la1 removeFromSuperview];
    self.iv.frame = self.bounds;
    self.iv.image = image;
    self.iv.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

@end

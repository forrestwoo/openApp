//
//  FWMoreEffectView.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-11.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWTriangleView.h"

@interface FWMoreEffectView : UIView

@property (nonatomic, strong) FWTriangleView *tv;
@property (nonatomic, strong) UILabel *la;
@property (nonatomic, strong) UILabel *la1;
@property (nonatomic, strong) UIImageView *iv;

-(void)setImage:(UIImage *)image text:(NSString *)text;

@end

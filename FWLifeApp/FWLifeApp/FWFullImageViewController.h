//
//  FWFullImageViewController.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/7.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWFullImageViewController : UIViewController

@property (nonnull,nonatomic, strong) UIImage *image;
@property (nonnull,nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithImage:(UIImage *)image;



@end

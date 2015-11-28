//
//  FWBeautyViewController.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-19.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWButton.h"
#import "FWFunctionViewController.h"

@interface FWBeautyViewController : UIViewController
{
    UIImagePickerController *imagePicker;
    FWButton *modeView ;
    UIColor *highlightedTextColor;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;

- (id)initWithImage:(UIImage *)image;
@end

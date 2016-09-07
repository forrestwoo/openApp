//
//  FWCropView.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-5.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface FWCropView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic) CGRect cropRect;

- (void)setupImageView;

@end

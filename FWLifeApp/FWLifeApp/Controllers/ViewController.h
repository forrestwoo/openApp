//
//  ViewController.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-16.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FWBeautyViewController.h"
#import "Masonry.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *btnArrow;
    FWBeautyViewController *beautyVC;
    UIImagePickerController *imagePicker;
}

@property (nonatomic ,strong) UIScrollView *scrolleView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


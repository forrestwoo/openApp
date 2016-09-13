//
//  FWDisplayBigImageViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/13.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWDisplayBigImageViewController.h"
#import "FWBeautyViewController.h"

@interface FWDisplayBigImageViewController ()

@end

@implementation FWDisplayBigImageViewController

- (id)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imageView];
    
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickImageView:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.delaysTouchesBegan = YES;
    [imageView addGestureRecognizer:doubleClick];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGes.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tapGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doubleClickImageView:(UITapGestureRecognizer *)gesture
{
    
    
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    FWBeautyViewController *beautyVC = [[FWBeautyViewController alloc] initWithImage:self.image];
    [self.navigationController pushViewController:beautyVC animated:YES];
}

@end

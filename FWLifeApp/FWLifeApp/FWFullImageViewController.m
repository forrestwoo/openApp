//
//  FWFullImageViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/7.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWFullImageViewController.h"

@implementation FWFullImageViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickImageView:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.delaysTouchesBegan = YES;
    [self.imageView addGestureRecognizer:doubleClick];
}

- (void)doubleClickImageView:(UITapGestureRecognizer *)gesture
{
    
    
}
@end

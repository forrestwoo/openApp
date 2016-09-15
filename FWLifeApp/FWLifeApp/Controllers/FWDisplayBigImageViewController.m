//
//  FWDisplayBigImageViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/13.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWDisplayBigImageViewController.h"
#import "FWBeautyViewController.h"
#import "MBProgressHUD.h"

@interface FWDisplayBigImageViewController ()
{
    UIScrollView *_scrollView;
    UIToolbar *_toolBar;
    UIImageView *_imageView;
    BOOL _oldBounces;
    MBProgressHUD *_HUD;
}

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
    
    [self initScrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.tag = 888;
    [_scrollView addSubview:_imageView];
    
    _imageView.image = self.image;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGes.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tapGes];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initToolBar
{
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [FWCommonTools heightOfDeviceScreen] - 44, [FWCommonTools widthOfDeviceScreen], 44)];
    UIBarButtonItem *bbiEdit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editImage:)];
    UIBarButtonItem *bbiShare = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareImage:)];
    UIBarButtonItem *bbiDownload = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStyleDone target:self action:@selector(downloadImage:)];

    _toolBar.items = [NSArray arrayWithObjects:bbiEdit,bbiShare, bbiDownload, nil];
    _toolBar.hidden = NO;
    [self.view addSubview:_toolBar];
}

- (void)editImage:(id)sender
{
    FWBeautyViewController *beautyVC = [[FWBeautyViewController alloc] initWithImage:self.image];
    [self.navigationController pushViewController:beautyVC animated:YES];
}

- (void)shareImage:(id)sender
{
    FWBeautyViewController *beautyVC = [[FWBeautyViewController alloc] initWithImage:self.image];
    [self.navigationController pushViewController:beautyVC animated:YES];
}

- (void)downloadImage:(id)sender
{
  
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeText;
    if(error != NULL){
        _HUD.labelText = @"保存失败";
    }else{
         _HUD.labelText = @"保存成功";
    }
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [_HUD removeFromSuperview];
    }];
}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.maximumZoomScale = 5;
    _scrollView.minimumZoomScale = 1;
    _scrollView.bouncesZoom = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    _oldBounces = scrollView.bounces;
    scrollView.bounces = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    scrollView.bounces =_oldBounces;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:888];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:10.0 animations:^{
            _toolBar.frame = CGRectMake(0, [FWCommonTools heightOfDeviceScreen], [FWCommonTools widthOfDeviceScreen], 44);
        } completion:^(BOOL finished) {
            _toolBar.frame = CGRectMake(0, [FWCommonTools heightOfDeviceScreen] - 44, [FWCommonTools widthOfDeviceScreen], 44);
        }];
        
    }
    
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            _toolBar.frame = CGRectMake(0, [FWCommonTools heightOfDeviceScreen] - 44, [FWCommonTools widthOfDeviceScreen], 44);
        } completion:^(BOOL finished) {
            _toolBar.frame = CGRectMake(0, [FWCommonTools heightOfDeviceScreen], [FWCommonTools widthOfDeviceScreen], 44);
        }];
        
    }
}



@end

//
//  ViewController.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-16.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//375*667

#import "ViewController.h"
#import "FWTopView.h"
#import "FWButton.h"
#import "UIImage+ImageScale.h"

@interface ViewController ()
@property (nonatomic, strong) FWTopView *topView;
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home@2x.jpg"]];
    self.scrolleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 137, 375, 393)];
    self.scrolleView.pagingEnabled = YES;
    self.scrolleView.contentSize = CGSizeMake(375 * 2, 393);
    self.scrolleView.showsHorizontalScrollIndicator = NO;
    self.scrolleView.showsVerticalScrollIndicator = NO;
    self.scrolleView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(162, 620, 50, 20)];
    self.pageControl.numberOfPages = 2;
    
    [self.view addSubview:self.scrolleView];
    [self.view addSubview:self.pageControl];
    
    [self setupScrollView];
    
    
    //    NSLog(@"%f,%f",size.width,size.height);
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_topview_topback_a.png"]];
    image.frame = CGRectMake(20, 40, 453/2, 103/2);
    [self.view addSubview:image];
    
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(330, 620, 39, 39);
    [btnSetting setImage:[UIImage imageNamed:@"btn_home_setting_a@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnSetting];
    
    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(335, 320, 30, 50);
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow@2x.png"] forState:UIControlStateNormal];
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow_highlight@2x.png"] forState:UIControlStateHighlighted];
    [btnArrow addTarget:self action:@selector(btnArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnArrow];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hanlderAction:) userInfo:nil repeats:YES];
    
    self.topView = [[FWTopView alloc] initWithFrame:CGRectMake(317,  0, TOPVIEW_WIDTH, TOPVIEW_HEIGHT)];
    [self.view addSubview:self.topView];
    [self.topView initView:@"20"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

//
- (void)hanlderAction:(NSTimer *)timer
{
    //    if (btnArrow.image.] == UIControlStateHighlighted)
    //    {
    //    }
}

- (void)btnArrowClicked:(id)sender
{
    if (self.pageControl.currentPage ) {
        self.pageControl.currentPage = 0;
        [self toLeftArrow];
    }else{
        self.pageControl.currentPage = 1;
        [self toRightArrow];

    }
    
    CGRect frame = self.scrolleView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    [self.scrolleView scrollRectToVisible:frame animated:YES];
}

- (void)toRightArrow
{
    btnArrow.frame = CGRectMake(10, 320, 30, 50);
    [btnArrow setImage:[UIImage imageNamed:@"left_arrow@2x.png"] forState:UIControlStateNormal];
}

- (void)toLeftArrow
{
    btnArrow.frame = CGRectMake(335, 320, 30, 50);
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow@2x.png"] forState:UIControlStateNormal];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(self.scrolleView.contentOffset.x / self.scrolleView.frame.size.width) ;
    self.pageControl.currentPage = index;
    
    if (index)
    {
        [self toRightArrow];
    }
    else
    {
        [self toLeftArrow];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)setupScrollView
{
    NSArray *imageViewImageArr = [NSArray arrayWithObjects:
                                  @"icon_home_beauty@2x.png", @"icon_home_cosmesis@2x.png", @"icon_home_puzzle@2x.png",
                                  @"icon_home_camera@2x.png", @"icon_home_material@2x.png", @"icon_home_meiyan@2x.png",
                                  @"icon_home_meipai@2x.png", @"icon_home_moreapp@2x.png",
                                  nil];
    
    NSArray *highLightedBackImageArr = [NSArray arrayWithObjects:
                                        @"home_block_red_b@2x.png", @"home_block_pink_b@2x.png", @"home_block_green_b@2x.png",
                                        @"home_block_orange_b@2x.png", @"home_block_blue_b@2x.png", @"item_bg_purple_b@2x.png",
                                        @"home_block_pink_b@2x.png", @"home_block_red_b@2x.png",
                                        nil];
    NSArray *imageViewBackImageArr = [NSArray arrayWithObjects:
                                      @"home_block_red_a@2x.png", @"home_block_pink_a@2x.png", @"home_block_green_a@2x.png",
                                      @"home_block_orange_a@2x.png", @"home_block_blue_a@2x.png", @"item_bg_purple_a@2x.png",
                                      @"home_block_pink_a@2x.png", @"home_block_red_a@2x.png",
                                      nil];

    NSArray *textArr = [NSArray arrayWithObjects:@"美化图片", @"人像美容", @"拼图", @"万能相机", @"素材中心", @"美颜相机", @"美拍", @"更多功能", nil];
    NSArray *xArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:65],[NSNumber numberWithInt:207], [NSNumber numberWithInt:65],[NSNumber numberWithInt:207],[NSNumber numberWithInt:65],[NSNumber numberWithInt:207],[NSNumber numberWithInt:440],[NSNumber numberWithInt:582],nil];
    NSArray *yArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], [NSNumber numberWithInt:144],[NSNumber numberWithInt:144],[NSNumber numberWithInt:281],[NSNumber numberWithInt:281],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],nil];
    
    //144.144+206+50,,,x+144,x+144+206+50...210*3+2*50=...300+210+52+210+52
//    FWFucView *fv = nil;
    FWButton *btnHome = nil;
    for (int i = 0; i < 8; i++) {
        btnHome = [FWButton buttonWithType:UIButtonTypeCustom];
        [btnHome setTitle:[textArr objectAtIndex:i] forState:UIControlStateNormal];
        [btnHome setImage:[UIImage imageNamed:[imageViewImageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btnHome setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[imageViewBackImageArr objectAtIndex:i]]]];
        [btnHome setBackgroundColorHighlighted:[UIColor colorWithPatternImage:[UIImage imageNamed:[highLightedBackImageArr objectAtIndex:i]]]];
        btnHome.frame =CGRectMake([(NSString *)[xArr objectAtIndex:i] floatValue], [(NSString *)[yArr objectAtIndex:i] floatValue], 103, 105);
[btnHome.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnHome addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnHome.topPading = 0.5;
        [self.scrolleView addSubview:btnHome];
    }
}

- (void)btnClicked:(id)sender
{
    if ([[(UIButton *)sender titleLabel].text isEqualToString:@"美化图片"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];

            }
             ];
        }
    }

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageCompressForWidth:selectedImage targetWidth:375];
    if (image.size.height > 520) {
        image = [UIImage imageCompressForWidth:selectedImage targetHeight:520];
    }
    currentImage = image;

        beautyVC = [[FWBeautyViewController alloc] initWithImage:currentImage];
        [imagePicker pushViewController:beautyVC animated:YES];
   
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaleToSize:(CGSize)Newsize
{
    UIGraphicsBeginImageContext(Newsize);
    
    [image drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:imagePicker completion:^{
        
    }];
}

@end

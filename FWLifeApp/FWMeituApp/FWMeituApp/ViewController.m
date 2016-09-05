//
//  ViewController.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-16.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.

#define kPadding     10
#define kBigPadding  30
#define kWidth       103
#define kHeight      105
#define kArrowWidth  30
#define kArrowHeight 50
#define kLogoWidth  250
#define kLogoHeight 79


#import "ViewController.h"
#import "FWButton.h"
#import "UIImage+ImageScale.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, assign) CGRect leftArrowFrame;
@property (nonatomic, assign) CGRect rightArrowFrame;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.delegate = self;
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"bg_home@2x.jpg"];
    [self.view addSubview:backImage];
    
    self.scrolleView = [[UIScrollView alloc] init];
     self.scrolleView.bounces = NO;
    self.scrolleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrolleView.showsHorizontalScrollIndicator = NO;
    self.scrolleView.pagingEnabled = YES;
    self.scrolleView.delegate = self;
    [self.view addSubview:self.scrolleView];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mtxx_logo@2x.png"]];
    image.frame = CGRectMake(0, 15, kLogoWidth, kLogoHeight);
    [self.view addSubview:image];
    
    self.rightArrowFrame = CGRectMake(WIDTH - kArrowWidth, HEIGHT / 2 - kArrowHeight / 2, kArrowWidth, kArrowHeight);
    self.leftArrowFrame = CGRectMake(5, HEIGHT / 2 - kArrowHeight / 2, kArrowWidth, kArrowHeight);
    
    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnArrow.frame = self.rightArrowFrame;
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow@2x.png"] forState:UIControlStateNormal];
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow_highlight@2x.png"] forState:UIControlStateHighlighted];
    [btnArrow addTarget:self action:@selector(btnArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnArrow];
    
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];

    [btnSetting setImage:[UIImage imageNamed:@"btn_home_setting_a@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnSetting];
    btnSetting.translatesAutoresizingMaskIntoConstraints = NO;
    
    /**
     NSLayoutConstraint apply
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8],
                                [NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-6],
                                [NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:39],
                                [NSLayoutConstraint constraintWithItem:btnSetting attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:btnSetting attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.scrolleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:image attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.scrolleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.scrolleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:WIDTH],
                                [NSLayoutConstraint constraintWithItem:self.scrolleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:HEIGHT - 47 - 61]
                                ]];
     **/
    
    [btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-8);
        make.right.equalTo(self.view.mas_right).with.offset(-6);
        make.width.equalTo(@39);
        make.height.equalTo(btnSetting.mas_width);
    }];
    
    [self.scrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(WIDTH-0));
        make.height.equalTo(@(HEIGHT - 47 - 79));
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((WIDTH - 50) / 2, HEIGHT - 39 , 50, 10)];
    self.pageControl.numberOfPages = 2;
    [self.view addSubview:self.pageControl];
    [self setupScrollView];
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
    btnArrow.frame = self.leftArrowFrame;
    [btnArrow setImage:[UIImage imageNamed:@"left_arrow@2x.png"] forState:UIControlStateNormal];
}

- (void)toLeftArrow
{
    btnArrow.frame = self.rightArrowFrame;
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
    
    FWButton *btnHome = nil;
    CGFloat padding = 0;
    if (WIDTH == 320)
        padding = kPadding;
    else
        padding = kBigPadding;
    
    CGFloat startX = WIDTH /  2 - padding / 2 - kWidth;
    CGFloat startY = HEIGHT / 2 - padding - kHeight / 2 - kHeight -  61;
    for (int i = 0; i < 8; i++) {
        NSInteger row  = i % 2;
        NSInteger col  = i / 2;
        NSInteger page = i / 6;
        
        if (col == 3) {
            col = 0;
        }
        
        btnHome = [FWButton button];
        [btnHome setTitle:[textArr objectAtIndex:i] forState:UIControlStateNormal];
        [btnHome setImage:[UIImage imageNamed:[imageViewImageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btnHome setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[imageViewBackImageArr objectAtIndex:i]]]];
        [btnHome setBackgroundColorHighlighted:[UIColor colorWithPatternImage:[UIImage imageNamed:[highLightedBackImageArr objectAtIndex:i]]]];
        btnHome.frame = CGRectMake(row * (kWidth + padding) + page * WIDTH + startX, col * (kHeight + padding) + startY, kWidth, kHeight);
        [btnHome.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [btnHome addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnHome.topPading = 0.5;
        
        [self.scrolleView addSubview:btnHome];
        self.scrolleView.contentSize = CGSizeMake(WIDTH * 2, kHeight * 3 + padding * 2);
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
    beautyVC = [[FWBeautyViewController alloc] initWithImage:selectedImage];
    
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

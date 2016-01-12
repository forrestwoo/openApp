//
//  FWBorderViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWBorderViewController.h"
#import "FWDataManager.h"
#import "FWMoreEffectView.h"
#import "UIImage+ImageScale.h"

#define kWidth 50
#define kHeight 70
#define kSpace 22

@interface FWBorderViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) FWEffectBar *borderStyleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation FWBorderViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //显示图片
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 130);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    //保存与取消按钮的添加
    UIImage *i1 = [UIImage imageNamed:@"btn_cancel_a@2x.png"];
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setImage:i1 forState:UIControlStateNormal];
    self.btnClose.frame = CGRectMake(20, HEIGHT - kCancelHeight - 10, kCancelHeight, kCancelHeight);
    [self.btnClose addTarget:self action:@selector(btnCancelOrSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnClose];
    
    UIImage *i2 = [UIImage imageNamed:@"btn_ok_a@2x.png"];
    self.btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSave setImage:i2 forState:UIControlStateNormal];
    self.btnSave.frame = CGRectMake(WIDTH - kCancelHeight - 20, HEIGHT - kCancelHeight - 10, kCancelHeight, kCancelHeight);
    [self.view addSubview:self.btnSave];
    [self.btnSave addTarget:self action:@selector(btnCancelOrSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(50, HEIGHT - 40, 200, 20)];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];

    NSArray *titles = [NSArray arrayWithObjects:@"海报边框", @"简单边框", @"炫彩边框", nil];
    for (int i = 0; i < [titles count]; i ++)
    {
        FWEffectBarItem *item = [[FWEffectBarItem alloc] initWithFrame:CGRectZero];
        item.title = [titles objectAtIndex:i];
        
        [items addObject:item];
    }

    self.styleBar.items = items;
    self.styleBar.effectBarDelegate = self;
    [self.styleBar setSelectedItem:[self.styleBar.items objectAtIndex:0]];
    [self effectBar:self.styleBar didSelectItemAtIndex:0];
    [self.view addSubview:self.styleBar];
    
    FWMoreEffectView *seView = [[FWMoreEffectView alloc] initWithFrame:CGRectMake(15, HEIGHT - 50 - kHeight, kWidth, kHeight)];
    [self.view addSubview:seView];
    
    self.borderStyleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(70, HEIGHT - 50 - kHeight, WIDTH - 70, kHeight)];
    self.borderStyleBar.effectBarDelegate = self;
    self.borderStyleBar.itemBeginX = 15.0;
    self.borderStyleBar.itemWidth = 50.0;
    self.borderStyleBar.margin = 10.0;
    [self.view addSubview:self.borderStyleBar];
    [self setupPosterBorder];
}

- (void)setupBorderEffect:(NSArray *)images
{
    FWEffectBarItem *item = nil;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [images count]; i++)
    {
        item = [[FWEffectBarItem alloc] initWithFrame:CGRectMake((kWidth + kSpace) * i + 10, 0, kWidth, kHeight)];
        item.backgroundColor = [UIColor whiteColor];
        UIImage *img1 = [UIImage scaleImage:[UIImage imageNamed:[images objectAtIndex:i]] targetWidth:50];
        
        [item setFinishedSelectedImage:img1 withFinishedUnselectedImage:img1];
        [items addObject:item];
    }
    
    self.borderStyleBar.items = items;
}

//简单边框视图
- (void)setupSimpleBorderView
{
    [self setupBorderEffect:[NSArray arrayWithObjects:@"border_baikuang_a.jpg", @"border_baolilai_a.jpg", @"border_heikuang_a.jpg", @"border_luxiangji_a.jpg", @"border_onenight_a.jpg", @"border_simple_15.jpg", @"border_simple_16.jpg", @"border_simple_17.jpg", @"border_simple_18.jpg", @"border_simple_19.jpg",nil]];
}

//海报边框视图
- (void)setupPosterBorder
{
    [self setupBorderEffect:[NSArray arrayWithObjects:@"pb1", @"pb2", @"pb3", @"pb4", @"pb5", @"pb6", @"pb7", @"pb8", @"pb9", @"pb10",nil]];
}

//炫彩边框视图
- (void)setupDazzleBorder
{
    [self setupBorderEffect:[NSArray arrayWithObjects:@"xborder_aixin_a.jpg", @"xborder_guangyun_a.jpg", @"xborder_qisehua_a.jpg", @"xborder_wujiaoxing_a.jpg", @"xborder_xueye_a.jpg", @"xborder_yinhe_a.jpg",nil]];
}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    if (bar == self.styleBar)
    {
        switch (index) {
            case 0:
                [self setupPosterBorder];
                break;
                
            case 1:
                [self setupSimpleBorderView];
                break;
                
            case 2:
                [self setupDazzleBorder];
                break;
        }
    }
    else
    {
        FWEffectBarItem *item = (FWEffectBarItem *)[bar.items objectAtIndex:index];
        item.ShowBorder = YES;
    }
    
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//保存与取消操作
- (void)btnCancelOrSaveClicked:(id)sender
{
    if (sender == self.btnClose) {
        
    }else if(sender == self.btnSave){
        //        UIImageWriteToSavedPhotosAlbum(self.currentImage, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

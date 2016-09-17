//
//  FWFiltersViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/8.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWFiltersViewController.h"

#import "FWDataManager.h"
#import "FWMoreEffectView.h"
#import "UIImage+ImageScale.h"
#import "FWApplyFilter.h"

#define kWidth 50
#define kHeight 70
#define kSpace 22

@interface FWFiltersViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) FWEffectBar *filterStyleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;

@property BOOL isBlurActivate;
@property BOOL isDarkCornerActivate;

@end

@implementation FWFiltersViewController

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
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(50, HEIGHT - 40, 280, 20)];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *titles = [NSArray arrayWithObjects:@"LOMO", @"美颜", @"格调", @"艺术", nil];
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
    
    UIButton * btnBlur = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBlur setImage:[UIImage imageNamed:@"blur_deactivated"] forState:UIControlStateNormal];
    self.isBlurActivate = NO;
    btnBlur.frame = CGRectMake(10, HEIGHT - 45 - kHeight, 25, 25);
    [btnBlur addTarget:self action:@selector(btnBlurClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnBlur.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnBlur];
    
    UIButton * btnDark = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnDark setImage:[UIImage imageNamed:@"dark_corner_deactivated"] forState:UIControlStateNormal];
    self.isDarkCornerActivate = NO;
    btnDark.frame = CGRectMake(10, HEIGHT - 10 - kHeight, 25, 25);
    [btnDark addTarget:self action:@selector(btnDarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnDark.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnDark];
    
    self.filterStyleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(50, HEIGHT - 50 - kHeight, WIDTH - 70, kHeight)];
    self.filterStyleBar.effectBarDelegate = self;
    self.filterStyleBar.itemBeginX = 15.0;
    self.filterStyleBar.itemWidth = 50.0;
    self.filterStyleBar.margin = 10.0;
    [self.view addSubview:self.filterStyleBar];
    [self setupLOMOFilter];
}

- (void)btnBlurClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if (self.isBlurActivate)
    {
        [btn setImage:[UIImage imageNamed:@"blur_deactivated"] forState:UIControlStateNormal];
        self.isBlurActivate = NO;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"blur_activated"] forState:UIControlStateNormal];
        self.isBlurActivate = YES;
    }
}

- (void)btnDarkClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.isBlurActivate)
    {
        [btn setImage:[UIImage imageNamed:@"dark_corner_deactivated"] forState:UIControlStateNormal];
        self.isDarkCornerActivate = NO;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"dark_corner_activated"] forState:UIControlStateNormal];
        self.isDarkCornerActivate = YES;
    }
}

- (void)setupFilterWithNormalImages:(NSArray *)normalImages HighlightImages:(NSArray *)highlightImages titles:(NSArray *)titles
{
    FWEffectBarItem *item = nil;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [titles count]; i++)
    {
        item = [[FWEffectBarItem alloc] initWithFrame:CGRectMake((kWidth + kSpace) * i + 10, 0, kWidth, kHeight)];
        item.titleOverlay = YES;
        item.backgroundColor = [UIColor blackColor];
        UIImage *img = [UIImage scaleImage:self.image targetHeight:70];
        
        [item setFinishedSelectedImage:img withFinishedUnselectedImage:img];
        item.title = [titles objectAtIndex:i];
        [items addObject:item];
    }
    
    self.filterStyleBar.items = items;
}

//简单边框视图
- (void)setupLOMOFilter
{
    [self setupFilterWithNormalImages:nil HighlightImages:nil titles:[NSArray arrayWithObjects:@"原图", @"LOMO", @"流年", @"HDR", @"碧波", @"上野", @"优格", @"彩虹瀑", @"云端", @"淡雅", @"粉红佳人", @"复古", @"候鸟", @"黑白", @"一九〇〇", @"古铜色", @"哥特风", @"移轴", @"TEST1", @"TEST2", @"TEST3", nil]];
}

//海报边框视图
- (void)setupBeautyFilter
{
    [self setupFilterWithNormalImages:nil HighlightImages:nil titles:[NSArray arrayWithObjects:@"原图", @"经典LOMO", @"流年", @"HDR", @"碧波", @"上野", @"优格", @"彩虹瀑", @"云端", @"淡雅", @"粉红佳人", @"复古", @"候鸟", @"黑白", @"一九〇〇", @"古铜色", @"哥特风", @"移轴",nil]];
}

//炫彩边框视图
- (void)setupPatternFilter
{
    [self setupFilterWithNormalImages:nil HighlightImages:nil titles:[NSArray arrayWithObjects:@"原图", @"经典LOMO", @"流年", @"HDR", @"碧波", @"上野", @"优格", @"彩虹瀑", @"云端", @"淡雅", @"粉红佳人", @"复古", @"候鸟", @"黑白", @"一九〇〇", @"古铜色", @"哥特风", @"移轴",nil]];
}

- (void)setupArtistFilter
{
    [self setupFilterWithNormalImages:nil HighlightImages:nil titles:[NSArray arrayWithObjects:@"原图", @"经典LOMO", @"流年", @"HDR", @"碧波", @"上野", @"优格", @"彩虹瀑", @"云端", @"淡雅", @"粉红佳人", @"复古", @"候鸟", @"黑白", @"一九〇〇", @"古铜色", @"哥特风", @"移轴",nil]];
}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    if (bar == self.styleBar)
    {
        switch (index) {
            case 0:
                [self setupLOMOFilter];
                break;
                
            case 1:
                [self setupBeautyFilter];
                break;
                
            case 2:
                [self setupPatternFilter];
                break;
                
            case 3:
                [self setupArtistFilter];
                break;
        }
    }
    else
    {
        FWEffectBarItem *item = (FWEffectBarItem *)[bar.items objectAtIndex:index];
        item.ShowBorder = YES;
        [self.filterStyleBar scrollRectToVisible:item.frame  animated:YES];

        switch (index) {
            case 0:
                self.currentImage = self.image;
                break;
                
            case 1:
                self.currentImage = [FWApplyFilter applyLomofiFilter:self.image];
                break;
                
            case 2:
                self.currentImage = [FWApplyFilter applyLomo1Filter:self.image];
                break;
                
            case 3:
                self.currentImage =[FWApplyFilter applyMissetikateFilter:self.image];
                break;
                
            case 4:
                self.currentImage =[FWApplyFilter applyNashvilleFilter:self.image];
                break;
                
            case 5:
                self.currentImage =[FWApplyFilter applyLordKelvinFilter:self.image];
                break;
                
            case 6:
                self.currentImage = [FWApplyFilter applyAmatorkaFilter:self.image];
                break;
                
            case 7:
                self.currentImage = [FWApplyFilter applyRiseFilter:self.image];
                break;
                
            case 8:
                self.currentImage= [FWApplyFilter applyHudsonFilter:self.image];
                break;
                
            case 9:
                self.currentImage = [FWApplyFilter applyXproIIFilter:self.image];
                break;
                
            case 10:
                self.currentImage =[FWApplyFilter apply1977Filter:self.image];
                break;
                
            case 11:
                self.currentImage =[FWApplyFilter applyValenciaFilter:self.image];
                break;
                
            case 12:
                self.currentImage =[FWApplyFilter applyWaldenFilter:self.image];
                break;
                
            case 13:
                self.currentImage = [FWApplyFilter applyLomofiFilter:self.image];
                break;
                
            case 14:
                self.currentImage = [FWApplyFilter applyInkwellFilter:self.image];
                break;
                
            case 15:
                self.currentImage= [FWApplyFilter applySierraFilter:self.image];
                break;
                
            case 16:
                self.currentImage = [FWApplyFilter applyEarlybirdFilter:self.image];
                break;
                
            case 17:
                self.currentImage =[FWApplyFilter applySutroFilter:self.image];
                break;
                
            case 18:
                self.currentImage =[FWApplyFilter applyToasterFilter:self.image];
                self.imageView.image = self.currentImage;
                break;
                
            case 19:
                self.currentImage =[FWApplyFilter applyBrannanFilter:self.image];
                break;
                
            case 20:
                self.currentImage = [FWApplyFilter applyHefeFilter:self.image];
                break;
        }
        
        self.imageView.image = self.currentImage;
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

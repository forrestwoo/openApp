//
//  FWBlurViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/14.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWBlurViewController.h"
#import "FWDataManager.h"
#import "FWApplyFilter.h"

@interface FWBlurViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIButton *btnBlurType;
@property NSInteger selectedIndex;

@end

@implementation FWBlurViewController

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
    
    self.selectedIndex = 0;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //显示图片
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 115);
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
    
    [self setupSlider];
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(90, HEIGHT - 55, 180, 55)];
    
    NSDictionary *autoDict = [[FWDataManager getDataSourceFromPlist] objectForKey:@"Blur"];
    NSArray *normalImageArr = [autoDict objectForKey:@"normalImages"];
    NSArray *hightlightedImageArr = [autoDict objectForKey:@"HighlightedImages"];
    NSArray *textArr = [autoDict objectForKey:@"Texts"];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [textArr count]; i++)
    {
        FWEffectBarItem *item = [[FWEffectBarItem alloc] initWithFrame:CGRectZero];
        [item setFinishedSelectedImage:[UIImage imageNamed:[hightlightedImageArr objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[normalImageArr objectAtIndex:i]] ];
        item.title = [textArr objectAtIndex:i];
        [items addObject:item];
    }
    self.styleBar.items = items;
    self.styleBar.effectBarDelegate = self;
    [self.styleBar setSelectedItem:[self.styleBar.items objectAtIndex:0]];
    [self effectBar:self.styleBar didSelectItemAtIndex:0];
    [self.view addSubview:self.styleBar];
    
     self.btnBlurType = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBlurType setImage:[UIImage imageNamed:@"icon_blur_null"] forState:UIControlStateNormal];
    [self.btnBlurType addTarget:self action:@selector(btnBlurClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnBlurType.frame = CGRectMake(20, HEIGHT - 90, 30, 30);
    [self.view addSubview:self.btnBlurType];
}

- (void)btnBlurClicked:(id)sender
{
    if (self.subView)
    {
        return;
    }
    
    [self setupSharpView];
}

- (void)hideShapeView
{
    [self.subView removeFromSuperview];
    self.subView = nil;
}
- (void)setupSharpView
{
    NSArray *arr = [NSArray arrayWithObjects:@"icon_blur_null", @"icon_blur_center", @"icon_blur_heart", @"icon_blur_star", @"icon_blur_heptagon", nil];
    self.subView = [[UIView alloc] initWithFrame:CGRectMake(10, HEIGHT - 135, 250, 35)];

    for (int i = 0; i < [arr count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10 + (35 + 10) * i, 0, 35, 35);
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10000 + i;
        [self.subView addSubview:btn];
    }
    
    [self.view addSubview:self.subView];
}

- (void)tap:(id)sender
{
    [self hideShapeView];
    
    [self.btnBlurType setImage:((UIButton *)sender).currentImage forState:UIControlStateNormal];
    switch (((UIButton *)sender).tag) {
        case 10000:
            self.currentImage = [FWApplyFilter applyGaussianBlur:self.image];
            break;
            
        case 10001:
            self.currentImage = [FWApplyFilter applyGaussianSelectiveBlur:self.image];
            break;
            
        case 10002:
            self.currentImage = [FWApplyFilter applyiOSBlur:self.image];
            break;
            
        case 10003:
            self.currentImage = [FWApplyFilter applyMotionBlur:self.image];
            break;
            
        case 10004:
            self.currentImage = [FWApplyFilter applyZoomBlur:self.image];
            break;
    }
    self.imageView.image = self.currentImage;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideShapeView];
}

- (void)setupSlider
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake((WIDTH - 180) / 2 + 40, HEIGHT - 90, 180, 30)];
    self.slider.minimumValue = -100;
    self.slider.maximumValue = 100;
    self.slider.value = 0;
    [self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_slider_thumb"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.slider];
}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    if (self.subView)
    {
        [self hideShapeView];
    }
    
    self.selectedIndex = index;
    switch (index) {
        case 0:
            
            break;
            
        default:
            break;
    }
}

- (void)updateValue:(id)sender
{
    
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

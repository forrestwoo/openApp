//
//  FWColorListViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWColorListViewController.h"
#import "FWDataManager.h"

#import "FWCommonFilter.h"

@interface FWColorListViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) FWSlider *slider;

@property NSInteger selectedIndex;

@end

@implementation FWColorListViewController

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
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 105, WIDTH, kBarHeight)];
    
    NSDictionary *autoDict = [[FWDataManager getDataSourceFromPlist] objectForKey:@"ColorList"];
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
}

- (void)setupSlider
{
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 115 - 40, WIDTH, 40)];
    subview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:subview];
    
    self.slider = [[FWSlider alloc] initWithFrame:CGRectZero];
    self.slider.minimumValue = -100;
    self.slider.maximumValue = 100;
    self.slider.value = 0;
    self.slider.frame = CGRectMake(WIDTH / 2 - 100, 10, 200, 20);
    [self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(updateTipView:) forControlEvents:UIControlEventValueChanged];
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_slider_thumb"] forState:UIControlStateNormal];
    
    [subview addSubview:self.slider];
    self.slider.tipView.currentValueLabel.text = [NSString stringWithFormat:@"%f",self.slider.value];

}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    switch (index) {
        case 0:
            self.slider.minimumValue = -.5;
            self.slider.maximumValue = 0.5;
            self.slider.value = 0.0;
            break;
            
        case 1:
            self.slider.minimumValue = 0.1;
            self.slider.maximumValue = 1.9;
            self.slider.value = 1.0;
            
            break;
            
        case 2:
            self.slider.minimumValue = 1000;
            self.slider.maximumValue = 10000;
            self.slider.value = 5000;
            
            break;
            
        case 3:
            self.slider.minimumValue = 0.0;
            self.slider.maximumValue = 2.0;
            self.slider.value = 1.0;
            break;
            
        case 4:
            self.slider.minimumValue = 0.0;
            self.slider.maximumValue = 1.0;
            self.slider.value = 0.5;
            break;
            
        case 5:
            self.slider.minimumValue = 0.0;
            self.slider.maximumValue = 1.0;
            self.slider.value = 0.5;
            break;
            
        case 6:
            self.slider.minimumValue = -5;
            self.slider.maximumValue = 5;
            self.slider.value = 0;
            break;
            
        default:
            break;
    }
}

- (void)updateTipView:(id)sender
{
    //    FWTipView *tip = [[FWTipView alloc] initWithFrame:CGRectMake(100, self.slider.superview.frame.origin.y - 25, 28, 25)];
    //    [self.view addSubview:tip];
    self.slider.tipView.currentValueLabel.text = [NSString stringWithFormat:@"%f",self.slider.value];
}

- (void)updateValue:(id)sender
{
    switch (self.selectedIndex) {
        case 0:
            self.currentImage = [FWCommonFilter changeValueForBrightnessFilter:self.slider.value image:self.image];
            break;
            
        case 1:
            self.currentImage = [FWCommonFilter changeValueForContrastFilter:self.slider.value image:self.image];
            self.imageView.image =   self.currentImage;
            break;
            
        case 2:
            self.currentImage = [FWCommonFilter changeValueForWhiteBalanceFilter:self.slider.value image:self.image];
            break;
            
        case 3:
            self.currentImage = [FWCommonFilter changeValueForSaturationFilter:self.slider.value image:self.image];
            break;
            
        case 4:
            self.currentImage = [FWCommonFilter changeValueForHightlightFilter:self.slider.value image:self.image];
            break;
            
        case 5:
            self.currentImage = [FWCommonFilter changeValueForLowlightFilter:self.slider.value image:self.image];
            break;
            
        case 6:
            self.currentImage = [FWCommonFilter changeValueForExposureFilter:self.slider.value image:self.image];
            break;
            
        default:
            break;
    }
    
    self.imageView.image = self.currentImage;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

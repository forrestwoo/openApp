//
//  FWFunctionViewController.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-23.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#define kWidth 50
#define kHeight 70
#define kSpace 22
#define kBegainX 81
#define kBarHeight 55
#define kbarBeginY 105

#import "FWFunctionViewController.h"
#import "ConstantsConfig.h"
#import "FWCommonFilter.h"
#import "UIButton+TextAndImageHorizontalDisplay.h"
#import "FWCropView.h"
#import "FWMoreEffectView.h"
#import "UIImage+ImageScale.h"
#import "FWVideoCamera.h"

@interface FWFunctionViewController ()
{
    NSInteger selectedIndex ;
}

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) FWCropView *cropView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FWVideoCamera *videoCamera;
@property (nonatomic, strong) FWEffectBar *styleBar;

@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) FWEffectBar *effectBar;
@property (nonatomic, strong) FWEffectBar *typeBar;
@property (nonatomic, strong) FWSlider *slider;

@property (nonatomic, strong) NSArray *normalImageArr;
@property (nonatomic, strong) NSArray *hightlightedImageArr;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, assign) FWBeautyProcessType type;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIScrollView *scaleScrollView;

@end

@implementation FWFunctionViewController

- (id)initWithImage:(UIImage *)image type:(FWBeautyProcessType)type
{
    if (self = [super init]) {
        self.image = image;
        self.type = type;
    }
    
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = 0;
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    
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
}

//配置呈现所要处理图片的UIImageView
- (void)setupImageView
{
    if (self.type == FWBeautyProcessTypeAutoBeauty || self.type == FWBeautyProcessTypeColorList)
    {
        //105 = 设备高 - 关闭按钮高度 - 3段间距：30 - bar高度：55 - 的结果
        self.imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 115);
    }
    else if(self.type == FWBeautyProcessTypeEdit)
    {
        UIImage *img = [UIImage scaleImage:self.image targetWidth:WIDTH];
        CGFloat x = 0;
        CGFloat y = 0;
        //HEIGHT - 115
        if (img.size.height > HEIGHT - 115)
        {
            img = [UIImage scaleImage:img targetHeight:HEIGHT - 115];
            x = WIDTH / 2 - img.size.width /2;
        }
        else
        {
            y =( HEIGHT - 115) / 2 - img.size.height / 2;
        }
        self.imageView.image = img;
        self.imageView.frame = CGRectMake(x, y, img.size.width, img.size.height);
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.imageView];
}

//配置单选项卡
- (void)setupBar
{
    self.styleBar = [[FWEffectBar alloc] init];
    NSDictionary *autoDict = nil;
    
    if (self.type == FWBeautyProcessTypeAutoBeauty || self.type == FWBeautyProcessTypeColorList)
    {
        self.styleBar.frame = CGRectMake(0,HEIGHT - 105, WIDTH, 55);
        
        if (self.type == FWBeautyProcessTypeAutoBeauty )
            autoDict = [[FWCommonTools getPlistDictionaryForButton] objectForKey:@"AutoBeauty"];
        else
            autoDict = [[FWCommonTools getPlistDictionaryForButton] objectForKey:@"ColorValue"];
        
    }
    else if (self.type == FWBeautyProcessTypeEdit)
    {
        self.styleBar.frame = CGRectMake(100, HEIGHT - 55, 160, 55);
        
        autoDict = [[FWCommonTools getPlistDictionaryForButton] objectForKey:@"Edit"];
        
    }
    
    NSArray *normalImageArr = [autoDict objectForKey:@"normalImages"];
    NSArray *hightlightedImageArr = [autoDict objectForKey:@"HighlightedImages"];
    NSArray *textArr = [autoDict objectForKey:@"Texts"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [textArr count]; i++)
    {
        FWEffectBarItem *item = [[FWEffectBarItem alloc] initWithFrame:CGRectZero];
        [item setFinishedSelectedImage:[UIImage imageNamed:[hightlightedImageArr objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[normalImageArr objectAtIndex:i]] ];
        item.title = [textArr objectAtIndex:i];
        [arr addObject:item];
    }
    
    self.styleBar.items = arr;
    
    self.styleBar.effectBardelegate = self;
    [self.styleBar setSelectedItem:[self.styleBar.items objectAtIndex:0]];
    [self.view addSubview:self.styleBar];
    [self effectBar:self.styleBar didSelectItemAtIndex:0];
}

- (void)setupSliderForColorList
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

- (void)updateTipView:(id)sender
{
    //    FWTipView *tip = [[FWTipView alloc] initWithFrame:CGRectMake(100, self.slider.superview.frame.origin.y - 25, 28, 25)];
    //    [self.view addSubview:tip];
    self.slider.tipView.currentValueLabel.text = [NSString stringWithFormat:@"%f",self.slider.value];
}


- (void)displayAutoBeautyPage
{
    [self setupImageView];
    [self setupBar];
}

- (void)displayColorListPage
{
    [self setupImageView];
    [self setupBar];
    [self setupSliderForColorList];
}

- (void)displayEditPage
{
    [self setupImageView];
    [self setupBar];
    [self setupButtonsForClipView];
}

- (void)setupButtonsForClipView
{
    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnReset setTitle:@"重置" forState:UIControlStateNormal];
    
    btnReset.frame = CGRectMake(30, HEIGHT - 95, 50, 30);
    [btnReset.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReset.layer.borderWidth = 0.5;
    btnReset.layer.cornerRadius = 15.0;
    btnReset.layer.borderColor = [UIColor whiteColor].CGColor;
    btnReset.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:26/ 255.0 blue:26/ 255.0 alpha:0.8];
    [self.view addSubview:btnReset];
    
    UIButton *btnScaleType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnScaleType setTitle:@"比例：自由" forState:UIControlStateNormal];
    [btnScaleType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnScaleType.frame = CGRectMake(100, HEIGHT - 95, 80, 30);
    [btnScaleType.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    btnScaleType.layer.borderWidth = 0.5;
    btnScaleType.layer.cornerRadius = 15.0;
    btnScaleType.layer.borderColor = [UIColor whiteColor].CGColor;
    [btnScaleType addTarget:self action:@selector(scaleTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnScaleType];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeSystem];
    btnConfirm.backgroundColor = [UIColor blueColor];
    [btnConfirm setImage:[UIImage imageNamed:@"icon_clip_confim@2x.png"] withTitle:@"确定裁剪" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.layer.cornerRadius = 15.0;
    btnConfirm.frame = CGRectMake(240, HEIGHT - 95, 90, 30);
    [self.view addSubview:btnConfirm];
}

- (void)setupButtonsForRotaion
{

}

- (void)setupButtonsForSharpen
{
    
}

- (void)scaleTypeClick:(id)sender
{
    if (self.scaleScrollView)
    {
        [self.scaleScrollView removeFromSuperview];
        self.scaleScrollView = nil;
        
        return;
    }
    [self setupCropScaleView];
}

- (void)setupCropScaleView
{
    self.scaleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT - 55 - 10 - 30 - 10 - 52, WIDTH, 52)];
    self.scaleScrollView.contentSize = CGSizeMake(WIDTH * 1.5, 52);
    self.scaleScrollView.bounces = NO;
    self.scaleScrollView.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:26/ 255.0 blue:26/ 255.0 alpha:0.8];
    self.scaleScrollView.alpha = 0.9;
    self.scaleScrollView.showsHorizontalScrollIndicator = YES;
    NSDictionary *dict = [[FWCommonTools getPlistDictionaryForButton] objectForKey:@"scaleMode"];
    NSArray *normalImageArr = [dict objectForKey:@"normalImages"];
    NSArray *hightlightedImageArr = [dict objectForKey:@"HighlightedImages"];
    NSArray *textArr = [dict objectForKey:@"Texts"];
    
    CGFloat beginX = 20.0;
    CGFloat width = 30;
    CGFloat height = 48;
    CGFloat margin = 50;
    FWEffectBarItem *item = nil;
    
    for (int i = 0; i < [normalImageArr count]; i++)
    {
        item = [[FWEffectBarItem alloc] initWithFrame:CGRectMake(beginX + i * (margin + width), 2, width, height)];
        [item setFinishedSelectedImage:[UIImage imageNamed:[hightlightedImageArr objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[normalImageArr objectAtIndex:i]]];
        item.title = [textArr objectAtIndex:i];
        [self.scaleScrollView addSubview:item];
    }
    [self.view addSubview:self.scaleScrollView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
}

- (void)setupSEView
{
    FWMoreEffectView *seView = [[FWMoreEffectView alloc] initWithFrame:CGRectMake(15, 667-53-70, 50, 70)];
    [self.view addSubview:seView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15 + 50 + 15, 667-53-70, 375, 70)];
    self.scrollView.contentSize = CGSizeMake(1000, 70);
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    
    //ox 4 pad 15
    FWMoreEffectView *effectView = nil;
    effectView = [[FWMoreEffectView alloc] initWithFrame:CGRectMake((kWidth + kSpace) * 0, 0, kWidth, kHeight)];
    //    [self.videoCamera setRawImage:[UIImage imageNamed:@"effect.png"]];
    //    [self.videoCamera switchFilter:1];
    [effectView setImage:self.image text:@"test"];
    
    [self.scrollView addSubview:effectView];
    //    for (int i = 0; i < 8; i++) {
    //
    //    }
}

- (void)btnCancelOrSaveClicked:(id)sender
{
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
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

- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
    selectedIndex =index;
    if(self.type == FWBeautyProcessTypeColorList)
    {
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
    else if(self.type == FWBeautyProcessTypeAutoBeauty)
    {
        switch (index) {
            case 0:
                self.imageView.image = self.image;
                break;
                
            case 1:
                self.currentImage = [FWCommonFilter autoBeautyFilter:self.image];
                self.imageView.image = self.currentImage;
                break;
        }
    }
}

- (void)effectFunc
{
    
}

- (void)updateValue:(id)sender
{
    switch (selectedIndex) {
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

@end

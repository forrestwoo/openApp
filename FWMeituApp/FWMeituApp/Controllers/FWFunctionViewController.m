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

#import "FWFunctionViewController.h"
#import "ConstantsConfig.h"
#import "FWCommonFilter.h"
#import "UIButton+TextAndImageHorizontalDisplay.h"
#import "FWCropView.h"
#import "FWMoreEffectView.h"
#import "UIImage+ImageScale.h"
#import "FWVideoCamera.h"
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

@end

@implementation FWFunctionViewController

- (id)initWithImage:(UIImage *)image normalImageArr:(NSArray *)normalImageArray highlightedImageArr:(NSArray *)highlightedImageArr textArr:(NSArray *)textArray type:(NSString *)type
{
    if (self = [super init])
    {
        self.normalImageArr = normalImageArray;
        self.hightlightedImageArr = highlightedImageArr;
        self.texts = textArray;
        self.itemCount = [normalImageArray count];
        self.FunctionType = type;
        self.image = image;
        self.videoCamera = [[FWVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack highVideoQuality:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = 0;
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - kTitleWidth) / 2, 10, kTitleWidth, kTitleHeight)];
    title.text = self.FunctionType;
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    CGSize size = self.image.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    CGFloat xPoiont = 0;
    CGFloat yPoint = 64;
    if (imageWidth == 375) {
        yPoint = (460 - imageHeight) / 2.0 + 64;
    }
    if (imageHeight == 460) {
        xPoiont = (375 - imageWidth) / 2.0 ;
    }
    
    self.imageView.frame = CGRectMake(xPoiont, yPoint, 375, 520);
    [self.imageView sizeToFit];
    [self.view addSubview:self.imageView];
    
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
    
    self.typeBar = [[FWEffectBar alloc] initWithFrame:CGRectZero];
    self.typeBar.delegate = self;
    [self.view addSubview:self.typeBar];
    
    self.effectBar = [[FWEffectBar alloc] initWithFrame:CGRectZero];
    self.effectBar.delegate = self;
    [self.view addSubview:self.effectBar]; 
}

- (void)updateValue:(id)sender
{
    switch (selectedIndex) {
        case 0:
            self.currentImage = [FWCommonFilter changeValueForBrightnessFilter:self.slider.value image:self.image];
            self.imageView.image = self.currentImage;
            break;
            
        case 1:
            self.currentImage = [FWCommonFilter changeValueForContrastFilter:self.slider.value image:self.image];
            self.imageView.image =   self.currentImage;
            break;
            
        case 2:
            self.currentImage = [FWCommonFilter changeValueForWhiteBalanceFilter:self.slider.value image:self.image];
            self.imageView.image =  self.currentImage;
            break;
            
        case 3:
            self.currentImage = [FWCommonFilter changeValueForSaturationFilter:self.slider.value image:self.image];
            self.imageView.image = self.currentImage;
            break;
            
        case 4:
            self.currentImage = [FWCommonFilter changeValueForHightlightFilter:self.slider.value image:self.image];
            self.imageView.image =   self.currentImage;
            break;
            
        case 5:
            self.currentImage = [FWCommonFilter changeValueForLowlightFilter:self.slider.value image:self.image];
            self.imageView.image =  self.currentImage;
            break;
            
        case 6:
            self.currentImage = [FWCommonFilter changeValueForExposureFilter:self.slider.value image:self.image];
            self.imageView.image =   self.currentImage;
            break;
            
        default:
            break;
    }
}

- (void)setupSliderWithFrame:(CGRect)frame
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.slider.minimumValue = -100;
    self.slider.maximumValue = 100;
    self.slider.value = 0;
    
    [self.view addSubview:self.slider];
    self.slider.frame = frame;
    [self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupEffectBarWithFrame:(CGRect)frame items:(NSArray *)items
{
    self.effectBar.frame = frame;
    
    self.effectBar.items = items;
}

- (void)setupTypeBarWithFrame:(CGRect)frame items:(NSArray *)items
{
    self.typeBar.frame = frame;
    self.typeBar.items = items;
}

- (void)setupButtonsWithFrame:(CGRect)frame
{
    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReset setTitle:@"重置" forState:UIControlStateNormal];
    btnReset.frame = CGRectMake(60, HEIGHT - 100, 60, 20);
    [btnReset.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.view addSubview:btnReset];
    
    UIButton *btnScaleType = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnScaleType setTitle:@"比例：自由" forState:UIControlStateNormal];
    btnScaleType.frame = CGRectMake(140, HEIGHT - 100, 100, 20);
    [btnScaleType.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    [self.view addSubview:btnScaleType];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setImage:[UIImage imageNamed:@"icon_clip_confim@2x.png"] withTitle:@"确定裁剪" forState:UIControlStateNormal];
    btnConfirm.frame = CGRectMake(240, HEIGHT - 100, 120, 30);
    [self.view addSubview:btnConfirm];
}

- (void)setupImageView
{
    self.imageView.hidden = YES;
    self.cropView = [[FWCropView alloc] initWithFrame:self.imageView.frame];
    [self.cropView setImage:self.image];
    //    [self.cropView setupImageView];
    [self.view addSubview:self.cropView];
    //    [self.imageView removeFromSuperview];
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
    [self.videoCamera setRawImage:[UIImage imageNamed:@"effect.png"]];
    [self.videoCamera switchFilter:1];
    [effectView setImage:self.videoCamera.processImage text:@"test"];
    NSLog(@"%@",self.videoCamera.processImage);
    
    [self.scrollView addSubview:effectView];
//    for (int i = 0; i < 8; i++) {
//
//    }
}

- (void)btnCancelOrSaveClicked:(id)sender
{
    if (sender == self.btnClose) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if(sender == self.btnSave){
        if ([self.FunctionType isEqualToString:@"编辑"]) {
            UIImageWriteToSavedPhotosAlbum(self.cropView.croppedImage, nil, nil, nil);
            return;
        }
        UIImageWriteToSavedPhotosAlbum(self.currentImage, nil, nil, nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    selectedIndex =index;
    if ([self.FunctionType isEqualToString:@"增强"]) {
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
}

- (void)effectFunc
{
    
}

@end

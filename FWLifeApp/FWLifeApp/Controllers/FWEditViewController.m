//
//  FWEditViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWEditViewController.h"
#import "FWDataManager.h"
#import "FWCropView.h"
#import "UIButton+TextAndImageHorizontalDisplay.h"

@interface FWEditViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FWCropView *cropView;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIScrollView *scaleScrollView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *containterView;

@end

@implementation FWEditViewController

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
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 105, WIDTH, kBarHeight)];
    self.styleBar.margin = 10;
    self.styleBar.itemBeginX = 0;
    self.styleBar.frame = CGRectMake(90, HEIGHT - 55, 180, 55);
    
    NSDictionary *autoDict = [[FWDataManager getDataSourceFromPlist] objectForKey:@"Edit"];
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
    
    [self setupButtonsForClipView];
}

- (void)setBtnReset
{
    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnReset setTitle:@"重置" forState:UIControlStateNormal];
    
    btnReset.frame = CGRectMake(30, 0, 50, 30);
    [btnReset.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReset.layer.borderWidth = 0.5;
    btnReset.layer.cornerRadius = 15.0;
    btnReset.layer.borderColor = [UIColor whiteColor].CGColor;
    btnReset.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:26/ 255.0 blue:26/ 255.0 alpha:0.8];
    [btnReset addTarget:self action:@selector(btnResetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containterView addSubview:btnReset];
    
}

- (void)setupButtonsForClipView
{
    if (self.containterView) {
        [self clearContainterView];
    }else{
        self.containterView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 95, WIDTH, 30)];
        self.containterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.containterView];
    }

    [self setBtnReset];

    
    UIButton *btnScaleType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnScaleType setTitle:@"比例：自由" forState:UIControlStateNormal];
    [btnScaleType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnScaleType.frame = CGRectMake(100, 0, 80, 30);
    [btnScaleType.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    btnScaleType.layer.borderWidth = 0.5;
    btnScaleType.layer.cornerRadius = 15;
    btnScaleType.layer.borderColor = [UIColor whiteColor].CGColor;
    [btnScaleType addTarget:self action:@selector(btnScaleTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.containterView addSubview:btnScaleType];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnConfirm.backgroundColor = [UIColor blueColor];
    [btnConfirm setImage:[UIImage imageNamed:@"icon_clip_confim@2x.png"] withTitle:@"确定裁剪" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.layer.cornerRadius = 15.0;
    btnConfirm.frame = CGRectMake(200, 0, 90, 30);
    [btnConfirm addTarget:self action:@selector(btnConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containterView addSubview:btnConfirm];
    
    self.imageView.hidden = YES;
    self.cropView = [[FWCropView alloc] initWithFrame:self.imageView.frame];
    [self.cropView setImage:self.image];
    [self.view addSubview:self.cropView];
    [self.imageView removeFromSuperview];
    
}

- (void)setupButtonsForRataionView
{
    [self clearContainterView];
    [self setBtnReset];
    
    NSArray *buttonNormalImages = [NSArray arrayWithObjects:@"btn_img_rotate_left_a", @"btn_img_rotate_right_a", @"btn_flip_updown_a", @"btn_flip_leftright_a", nil];
    NSArray *buttonHighLightImages = [NSArray arrayWithObjects:@"btn_img_rotate_left_b", @"btn_img_rotate_right_b", @"btn_flip_updown_b", @"btn_flip_leftright_b", nil];
    
    CGFloat beginX = 120;
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat margin = 20;
    for (int i = 0; i < [buttonNormalImages count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setImage:[UIImage imageNamed:[buttonNormalImages objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[buttonHighLightImages objectAtIndex:i]] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(beginX + i * (width + margin), 0, width, height);
        
        [self.containterView addSubview:btn];
    }
}

- (void)btnClicked:(id)sender
{
    
}

- (void)clearContainterView
{
    if ([self.containterView.subviews count]) {
        for (UIView *item in self.containterView.subviews) {
            [item removeFromSuperview];
        }
    }
}

- (void)setupButtonsForSharpenView
{
    [self clearContainterView];

    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
    self.slider.center = CGPointMake(WIDTH / 2, 30 / 2);
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_slider_thumb"] forState:UIControlStateNormal];
    self.slider.value = 0;
    self.slider.minimumValue = -100;
    self.slider.maximumValue = 100;
    [self.containterView addSubview:self.slider];
}

- (void)btnResetClicked:(id)sender
{
    [self hideScaleScrollView];
}

- (void)btnScaleTypeClicked:(id)sender
{
    if (self.scaleScrollView)
    {
        [self hideScaleScrollView];
        
        return;
    }
    [self setupCropScaleView];
}

- (void)btnConfirmClicked:(id)sender
{
    [self hideScaleScrollView];
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

- (void)hideScaleScrollView
{
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideScaleScrollView];
}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    [self hideScaleScrollView];
    switch (index) {
        case 0:
            [self setupButtonsForClipView];
            break;
            
        case 1:
            [self setupButtonsForRataionView];
            break;
            
        case 2:
            [self setupButtonsForSharpenView];
            break;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

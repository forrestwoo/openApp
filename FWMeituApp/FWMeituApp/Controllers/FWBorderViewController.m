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
    self.imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 70);
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
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(80, HEIGHT - 40, 200, 20)];
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
    
    [self setupSimpleBorderView];
}

- (void)setupSimpleBorderView
{
    FWMoreEffectView *seView = [[FWMoreEffectView alloc] initWithFrame:CGRectMake(15, HEIGHT - 50 - kHeight, kWidth, kHeight)];
    [self.view addSubview:seView];
    
    self.borderStyleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(70, HEIGHT - 50 - kHeight, WIDTH - 70, kHeight)];
    self.borderStyleBar.effectBarDelegate = self;
    self.borderStyleBar.itemBeginX = 15.0;
    self.borderStyleBar.itemWidth = 50.0;
    self.borderStyleBar.margin = 10.0;
    
    NSArray *imageArr = nil;
    if ([self.styleBar.selectedItem.title isEqualToString:@"海报边框"])
        imageArr = [NSArray arrayWithObjects:@"pb1", @"pb2", @"pb3", @"pb4", @"pb5", @"pb6", @"pb7", @"pb8", @"pb9", @"pb10",nil];
    else if([self.styleBar.selectedItem.title isEqualToString:@"简单边框"])
        imageArr = [NSArray arrayWithObjects:@"border_baikuang_a", @"border_baolilai_a", @"border_heikuang_a", @"border_luxiangji_a", @"border_onenight_a", @"border_simple_15", @"border_simple_16", @"border_simple_17", @"border_simple_18", @"border_simple_19",nil];
    else if([self.styleBar.selectedItem.title isEqualToString:@"炫彩边框"])
        imageArr = [NSArray arrayWithObjects:@"xborder_aixin_a", @"xborder_guangyun_a", @"xborder_qisehua_a", @"xborder_wujiaoxing_a", @"xborder_xueye_a", @"xborder_yinhe_a",nil];
    
    FWEffectBarItem *item = nil;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < 10; i++)
    {
        item = [[FWEffectBarItem alloc] initWithFrame:CGRectMake((kWidth + kSpace) * i + 10, 0, kWidth, kHeight)];
        [item setFinishedSelectedImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
        [items addObject:item];
    }
    
    self.borderStyleBar.items = items;
    [self.view addSubview:self.borderStyleBar];
}

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    if (bar == self.styleBar)
    {
        switch (index) {
            case 0:
                self.imageView.image = self.image;
                break;
                
            case 1:
                self.imageView.image = self.currentImage;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

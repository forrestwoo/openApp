//
//  FWAutoBeautyViewController.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWAutoBeautyViewController.h"

#import "FWDataManager.h"
#import "FWApplyFilter.h"

@interface FWAutoBeautyViewController ()

@property (nonatomic, strong) FWEffectBar *styleBar;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation FWAutoBeautyViewController

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
    
    self.styleBar = [[FWEffectBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 105, WIDTH, kBarHeight)];
    
    NSDictionary *autoDict = [[FWDataManager getDataSourceFromPlist] objectForKey:@"AutoBeauty"];
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

#pragma mark - FWEffectBarDelegate
- (void)effectBar:(FWEffectBar *)bar didSelectItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.currentImage = self.image;
            break;
            
        case 1:
            self.currentImage = [FWApplyFilter autoBeautyFilter:self.image];
            break;
            
        case 2:
            self.currentImage = [FWApplyFilter applyHudsonFilter:self.image];
            break;
            
        case 3:
            self.currentImage = [FWApplyFilter applyStaticFilter:self.image];
            break;
            
        case 4:
            self.currentImage = [FWApplyFilter applyViewFilter:self.image];
            break;
            
        case 5:
            self.currentImage = [FWApplyFilter applyLomo1Filter:self.image];
            break;
            
        case 6:
            self.currentImage = [FWApplyFilter applyNashvilleFilter:self.image];
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

@end

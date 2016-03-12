//
//  ViewController.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/12.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "ViewController.h"
#import "FWButton.h"
#import "FWAncientPoetryCollectionViewController.h"
#import "FWBookshelfCollectionViewLayout.h"

@interface ViewController ()

//@property (nonatomic, strong) UIView *backgroundView;
//@property (nonatomic, strong) UIView *foregroundView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的应用";
    FWButton *btnTang = [FWButton buttonWithType:UIButtonTypeCustom];
    [btnTang setTitle:@"古籍" forState:UIControlStateNormal];
    btnTang.frame = CGRectMake(20, 80, 80, 40);
    btnTang.backgroundColor = [UIColor blueColor];
    [btnTang addTarget:self action:@selector(btnTangClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTang];
    
    FWButton *btnImage = [FWButton buttonWithType:UIButtonTypeCustom];
    [btnImage setTitle:@"图片" forState:UIControlStateNormal];
    btnImage.frame = CGRectMake(120, 80, 80, 40);
    btnImage.backgroundColor = [UIColor blueColor];
    [btnImage addTarget:self action:@selector(btnImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnImage];
}

- (void)btnTangClicked:(id)sender
{
    FWBookshelfCollectionViewLayout *layout = [[FWBookshelfCollectionViewLayout alloc] init];
    FWAncientPoetryCollectionViewController *vc = [[FWAncientPoetryCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnImageClicked:(id)sender
{
    FWBookshelfCollectionViewLayout *layout = [[FWBookshelfCollectionViewLayout alloc] init];
    FWAncientPoetryCollectionViewController *vc = [[FWAncientPoetryCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupBackgroundView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end

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
    
    FWButton *btnTang = [FWButton buttonWithType:UIButtonTypeCustom];
    [btnTang setTitle:@"唐诗宋词" forState:UIControlStateNormal];
    btnTang.frame = CGRectMake(50, 50, 80, 80);
    btnTang.backgroundColor = [UIColor blueColor];
    [btnTang addTarget:self action:@selector(btnTangClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTang];
}

- (void)btnTangClicked:(id)sender
{
    FWBookshelfCollectionViewLayout *layout = [[FWBookshelfCollectionViewLayout alloc] init];
    FWAncientPoetryCollectionViewController *vc = [[FWAncientPoetryCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)setupBackgroundView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end

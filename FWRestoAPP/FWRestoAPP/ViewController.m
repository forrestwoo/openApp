//
//  ViewController.m
//  FWRestoAPP
//
//  Created by forrest on 2017/4/24.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 80)];
    la.text = @"Fuck label";
    la.backgroundColor = [UIColor redColor];
    [self.view addSubview:la];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

@end

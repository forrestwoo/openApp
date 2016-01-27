//
//  ViewController.m
//  FWCOLORAPP
//
//  Created by hzkmn on 16/1/25.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "ViewController.h"
#import "MPColorTools/MPColorTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIColor *myColor = MP_RGB(100, 120, 200);
    self.view.backgroundColor = myColor;
    UIColor *offsetColor = [myColor colorByAddingAngle:125];
    for (int i = 0; i < 10; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (20 + 5) * i, [[UIScreen mainScreen] bounds].size.width, 20)];
        view.backgroundColor = [myColor complementaryColor];
        [self.view addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

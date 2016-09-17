//
//  JSViewController.m
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSViewController.h"
#import "JSCameraController.h"
#import "JSCameraControllerDelegate.h"
@interface JSViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
    BOOL hasLoadedCamera;
}
- (IBAction)takephoto:(id)sender;

@end

@implementation JSViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)takephoto:(id)sender {
   	JSCameraController *camerca=[[JSCameraController alloc]init];
   
    [self presentViewController:camerca animated:YES completion:^{
        // completion code
    }];
}

@end

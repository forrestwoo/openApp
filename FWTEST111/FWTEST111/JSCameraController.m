//
//  JSCameraController.m
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "JSCameraOperationManager.h"
#define FlashLightModeCount 3 //闪光灯模式
@interface JSCameraController (){
    
    UIImagePickerController *_imgPicker;//选取器
    BOOL pickerDidShow;
    JSCameraOperationManager *_CameraManager;
    BOOL _showGrid;//是否显示网格？
    BOOL _IsFontCamera;//是否是副摄像头？
    NSInteger _lightModeIndex;
    
}
@end

@implementation JSCameraController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self InitSetUpView];
}
-(void)InitSetUpView
{
    self.navigationController.navigationBarHidden = YES;
    //初始化变量
    _showGrid=NO;
    _IsFontCamera=NO;
    _lightModeIndex=1;
    //添加管理器
    _CameraManager=[[JSCameraOperationManager alloc]init];
    [_CameraManager initializeCameraWithPreview:self.imagePreview];
    
}
#pragma mark-- 按钮操作
- (IBAction)snapImage:(id)sender {
    [_CameraManager CaptureImage];
    
}

//#pragma mark - Device Availability Controls
//- (void)disableCameraDeviceControls{
//    self.cameraToggleButton.enabled = NO;
//    self.flashToggleButton.enabled = NO;
//    self.photoCaptureButton.enabled = NO;
//}

#pragma mark - Button clicks
- (IBAction)gridToogle:(UIButton *)sender{
    if (_showGrid) {
        [self.ImgViewGrid setHidden:NO];
        
    }else {
        [self.ImgViewGrid setHidden:YES];
    }
    
    _showGrid=_showGrid==YES?NO:YES;
}

-(IBAction)switchToLibrary:(id)sender {
 //跳转到相册浏览
}

-(IBAction) cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchCamera:(UIButton *)sender {
    if (_IsFontCamera) {
        _CameraManager.CameraChose=KCameraBack;
    }else{
        _CameraManager.CameraChose=KCameraFont;
    }
    _IsFontCamera=_IsFontCamera==YES?NO:YES;
    [_CameraManager StopCaptureImage];

    [_CameraManager SetCaptureSessionWithCamera:_CameraManager.CameraChose];
    //同步设置闪关灯按钮
   if (_CameraManager.FlashLightState==KNoFlashLight) {
       //闪光灯按钮半透明
       [self.flashToggleButton setAlpha:0.6f];
       [self.flashToggleButton setEnabled:NO];
   }else
   {
       //闪光灯按钮半透明
       [self.flashToggleButton setAlpha:1.0f];
       [self.flashToggleButton setEnabled:YES];
   }
}

- (IBAction)toogleFlash:(UIButton *)sender{
    NSString *imagename=@"";
        switch (_lightModeIndex) {
            case 0:
                imagename=@"flash-off.png";
               [_CameraManager setFlashLightState:KFlashLightOff];
                break;
            case 1:
                imagename=@"flash.png";
                [_CameraManager setFlashLightState:KFlashLightOpen];
                break;
            case 2:
                imagename=@"flash-auto.png";
                [_CameraManager setFlashLightState:KFlashLightAuto];
                break;
            default:
                break;
        }
    [self.flashToggleButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [self.flashToggleButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateHighlighted];
    if (_lightModeIndex>=FlashLightModeCount-1) {
        _lightModeIndex=0;
    }else{
        _lightModeIndex++;
    }
    
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

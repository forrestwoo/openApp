//
//  FWCameraFilterViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/17.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWCameraFilterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FWAmaroFilter.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetCreationRequest.h>

@interface FWCameraFilterViewController ()
{
    UIButton *_btnFlash;
    UIButton *_btnSetting;
    UIButton *_btnRotateCamera;
    UIButton *_btnCloseCamera;
    AVCaptureFlashMode _flashMode;
    BOOL _isBack;
    
}
@property(strong, nonatomic) GPUImageStillCamera *mCamera;
@property(strong, nonatomic) GPUImageFilterGroup *mFilter;
@property(strong, nonatomic) GPUImageView *mGPUImgView;
@end

@implementation FWCameraFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
//320 426
    _mCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    _isBack = YES;
//    _mCamera.horizontallyMirrorRearFacingCamera = NO;
//    _mCamera.horizontallyMirrorFrontFacingCamera = YES;
    _mCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _mFilter = [[FWAmaroFilter alloc] init];
    _mGPUImgView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 426)];

    [_mCamera addTarget:_mFilter];
    [_mFilter addTarget:_mGPUImgView];
//    [_mFilter forceProcessingAtSizeRespectingAspectRatio:_mGPUImgView.frame.size];
//        [_mFilter forceProcessingAtSize:_mGPUImgView.frame.size];
    [_mCamera startCameraCapture];
    [self.view addSubview:_mGPUImgView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-50)*0.5, self.view.bounds.size.height-60, 50, 50)];

    [btn setImage:[UIImage imageNamed:@"take-snap"] forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFlash = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 36, 36)];
    
    [_btnFlash setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    _flashMode = AVCaptureFlashModeOn;
    [self.view addSubview:_btnFlash];
    [_btnFlash addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSetting = [[UIButton alloc]initWithFrame:CGRectMake(200, 10, 36, 36)];
    [_btnSetting setImage:[UIImage imageNamed:@"camera-setting"] forState:UIControlStateNormal];
    [self.view addSubview:_btnSetting];
    [_btnSetting addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRotateCamera = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 80, 10, 36, 36)];
    
    [_btnRotateCamera setImage:[UIImage imageNamed:@"front-camera-normal"] forState:UIControlStateNormal];
    
    [self.view addSubview:_btnRotateCamera];
    [_btnRotateCamera addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCloseCamera = [[UIButton alloc]initWithFrame:CGRectMake(20, HEIGHT - 60, 30, 30)];
    
    [_btnCloseCamera setImage:[UIImage imageNamed:@"btn_cancel_a@2x"] forState:UIControlStateNormal];
    
    [self.view addSubview:_btnCloseCamera];
    [_btnCloseCamera addTarget:self action:@selector(closeCameraClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)closeCameraClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)switchFlash:(id)sender
{
    switch (_flashMode) {
        case 0:
            _flashMode = AVCaptureFlashModeOn;
            [_btnFlash setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];

            break;
            
        case 1:
            _flashMode = AVCaptureFlashModeAuto;
            [_btnFlash setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
            
            break;
            
        default:
            _flashMode = AVCaptureFlashModeOff;
            [_btnFlash setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
            
            break;
    }
    
    [_mCamera.inputCamera lockForConfiguration:nil];
    [_mCamera.inputCamera setFlashMode:_flashMode];
    [_mCamera.inputCamera unlockForConfiguration];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)switchCamera:(id)sender
{
    if (_isBack) {
        _btnFlash.hidden = YES;
        _isBack = NO;
    }
    else{
        _btnFlash.hidden = NO;
        _isBack = YES;
    }
    [_mCamera rotateCamera];
}

-(void)takePhoto{
    [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
    UIButton *_btnRotateCamera;
    UIButton *_btnCloseCamera;
    AVCaptureFlashMode _flashMode;
    
}
@property(strong, nonatomic) GPUImageStillCamera *mCamera;
@property(strong, nonatomic) GPUImageFilterGroup *mFilter;
@property(strong, nonatomic) GPUImageView *mGPUImgView;
@end

@implementation FWCameraFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];

    _mCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    _mCamera.horizontallyMirrorRearFacingCamera = NO;
    _mCamera.horizontallyMirrorFrontFacingCamera = YES;
    _mCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _mFilter = [[FWAmaroFilter alloc] init];
    _mGPUImgView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    NSLog(@"%@",NSStringFromCGRect(_mGPUImgView.frame));
    _mGPUImgView.backgroundColor = [UIColor redColor];
    [_mCamera addTarget:_mFilter];
    [_mFilter addTarget:_mGPUImgView];
    [_mCamera startCameraCapture];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-50)*0.5, self.view.bounds.size.height-60, 50, 50)];

    [btn setImage:[UIImage imageNamed:@"take-snap"] forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFlash = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
    
    [_btnFlash setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    _flashMode = AVCaptureFlashModeOn;
    [self.view addSubview:_btnFlash];
    [_btnFlash addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRotateCamera = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 80, 10, 47, 23)];
    
    [_btnRotateCamera setImage:[UIImage imageNamed:@"front-camera"] forState:UIControlStateNormal];
    
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
            [_mCamera.inputCamera lockForConfiguration:nil];

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
    if (_mCamera.isBackFacingCameraPresent) {
        _btnFlash.hidden = YES;
    }
    else{
        _btnFlash.hidden = NO;
    }
    [_mCamera rotateCamera];
}

-(void)takePhoto{
//    [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
//        //将相片保存到手机相册（iOS8及以上，该方法过期但是可以用，不想用请搜索PhotoKit）
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
////            
////        } completionHandler:^(BOOL success, NSError * _Nullable error) {
////            
////        }];
//        
//        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:_mCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2)
//         {
//             if (error2) {
//                 NSLog(@"ERROR: the image failed to be written");
//             }
//             else {
//                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
//             }
//             
//         }];
//    }];
    
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

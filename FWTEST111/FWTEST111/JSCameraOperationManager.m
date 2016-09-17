//
//  JSCameraOperationManager.m
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSCameraOperationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface JSCameraOperationManager()
{
    AVCaptureDevice *_frontCamera;//前置摄像头
    AVCaptureDevice *_backCamera;//后置摄像头
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;//采集显示
    AVCaptureStillImageOutput *_stillImageOutput;//静态图片输出
    BOOL _deviceAuthorized;//相机是否授权
    AVCaptureDeviceInput* _oldinput;//记录切换摄像头前输入端
    AVCaptureStillImageOutput* _oldoutput;//记录切换摄像头前输出端
    
}
@end
@implementation JSCameraOperationManager
#pragma mark--初始化等操作 vc
-(id)init
{
    self=[super init];
    if (self) {
        //检查授权
        [self checkDeviceAuthorizationStatus];
    }
    return self;
}

-(void)setCameraChose:(enum KCameraChose)CameraChose
{
    if (CameraChose!=_CameraChose) {
        _CameraChose=CameraChose;
        //检查闪光灯
        [self CheckflashLightWithCamera:[self ChoseCameraWith:CameraChose]];
    }
}
-(AVCaptureDevice *)ChoseCameraWith:(enum KCameraChose)CameraChose
{
    switch (CameraChose) {
        case KCameraBack:
            return _backCamera;
            break;
        case KCameraFont:
            return _frontCamera;
            break;
        default:
            break;
    }
}
 //初始化camera
-(void)initializeCameraWithPreview:(UIImageView *)preview
{
    
    if (_deviceAuthorized) {
        
    if (!_session){
        _session = [[AVCaptureSession alloc] init];
    }
    if (!_captureVideoPreviewLayer){
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    }
    [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	_captureVideoPreviewLayer.frame = preview.bounds;
	[preview.layer addSublayer:_captureVideoPreviewLayer];
    //获取硬件采集设备
    NSArray *devices = [AVCaptureDevice devices];
    
    if (devices.count==0) {
        [self ShowAlertToUserWithTitle:@"抱歉" Message:@"相机设备不可用"];
        self.CameraSate=KCameraSateDisable;
        return;
    }
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                _backCamera = device;
            }
            else {
                
                _frontCamera = device;
            }
        }
    }
    //默认是主摄像头
    self.CameraChose=KCameraBack;
    [self CheckflashLightWithCamera:_backCamera];
    [self SetCaptureSessionWithCamera:KCameraBack];
    }
}
//检查闪光灯
-(void)CheckflashLightWithCamera:(AVCaptureDevice *)camera
{
    
        
   if ([camera hasFlash]){
            [camera lockForConfiguration:nil];//加锁
        self.FlashLightState=KFlashLightOff;
       [self setFlashLightState:KFlashLightOff];
            [camera unlockForConfiguration];
        }else
    {
        self.FlashLightState=KNoFlashLight;
    }

}
//检查用户相机授权
- (void)checkDeviceAuthorizationStatus
{
   if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]==AVAuthorizationStatusDenied) {
            
            [self ShowAlertToUserWithTitle:@"无法启动相机" Message:@"\n请为应用开放相机权限:设置-隐私-相机-MiniCamera(打开)"];
            _deviceAuthorized=NO;
       
    }else
    {
        _deviceAuthorized=YES;
        
    }
}

//设置闪光灯
-(void)setFlashLightState:(enum KFlashLightState)FlashLightState
{
    AVCaptureDevice *current_camera=[self ChoseCameraWith:self.CameraChose];
    _FlashLightState=FlashLightState;
    //设置闪光灯
    if (FlashLightState!=KNoFlashLight) {
        switch (FlashLightState) {
            case KFlashLightOpen:
                [current_camera lockForConfiguration:nil];
                [current_camera setFlashMode:AVCaptureFlashModeOn];
                [current_camera unlockForConfiguration];
                break;
            case KFlashLightOff:
                [current_camera lockForConfiguration:nil];
                [current_camera setFlashMode:AVCaptureFlashModeOff];
                [current_camera unlockForConfiguration];
                break;
            case KFlashLightAuto:
                [current_camera lockForConfiguration:nil];
                [current_camera setFlashMode:AVCaptureFlashModeAuto];
                [current_camera unlockForConfiguration];
                break;
            default:
                break;
        }
    }
}
//设置AVCaptureSession以及输入输出端
-(void)SetCaptureSessionWithCamera:(enum KCameraChose)chose
{
    AVCaptureDevice *current_camera=[self ChoseCameraWith:chose];
    //设置捕捉照片
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    //添加输入设备到当前session
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:current_camera error:&error];
        if (!input) {
        [self ShowAlertToUserWithTitle:@"提示" Message:@"无法连接到相机"];
        }
    //首次添加输入端口
    if (_session.inputs.count>0)
    {//清除输入端口
     [_session removeInput:_oldinput];
    }
    [_session addInput:input];
    _oldinput=input;
    //设置输出
    if (!_stillImageOutput)
        {
            _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        }
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    if (_session.outputs.count>0)
    {//清除输入端口
        [_session removeOutput:_oldoutput];
    }
    [_session addOutput:_stillImageOutput];
    _oldoutput=_stillImageOutput;
	[_session startRunning];
}


#pragma mark--捕捉并处理处理图片
//捕捉图片
- (void)CaptureImage {
    //查找video采集端口
    AVCaptureConnection *videoConnection = nil;
    //遍历连接
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        //遍历输入端口
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        //找到video端口后停止遍历
        if (videoConnection) {
            break;
        }
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            
          //  [self processImage:[UIImage imageWithData:imageData]];
            [self SavePictureToLibraryWithImage:[UIImage imageWithData:imageData]];
            [self.CameraDelegate didFinishPick_Image:[UIImage imageWithData:imageData]];
        }
    }];
}


- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//停止
- (void)StopCaptureImage{
    [_session stopRunning];
    
}
#pragma mark--保存到相册
-(void)SavePictureToLibraryWithImage:(UIImage *)image
{
    ALAssetsLibrary*library=[[ALAssetsLibrary alloc]init];
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
        
    }];
}
#pragma mark--提示用户
-(void)ShowAlertToUserWithTitle:(NSString *)title Message:(NSString*)mesg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert setTitle:title];
    [alert setMessage:mesg];
    [alert show];
}
@end

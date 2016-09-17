//
//  JSCameraController.h
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCameraControllerDelegate.h"

@interface JSCameraController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *photoCaptureButton;//拍照按钮
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;//取消
@property (nonatomic, weak) IBOutlet UIButton *cameraToggleButton;//摄像头切换
@property (nonatomic, weak) IBOutlet UIButton *PicturePreviewButton;//照片预览
@property (nonatomic, weak) IBOutlet UIButton *flashToggleButton;//闪光灯控制
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewGrid;//拍照网格显示
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;//拍照取景显示
@property (nonatomic, weak) IBOutlet UIView *photoBar;//拍照dock
@property (nonatomic, weak) IBOutlet UIView *topBar;//顶部视图

@end

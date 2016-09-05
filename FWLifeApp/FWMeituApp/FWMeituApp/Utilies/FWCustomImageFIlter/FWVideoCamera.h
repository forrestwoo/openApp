//
//  FWVideoCamera.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-10.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageVideoCamera.h"

@class FWVideoCamera;
@protocol FWVideoCameraDelegate <NSObject>

- (void)FWVideoCameraWillStartCaptureStillImage:(FWVideoCamera *)videoCamera;
- (void)FWVideoCameraDidFinishCaptureStillImage:(FWVideoCamera *)videoCamera;
- (void)FWVideoCameraDidSaveStillImage:(FWVideoCamera *)videoCamera;
- (BOOL)canFWVideoCameraStartRecordingMovie:(FWVideoCamera *)videoCamera;
- (void)FWVideoCameraWillStartProcessingMovie:(FWVideoCamera *)videoCamera;
- (void)FWVideoCameraDidFinishProcessingMovie:(FWVideoCamera *)videoCamera;

@end

@interface FWVideoCamera : GPUImageVideoCamera

//@property (strong, readonly) GPUImageView *gpuImageView;
//@property (strong, readonly) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, strong) UIImage *processImage;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality;
- (void)switchFilter:(FWFilterType)type;
- (void)cancelAlbumPhotoAndGoBackToNormal;
- (void)takePhoto;
- (void)startRecordingMovie;
- (void)stopRecordingMovie;
- (void)saveCurrentStillImage;

@end

//
//  FWVideoCamera.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-10.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//
#define FM_SCREEN_HEIGHT ((float)[[UIScreen mainScreen] bounds].size.height)
#define FM_SCREEN_WIDTH ((float)[[UIScreen mainScreen] bounds].size.width)

#import "FWVideoCamera.h"
#import "FWImageFilter.h"
#import "FWNormalFilter.h"
#import "UIImage+FW.h"

@interface FWVideoCamera ()
@property (nonatomic, strong) FWImageFilter *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) FWImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

//@property (strong, readwrite) GPUImageView *gpuImageView;
//@property (strong, readwrite) GPUImageView *gpuImageView_HD;

@property (nonatomic, strong) FWRotationFilter *rotationFilter;
@property (nonatomic, unsafe_unretained) FWFilterType currentFilterType;

@property (nonatomic, strong) dispatch_queue_t prepareFilterQueue;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, unsafe_unretained, readwrite) BOOL isRecordingMovie;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;

- (void)switchToNewFilter;
- (void)forceSwitchToNewFilter:(FWFilterType)type;

- (BOOL)canStartRecordingMovie;
- (void)removeFile:(NSURL *)fileURL;
- (NSURL *)fileURLForTempMovie;
- (void)initializeSoundRecorder;
- (NSURL *)fileURLForTempSound;
- (void)startRecordingSound;
- (void)prepareToRecordSound;
- (void)stopRecordingSound;
- (void)combineSoundAndMovie;
- (NSURL *)fileURLForFinalMixedAsset;

- (void)focusAndLockAtPoint:(CGPoint)point;
- (void)focusAndAutoContinuousFocusAtPoint:(CGPoint)point;
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end
@implementation FWVideoCamera

#pragma mark - Save current image
- (void)saveCurrentStillImage {
    if (self.rawImage == nil) {
        return;
    }
    // If without the rorating 0 degree action, the image will be left hand 90 degrees rorated.
    UIImageWriteToSavedPhotosAlbum([[self.filter imageFromCurrentlyProcessedOutput] imageRotatedByDegrees:0], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark - Focus
// Switch to continuous auto focus mode at the specified point
- (void) focusAndLockAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = nil;
    for (AVCaptureInput *anInput in self.captureSession.inputs) {
        if ([anInput isKindOfClass:[AVCaptureDeviceInput class]]) {
            device = [((AVCaptureDeviceInput *)anInput) device];
            break;
        }
    }
    
    if (device == nil) {
        return;
    }
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeLocked];
            [device unlockForConfiguration];
        } else {
            // do nothing here...
        }
    }
}
- (void) focusAndAutoContinuousFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = nil;
    for (AVCaptureInput *anInput in self.captureSession.inputs) {
        if ([anInput isKindOfClass:[AVCaptureDeviceInput class]]) {
            device = [((AVCaptureDeviceInput *)anInput) device];
            break;
        }
    }
    
    if (device == nil) {
        return;
    }
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        } else {
            // do nothing here...
        }
    }
}


#pragma mark - Mixed sound and movie asset url
- (NSURL *)fileURLForFinalMixedAsset {
    static NSURL *tempMixedAssetURL = nil;
    
    @synchronized(self) {
        if (tempMixedAssetURL == nil) {
            tempMixedAssetURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"tempMix.m4v"]];
        }
    }
    
    return tempMixedAssetURL;
}


#pragma mark - Combine sound and movie
- (void)combineSoundAndMovie {
    self.mutableComposition = [AVMutableComposition composition];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil];
    
    AVURLAsset *movieURLAsset = [[AVURLAsset alloc] initWithURL:[self fileURLForTempMovie] options:options];
    AVURLAsset *soundURLAsset = [[AVURLAsset alloc] initWithURL:[self fileURLForTempSound] options:options];
    
    NSError *soundError = nil;
    AVMutableCompositionTrack *soundTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    BOOL soundResult = [soundTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, soundURLAsset.duration) ofTrack:[[soundURLAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&soundError];
    
    if (soundError != nil) {
        NSLog(@" - sound track error...");
    }
    
    if (soundResult == NO) {
        NSLog(@" - sound result = NO...");
    }
    
    NSError *movieError = nil;
    AVMutableCompositionTrack *movieTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    BOOL movieResult = [movieTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieURLAsset.duration) ofTrack:[[movieURLAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&movieError];
    
    if (movieError != nil) {
        NSLog(@" - movie track error...");
    }
    
    if (movieResult == NO) {
        NSLog(@" - movie result = NO...");
    }
    
    self.assetExportSession = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition presetName:AVAssetExportPresetPassthrough];
    
    [self removeFile:[self fileURLForFinalMixedAsset]];
    
    self.assetExportSession.outputURL = [self fileURLForFinalMixedAsset];
    self.assetExportSession.outputFileType = AVFileTypeAppleM4V;
    
    [self.assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (self.assetExportSession.status) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@" - Export failed...");
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@" - Export ok...");
                NSString *path = [NSString stringWithString:[self.assetExportSession.outputURL path]];
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (path)) {
                    UISaveVideoAtPathToSavedPhotosAlbum (path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Was trying to save the movie but failed." delegate:nil cancelButtonTitle:@"Oh ok" otherButtonTitles:nil];
                    [alertView show];
                    if ([self.delegate respondsToSelector:@selector(FWVideoCameraDidFinishProcessingMovie:)]) {
                        [self.delegate FWVideoCameraDidFinishProcessingMovie:self];
                    }
                    [self startCameraCapture];
                    [self focusAndAutoContinuousFocusAtPoint:CGPointMake(.5f, .5f)];
                }
                
                break;
            }
            default: {
                break;
            }
        };
        
    }];
    
}

#pragma mark - Movie & image did saved callback
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"The video was saved in Camera Roll." delegate:nil cancelButtonTitle:@"Sweet" otherButtonTitles:nil];
    [alertView show];
    if ([self.delegate respondsToSelector:@selector(FWVideoCameraDidFinishProcessingMovie:)]) {
        [self.delegate FWVideoCameraDidFinishProcessingMovie:self];
    }
    [self startCameraCapture];
    [self focusAndAutoContinuousFocusAtPoint:CGPointMake(.5f, .5f)];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ([self.delegate respondsToSelector:@selector(FWVideoCameraDidSaveStillImage:)]) {
        [self.delegate FWVideoCameraDidSaveStillImage:self];
    }
}


#pragma mark - Sound Writing methods
- (void)initializeSoundRecorder {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //audioSession.delegate = self;
    [audioSession setActive: YES error: nil];
    
}
- (NSURL *)fileURLForTempSound {
    static NSURL *tempSoundURL = nil;
    
    @synchronized(self) {
        if (tempSoundURL == nil) {
            tempSoundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"tempSound.caf"]];
        }
    }
    
    return tempSoundURL;
}
- (void)startRecordingSound {
    
    [self.soundRecorder record];
    
}
- (void)prepareToRecordSound {
    [self removeFile:[self fileURLForTempSound]];
    
    [self initializeSoundRecorder];
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryRecord
     error: nil];
    
    NSDictionary *recordSettings =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
     [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
     [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
     [NSNumber numberWithInt: AVAudioQualityMax],
     AVEncoderAudioQualityKey,
     nil];
    
    AVAudioRecorder *newRecorder =
    [[AVAudioRecorder alloc] initWithURL: [self fileURLForTempSound]
                                settings: recordSettings
                                   error: nil];
    
    self.soundRecorder = newRecorder;
    
    //soundRecorder.delegate = self;
    [self.soundRecorder prepareToRecord];
}

- (void)stopRecordingSound {
    [self.soundRecorder stop];
    self.soundRecorder = nil;
    
    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    
}

#pragma mark - Movie Writing methods
- (BOOL)canStartRecordingMovie {
    
    if ([self.delegate respondsToSelector:@selector(canFWVideoCameraStartRecordingMovie:)]) {
        return [self.delegate canFWVideoCameraStartRecordingMovie:self];
    } else {
        return NO;
    }
}
- (void)startRecordingMovie {
    if ([self canStartRecordingMovie] == NO) {
        return;
    }
    if (self.isRecordingMovie == YES) {
        return;
    }
    self.isRecordingMovie = YES;
    [self focusAndLockAtPoint:CGPointMake(.5f, .5f)];
    [self removeFile:[self fileURLForTempMovie]];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self fileURLForTempMovie] size:CGSizeMake(480.0f, 480.0f)];
    [self.filter addTarget:self.movieWriter];
    [self prepareToRecordSound];
    [self.movieWriter startRecording];
    [self startRecordingSound];
}
- (void)stopRecordingMovie {
    if ([self.delegate respondsToSelector:@selector(FWVideoCameraWillStartProcessingMovie:)]) {
        [self.delegate FWVideoCameraWillStartProcessingMovie:self];
    }
    [self.filter removeTarget:self.movieWriter];
    [self.movieWriter finishRecording];
    [self stopRecordingSound];
    [self stopCameraCapture];
    [self combineSoundAndMovie];
    self.isRecordingMovie = NO;
}
- (void)removeFile:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileURL path];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@" - Remove file failed...");
        }
    }
}
- (NSURL *)fileURLForTempMovie {
    static NSURL *tempMoviewURL = nil;
    
    @synchronized(self) {
        if (tempMoviewURL == nil) {
            tempMoviewURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"temp.m4v"]];
        }
    }
    
    return tempMoviewURL;
}


#pragma mark - Proper Size For Resizing Large Image
- (CGSize)properSizeForResizingLargeImage:(UIImage *)originaUIImage {
    float originalWidth = originaUIImage.size.width;
    float originalHeight = originaUIImage.size.height;
    float smallerSide = 0.0f;
    float scalingFactor = 0.0f;
    
    if (originalWidth < originalHeight) {
        smallerSide = originalWidth;
        scalingFactor = 640.0f / smallerSide;
        return CGSizeMake(640.0f, originalHeight*scalingFactor);
    } else {
        smallerSide = originalHeight;
        scalingFactor = 640.0f / smallerSide;
        return CGSizeMake(originalWidth*scalingFactor, 640.0f);
    }
}

#pragma mark - Take photo
- (void)takePhoto {
    AVCaptureConnection *videoConnection;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(FWVideoCameraWillStartCaptureStillImage:)]) {
        [self.delegate FWVideoCameraWillStartCaptureStillImage:self];
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        
        
        @autoreleasepool {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            image = [image resizedImage:[self properSizeForResizingLargeImage:image] interpolationQuality:kCGInterpolationHigh];
            image = [image imageRotatedByDegrees:90.0f];
            image = [image cropImageWithBounds:CGRectMake(0, 0, 640, 640)];
            
            self.rawImage = image;
            [self switchFilter:self.currentFilterType];
            
            /*
             ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
             [library writeImageToSavedPhotosAlbum:[image CGImage]
             orientation:(ALAssetOrientation)[image imageOrientation]
             completionBlock:^(NSURL *assetURL, NSError *error){
             if (error) {
             NSLog(@" save but error...");
             
             id delegate = [self delegate];
             if ([delegate respondsToSelector:@selector(captureStillImageFailedWithError:)]) {
             [delegate captureStillImageFailedWithError:error];
             }
             } else {
             NSLog(@" save without error...");
             }
             }];
             [library release];
             [image release];
             */
            
        }
        
        if ([self.delegate respondsToSelector:@selector(FWVideoCameraDidFinishCaptureStillImage:)]) {
            [self.delegate FWVideoCameraDidFinishCaptureStillImage:self];
        }
        
        
    }];
    
}


#pragma mark - Cancel album photo and go back to normal
- (void)cancelAlbumPhotoAndGoBackToNormal {
    
    /*
     [self.filter removeTarget:self.gpuImageView_HD];
     [self.filter addTarget:self.gpuImageView];
     [self.stillImageSource removeTarget:self.filter];
     */
    
    [self.rotationFilter addTarget:self.filter];
    
    self.stillImageSource = nil;
    self.rawImage = nil;
    
    [self forceSwitchToNewFilter:self.currentFilterType];
    [self startCameraCapture];
    
}


#pragma mark - Switch Filter
- (void)switchToNewFilter {
    self.filter = self.internalFilter;
    
    switch (self.currentFilterType) {
        case FW_AMARO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case FW_RISE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case FW_HUDSON_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case FW_XPROII_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case FW_SIERRA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case FW_LOMOFI_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case FW_EARLYBIRD_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case FW_SUTRO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case FW_TOASTER_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case FW_BRANNAN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case FW_INKWELL_FILTER: {
            
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case FW_WALDEN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case FW_HEFE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case FW_VALENCIA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case FW_NASHVILLE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case FW_1977_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case FW_LORDKELVIN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case FW_NORMAL_FILTER: {
            break;
        }
            
        default: {
            break;
        }
    }
    
    
    if (self.stillImageSource != nil) {
        
        [self.stillImageSource processImage];
        self.processImage = [self.filter imageFromCurrentlyProcessedOutput];
        NSLog(@"%@",self.processImage);
    } else {
        
    }
}

- (void)forceSwitchToNewFilter:(FWFilterType)type {
    
    self.currentFilterType = type;
    
    dispatch_async(self.prepareFilterQueue, ^{
        switch (type) {
            case FW_AMARO_FILTER: {
                self.internalFilter = [[FWAmaroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackboard1024" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amaroMap" ofType:@"png"]]];
                break;
            }
                
            case FW_NORMAL_FILTER: {
                self.internalFilter = [[FWNormalFilter alloc] init];
                break;
            }
                
            case FW_RISE_FILTER: {
                self.internalFilter = [[FWRiseFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackboard1024" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"riseMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_HUDSON_FILTER: {
                self.internalFilter = [[FWHudsonFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudsonBackground" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudsonMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_XPROII_FILTER: {
                self.internalFilter = [[FWXproIIFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xproMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_SIERRA_FILTER: {
                self.internalFilter = [[FWSierraFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sierraVignette" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sierraMap" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_LOMOFI_FILTER: {
                self.internalFilter = [[FWLomofiFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lomoMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_EARLYBIRD_FILTER: {
                self.internalFilter = [[FWEarlybirdFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlyBirdCurves" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdOverlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdBlowout" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdMap" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_SUTRO_FILTER: {
                self.internalFilter = [[FWSutroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroMetal" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"softLight" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroEdgeBurn" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroCurves" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_TOASTER_FILTER: {
                self.internalFilter = [[FWToasterFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterMetal" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterSoftLight" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterCurves" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterOverlayMapWarm" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterColorShift" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_BRANNAN_FILTER: {
                self.internalFilter = [[FWBrannanFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanProcess" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanBlowout" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanContrast" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanLuma" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanScreen" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_INKWELL_FILTER: {
                self.internalFilter = [[FWInkwellFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"inkwellMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_WALDEN_FILTER: {
                self.internalFilter = [[FWWaldenFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waldenMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_HEFE_FILTER: {
                self.internalFilter = [[FWHefeFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edgeBurn" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeGradientMap" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeSoftLight" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeMetal" ofType:@"png"]]];
                
                
                break;
            }
                
            case FW_VALENCIA_FILTER: {
                self.internalFilter = [[FWValenciaFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"valenciaMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"valenciaGradientMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_NASHVILLE_FILTER: {
                self.internalFilter = [[FWNashvilleFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nashvilleMap" ofType:@"png"]]];
                
                break;
            }
                
            case FW_1977_FILTER: {
                self.internalFilter = [[FW1977Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1977map" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1977blowout" ofType:@"png"]]];
                
                break;
            }
                
            case FW_LORDKELVIN_FILTER: {
                self.internalFilter = [[FWLordKelvinFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kelvinMap" ofType:@"png"]]];
                
                break;
            }
                
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
        
    });
}

- (void)switchFilter:(FWFilterType)type {
    
    if ((self.rawImage != nil) && (self.stillImageSource == nil)) {
        [self forceSwitchToNewFilter:type];
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
    }
}


#pragma mark - init
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality {
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.captureSession addOutput:self.stillImageOutput];
    
    self.prepareFilterQueue = dispatch_queue_create("FW.FWMeituApp.FILTERQUEUE", NULL);
      NSLog(@"%@...",self.prepareFilterQueue);
    //    self.rotationFilter = [[FWRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
    //    [self addTarget:self.rotationFilter];
    //
    //    self.filter = [[FWNormalFilter alloc] init];
    //    self.internalFilter = self.filter;
    //
    //    [self.rotationFilter addTarget:self.filter];
    
    //    self.gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 45, FM_SCREEN_WIDTH, FM_SCREEN_HEIGHT-160)];
    //    if (isHighQuality == YES) {
    //        self.gpuImageView.layer.contentsScale = 2.0f;
    //    } else {
    //        self.gpuImageView.layer.contentsScale = 1.0f;
    //    }
    //    [self.filter addTarget:self.gpuImageView];
    //
    //    self.gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[self.gpuImageView bounds]];
    //    self.gpuImageView_HD.hidden = YES;
    //    [self.gpuImageView addSubview:self.gpuImageView_HD];
    
    return self;
}

@end

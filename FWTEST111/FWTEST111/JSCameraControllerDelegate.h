//
//  JSCameraControllerDelegate.h
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JSCameraControllerDelegate <NSObject>
- (void)didFinishPick_Image:(UIImage *)image;//取景完成
@end

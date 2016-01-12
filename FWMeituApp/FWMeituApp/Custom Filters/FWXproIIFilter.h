//
//  FWXproIIFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@interface FWFilter12 : GPUImageThreeInputFilter

@end

@interface FWXproIIFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@end

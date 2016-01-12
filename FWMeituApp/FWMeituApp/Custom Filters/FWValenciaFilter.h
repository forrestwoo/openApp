//
//  FWValenciaFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@interface FWFilter8 : GPUImageThreeInputFilter

@end

@interface FWValenciaFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@end

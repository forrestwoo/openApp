//
//  FWLOMOFilter1.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@interface FWFilterLOMO : GPUImageTwoInputFilter

@end

@interface FWLOMOFilter1 : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}
@end

//
//  FWLOMOFilter1.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWLOMOFilter1.h"

@implementation FWLOMOFilter1


- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    FWFilter6 *filter = [[FWFilter6 alloc] init];
    [self addFilter:filter];
    
    UIImage *image = [UIImage imageNamed:@"lomoMap"];
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
    UIImage *image1 = [UIImage imageNamed:@"vignetteMap"];
    imageSource2 = [[GPUImagePicture alloc] initWithImage:image1];
    [imageSource2 addTarget:filter atTextureLocation:2];
    [imageSource2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
}
@end

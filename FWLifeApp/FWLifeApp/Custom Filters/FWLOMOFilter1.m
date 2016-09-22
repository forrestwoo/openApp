//
//  FWLOMOFilter1.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWLOMOFilter1.h"
#import "FWLomofiFilter.h"

NSString *const kFWLomoShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 red = vec2(texel.r, 0.16666);
     vec2 green = vec2(texel.g, 0.5);
     vec2 blue = vec2(texel.b, 0.83333);
     
     texel.rgb = vec3(
                      texture2D(inputImageTexture2, red).r,
                      texture2D(inputImageTexture2, green).g,
                      texture2D(inputImageTexture2, blue).b);
     
     gl_FragColor = vec4(texel,1.0);
 }
 );

@implementation FWFilterLOMO

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kFWLomoShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

@implementation FWLOMOFilter1


- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    FWFilterLOMO *filter = [[FWFilterLOMO alloc] init];
    [self addFilter:filter];
    
    UIImage *image = [UIImage imageNamed:@"lomoMap"];
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
}
@end

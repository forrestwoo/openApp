//
//  FWNormalFilter.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-11.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWNormalFilter.h"

NSString *const kIFNormalShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWNormalFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNormalShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFSutroShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //sutroMap;
 uniform sampler2D inputImageTexture3; //sutroMetal;
 uniform sampler2D inputImageTexture4; //softLight
 uniform sampler2D inputImageTexture5; //sutroEdgeburn
 uniform sampler2D inputImageTexture6; //sutroCurves
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture2, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture2, lookup).b;
     
     vec3 rgbPrime = vec3(0.1019, 0.0, 0.0);
     float m = dot(vec3(.3, .59, .11), texel.rgb) - 0.03058;
     texel = mix(texel, rgbPrime + m, 0.32);
     
     vec3 metal = texture2D(inputImageTexture3, textureCoordinate).rgb;
     texel.r = texture2D(inputImageTexture4, vec2(metal.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture4, vec2(metal.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture4, vec2(metal.b, texel.b)).b;
     
     texel = texel * texture2D(inputImageTexture5, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture6, vec2(texel.r, .16666)).r;
     texel.g = texture2D(inputImageTexture6, vec2(texel.g, .5)).g;
     texel.b = texture2D(inputImageTexture6, vec2(texel.b, .83333)).b;
     
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWSutroFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFSutroShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

@implementation FWRotationFilter

- (void)newFrameReady;
{
    static const GLfloat rotationSquareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat rotateLeftTextureCoordinates[] = {
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
    };
    
    static const GLfloat rotateRightTextureCoordinates[] = {
        0.0f, 1.0f,
        0.0f, 0.0f,
        0.75f, 1.0f,
        0.75f, 0.0f,
    };
    
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
    
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f,  1.0f,
        0.0f,  1.0f,
    };
    
    switch (rotationMode)
    {
        case kGPUImageRotateLeft: [self renderToTextureWithVertices:rotationSquareVertices textureCoordinates:rotateLeftTextureCoordinates]; break;
        case kGPUImageRotateRight: [self renderToTextureWithVertices:rotationSquareVertices textureCoordinates:rotateRightTextureCoordinates]; break;
        case kGPUImageFlipHorizonal: [self renderToTextureWithVertices:rotationSquareVertices textureCoordinates:verticalFlipTextureCoordinates]; break;
        case kGPUImageFlipVertical: [self renderToTextureWithVertices:rotationSquareVertices textureCoordinates:horizontalFlipTextureCoordinates]; break;
    }
    
}

@end

NSString *const kIFAmaroShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );

@implementation FWAmaroFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFAmaroShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end



NSString *const kIFRiseShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );

@implementation FWRiseFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFRiseShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFHudsonShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     gl_FragColor = mapped;
 }
 );

@implementation FWHudsonFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFHudsonShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFXproIIShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //vigMap
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     vec2 red = vec2(texel.r, 0.16666);
     vec2 green = vec2(texel.g, 0.5);
     vec2 blue = vec2(texel.b, .83333);
     texel.r = texture2D(inputImageTexture2, red).r;
     texel.g = texture2D(inputImageTexture2, green).g;
     texel.b = texture2D(inputImageTexture2, blue).b;
     
     gl_FragColor = vec4(texel, 1.0);
     
 }
 );

@implementation FWXproIIFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFXproIIShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFSierraShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );

@implementation FWSierraFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFSierraShaderString]))
    {
        return nil;
    }
    
    return self;
}

NSString *const kIFLomofiShaderString = SHADER_STRING
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
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(texel,1.0);
 }
 );

@end

@implementation FWLomofiFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFLomofiShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFEarlybirdShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //earlyBirdCurves
 uniform sampler2D inputImageTexture3; //earlyBirdOverlay
 uniform sampler2D inputImageTexture4; //vig
 uniform sampler2D inputImageTexture5; //earlyBirdBlowout
 uniform sampler2D inputImageTexture6; //earlyBirdMap
 
 const mat3 saturate = mat3(
                            1.210300,
                            -0.089700,
                            -0.091000,
                            -0.176100,
                            1.123900,
                            -0.177400,
                            -0.034200,
                            -0.034200,
                            1.265800);
 const vec3 rgbPrime = vec3(0.25098, 0.14640522, 0.0);
 const vec3 desaturate = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     
     vec2 lookup;
     lookup.y = 0.5;
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     float desaturatedColor;
     vec3 result;
     desaturatedColor = dot(desaturate, texel);
     
     
     lookup.x = desaturatedColor;
     result.r = texture2D(inputImageTexture3, lookup).r;
     lookup.x = desaturatedColor;
     result.g = texture2D(inputImageTexture3, lookup).g;
     lookup.x = desaturatedColor;
     result.b = texture2D(inputImageTexture3, lookup).b;
     
     texel = saturate * mix(texel, result, .5);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     
     vec3 sampled;
     lookup.y = .5;
     
     /*
      lookup.x = texel.r;
      sampled.r = texture2D(inputImageTexture4, lookup).r;
      
      lookup.x = texel.g;
      sampled.g = texture2D(inputImageTexture4, lookup).g;
      
      lookup.x = texel.b;
      sampled.b = texture2D(inputImageTexture4, lookup).b;
      
      float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
      texel = mix(texel, sampled, value);
      */
     
     //---
     
     lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture4, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture4, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture4, lookup).b;
     float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
     
     //---
     
     lookup.x = texel.r;
     sampled.r = texture2D(inputImageTexture5, lookup).r;
     lookup.x = texel.g;
     sampled.g = texture2D(inputImageTexture5, lookup).g;
     lookup.x = texel.b;
     sampled.b = texture2D(inputImageTexture5, lookup).b;
     texel = mix(sampled, texel, value);
     
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture6, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture6, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture6, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWEarlybirdFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFEarlybirdShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFToasterShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //toasterMetal
 uniform sampler2D inputImageTexture3; //toasterSoftlight
 uniform sampler2D inputImageTexture4; //toasterCurves
 uniform sampler2D inputImageTexture5; //toasterOverlayMapWarm
 uniform sampler2D inputImageTexture6; //toasterColorshift
 
 void main()
 {
     lowp vec3 texel;
     mediump vec2 lookup;
     vec2 blue;
     vec2 green;
     vec2 red;
     lowp vec4 tmpvar_1;
     tmpvar_1 = texture2D (inputImageTexture, textureCoordinate);
     texel = tmpvar_1.xyz;
     lowp vec4 tmpvar_2;
     tmpvar_2 = texture2D (inputImageTexture2, textureCoordinate);
     lowp vec2 tmpvar_3;
     tmpvar_3.x = tmpvar_2.x;
     tmpvar_3.y = tmpvar_1.x;
     texel.x = texture2D (inputImageTexture3, tmpvar_3).x;
     lowp vec2 tmpvar_4;
     tmpvar_4.x = tmpvar_2.y;
     tmpvar_4.y = tmpvar_1.y;
     texel.y = texture2D (inputImageTexture3, tmpvar_4).y;
     lowp vec2 tmpvar_5;
     tmpvar_5.x = tmpvar_2.z;
     tmpvar_5.y = tmpvar_1.z;
     texel.z = texture2D (inputImageTexture3, tmpvar_5).z;
     red.x = texel.x;
     red.y = 0.16666;
     green.x = texel.y;
     green.y = 0.5;
     blue.x = texel.z;
     blue.y = 0.833333;
     texel.x = texture2D (inputImageTexture4, red).x;
     texel.y = texture2D (inputImageTexture4, green).y;
     texel.z = texture2D (inputImageTexture4, blue).z;
     mediump vec2 tmpvar_6;
     tmpvar_6 = ((2.0 * textureCoordinate) - 1.0);
     mediump vec2 tmpvar_7;
     tmpvar_7.x = dot (tmpvar_6, tmpvar_6);
     tmpvar_7.y = texel.x;
     lookup = tmpvar_7;
     texel.x = texture2D (inputImageTexture5, tmpvar_7).x;
     lookup.y = texel.y;
     texel.y = texture2D (inputImageTexture5, lookup).y;
     lookup.y = texel.z;
     texel.z = texture2D (inputImageTexture5, lookup).z;
     red.x = texel.x;
     green.x = texel.y;
     blue.x = texel.z;
     texel.x = texture2D (inputImageTexture6, red).x;
     texel.y = texture2D (inputImageTexture6, green).y;
     texel.z = texture2D (inputImageTexture6, blue).z;
     lowp vec4 tmpvar_8;
     tmpvar_8.w = 1.0;
     tmpvar_8.xyz = texel;
     gl_FragColor = tmpvar_8;
 }
 );

@implementation FWToasterFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFToasterShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFBrannanShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //process
 uniform sampler2D inputImageTexture3;  //blowout
 uniform sampler2D inputImageTexture4;  //contrast
 uniform sampler2D inputImageTexture5;  //luma
 uniform sampler2D inputImageTexture6;  //screen
 
 mat3 saturateMatrix = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 luma = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 lookup;
     lookup.y = 0.5;
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     texel = saturateMatrix * texel;
     
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec3 sampled;
     lookup.y = 0.5;
     lookup.x = texel.r;
     sampled.r = texture2D(inputImageTexture3, lookup).r;
     lookup.x = texel.g;
     sampled.g = texture2D(inputImageTexture3, lookup).g;
     lookup.x = texel.b;
     sampled.b = texture2D(inputImageTexture3, lookup).b;
     float value = smoothstep(0.0, 1.0, d);
     texel = mix(sampled, texel, value);
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture4, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture4, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture4, lookup).b;
     
     
     lookup.x = dot(texel, luma);
     texel = mix(texture2D(inputImageTexture5, lookup).rgb, texel, .5);
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture6, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture6, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture6, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWBrannanFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFBrannanShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFInkWellShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFWaldenShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //vigMap
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWWaldenFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFWaldenShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end


NSString *const kIFHefeShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //edgeBurn
 uniform sampler2D inputImageTexture3;  //hefeMap
 uniform sampler2D inputImageTexture4;  //hefeGradientMap
 uniform sampler2D inputImageTexture5;  //hefeSoftLight
 uniform sampler2D inputImageTexture6;  //hefeMetal
 
 void main()
{
    vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
    vec3 edge = texture2D(inputImageTexture2, textureCoordinate).rgb;
    texel = texel * edge;
    
    texel = vec3(
                 texture2D(inputImageTexture3, vec2(texel.r, .16666)).r,
                 texture2D(inputImageTexture3, vec2(texel.g, .5)).g,
                 texture2D(inputImageTexture3, vec2(texel.b, .83333)).b);
    
    vec3 luma = vec3(.30, .59, .11);
    vec3 gradSample = texture2D(inputImageTexture4, vec2(dot(luma, texel), .5)).rgb;
    vec3 final = vec3(
                      texture2D(inputImageTexture5, vec2(gradSample.r, texel.r)).r,
                      texture2D(inputImageTexture5, vec2(gradSample.g, texel.g)).g,
                      texture2D(inputImageTexture5, vec2(gradSample.b, texel.b)).b
                      );
    
    vec3 metal = texture2D(inputImageTexture6, textureCoordinate).rgb;
    vec3 metaled = vec3(
                        texture2D(inputImageTexture5, vec2(metal.r, texel.r)).r,
                        texture2D(inputImageTexture5, vec2(metal.g, texel.g)).g,
                        texture2D(inputImageTexture5, vec2(metal.b, texel.b)).b
                        );
    
    gl_FragColor = vec4(metaled, 1.0);
}
 );

@implementation FWHefeFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFHefeShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFValenciaShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //gradMap
 
 mat3 saturateMatrix = mat3(
                            1.1402,
                            -0.0598,
                            -0.061,
                            -0.1174,
                            1.0826,
                            -0.1186,
                            -0.0228,
                            -0.0228,
                            1.1772);
 
 vec3 lumaCoeffs = vec3(.3, .59, .11);
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .1666666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .8333333)).b
                  );
     
     texel = saturateMatrix * texel;
     float luma = dot(lumaCoeffs, texel);
     texel = vec3(
                  texture2D(inputImageTexture3, vec2(luma, texel.r)).r,
                  texture2D(inputImageTexture3, vec2(luma, texel.g)).g,
                  texture2D(inputImageTexture3, vec2(luma, texel.b)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWValenciaFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFValenciaShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIFNashvilleShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWNashvilleFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNashvilleShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kIF1977ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FW1977Filter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIF1977ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

NSString *const kLordKelvinShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 lookup;
     lookup.y = .5;
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWLordKelvinFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLordKelvinShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

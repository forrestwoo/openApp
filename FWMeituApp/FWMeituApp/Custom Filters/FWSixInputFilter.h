//
//  FWSixInputFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWFiveInputFilter.h"

@interface FWSixInputFilter : FWFiveInputFilter
{
    GPUImageFramebuffer *sixthInputFramebuffer;
    
    GLint filterSixthTextureCoordinateAttribute;
    GLint filterInputTextureUniform6;
    GPUImageRotationMode inputRotation6;
    GLuint filterSourceTexture6;
    CMTime sixthFrameTime;
    
    BOOL hasSetFifthTexture, hasReceivedSixthFrame, sixthFrameWasVideo;
    BOOL sixthFrameCheckDisabled;
}

- (void)disableSixthFrameCheck;
@end

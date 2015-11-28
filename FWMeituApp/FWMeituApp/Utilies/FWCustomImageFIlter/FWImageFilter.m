//
//  FWImageFilter.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-10.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWImageFilter.h"

@interface FWImageFilter ()
{
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform, filterInputTextureUniform2, filterInputTextureUniform3, filterInputTextureUniform4, filterInputTextureUniform5, filterInputTextureUniform6;
    
    GLuint filterFramebuffer;
}
@end

@implementation FWImageFilter

- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    [GPUImageContext useImageProcessingContext];
    filterProgram = [[GLProgram alloc] initWithVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:fragmentShaderString];
    
    [filterProgram addAttribute:@"position"];
    [filterProgram addAttribute:@"inputTextureCoordinate"];
    
    if (![filterProgram link])
    {
        NSString *progLog = [filterProgram programLog];
        NSLog(@"Program link log: %@", progLog);
        NSString *fragLog = [filterProgram fragmentShaderLog];
        NSLog(@"Fragment shader compile log: %@", fragLog);
        NSString *vertLog = [filterProgram vertexShaderLog];
        NSLog(@"Vertex shader compile log: %@", vertLog);
        filterProgram = nil;
        NSAssert(NO, @"Filter shader link failed");
    }
    
    filterPositionAttribute = [filterProgram attributeIndex:@"position"];
    filterTextureCoordinateAttribute = [filterProgram attributeIndex:@"inputTextureCoordinate"];
    filterInputTextureUniform = [filterProgram uniformIndex:@"inputImageTexture"]; // This does assume a name of "inputImageTexture" for the fragment shader
    filterInputTextureUniform2 = [filterProgram uniformIndex:@"inputImageTexture2"]; // This does assume a name of "inputImageTexture2" for second input texture in the fragment shader
    filterInputTextureUniform3 = [filterProgram uniformIndex:@"inputImageTexture3"]; // This does assume a name of "inputImageTexture3" for second input texture in the fragment shader
    filterInputTextureUniform4 = [filterProgram uniformIndex:@"inputImageTexture4"]; // This does assume a name of "inputImageTexture4" for second input texture in the fragment shader
    filterInputTextureUniform5 = [filterProgram uniformIndex:@"inputImageTexture5"]; // This does assume a name of "inputImageTexture5" for second input texture in the fragment shader
    filterInputTextureUniform6 = [filterProgram uniformIndex:@"inputImageTexture6"]; // This does assume a name of "inputImageTexture6" for second input texture in the fragment shader
    
    
    [filterProgram use];
    glEnableVertexAttribArray(filterPositionAttribute);
    glEnableVertexAttribArray(filterTextureCoordinateAttribute);
    
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    [GPUImageContext useImageProcessingContext];
    [self setFilterFBO];
    
    [filterProgram use];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, filterSourceTexture);
    
    glUniform1i(filterInputTextureUniform, 2);
    
    if (filterSourceTexture2 != 0)
    {
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, filterSourceTexture2);
        
        glUniform1i(filterInputTextureUniform2, 3);
    }
    if (filterSourceTexture3 != 0)
    {
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, filterSourceTexture3);
        glUniform1i(filterInputTextureUniform3, 4);
    }
    if (filterSourceTexture4 != 0)
    {
        glActiveTexture(GL_TEXTURE5);
        glBindTexture(GL_TEXTURE_2D, filterSourceTexture4);
        glUniform1i(filterInputTextureUniform4, 5);
    }
    if (filterSourceTexture5 != 0)
    {
        glActiveTexture(GL_TEXTURE6);
        glBindTexture(GL_TEXTURE_2D, filterSourceTexture5);
        glUniform1i(filterInputTextureUniform5, 6);
    }
    if (filterSourceTexture6 != 0)
    {
        glActiveTexture(GL_TEXTURE7);
        glBindTexture(GL_TEXTURE_2D, filterSourceTexture6);
        glUniform1i(filterInputTextureUniform6, 7);
    }
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    for (id<GPUImageInput> currentTarget in targets)
    {
        [currentTarget setInputSize:inputTextureSize];
        [currentTarget newFrameReady];
    }
}

- (void)setFilterFBO;
{
    if (!filterFramebuffer)
    {
        [self createFilterFBO];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, filterFramebuffer);
    
    CGSize currentFBOSize = [self sizeOfFBO];
    glViewport(0, 0, (int)currentFBOSize.width, (int)currentFBOSize.height);
}

- (void)createFilterFBO;
{
    glActiveTexture(GL_TEXTURE1);
    glGenFramebuffers(1, &filterFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, filterFramebuffer);
    
    CGSize currentFBOSize = [self sizeOfFBO];
    //    NSLog(@"Filter size: %f, %f", currentFBOSize.width, currentFBOSize.height);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, (int)currentFBOSize.width, (int)currentFBOSize.height);
    glBindTexture(GL_TEXTURE_2D, outputTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)currentFBOSize.width, (int)currentFBOSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, outputTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);
}

- (CGSize)sizeOfFBO;
{
    return CGSizeMake(320, 460);
//    CGSize outputSize = [self maximumOutputSize];
//    if ( (CGSizeEqualToSize(outputSize, CGSizeZero)) || (inputTextureSize.width < outputSize.width) )
//    {
//        return inputTextureSize;
//    }
//    else
//    {
//        return outputSize;
//    }
}

- (void)setInputTexture:(GLuint)newInputTexture atIndex:(NSInteger)textureIndex;
{
    if (textureIndex == 0)
    {
        filterSourceTexture = newInputTexture;
    }
    else if (filterSourceTexture2 == 0)
    {
        filterSourceTexture2 = newInputTexture;
    }
    else if (filterSourceTexture3 == 0) {
        filterSourceTexture3 = newInputTexture;
    }
    else if (filterSourceTexture4 == 0) {
        filterSourceTexture4 = newInputTexture;
    }
    else if (filterSourceTexture5 == 0) {
        filterSourceTexture5 = newInputTexture;
    }
    else if (filterSourceTexture6 == 0) {
        filterSourceTexture6 = newInputTexture;
    }
    
}



@end

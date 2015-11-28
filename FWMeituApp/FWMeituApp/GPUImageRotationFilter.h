#import "GPUImageFilter.h"

@interface GPUImageRotationFilter : GPUImageFilter
{
    GPUImageRotationMode rotationMode;
}

// Initialization and teardown
- (id)initWithRotation:(GPUImageRotationMode)newRotationMode;

@end

//
//  FWResizeControl.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-5.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWResizeControl.h"

@interface FWResizeControl ( )

@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic) CGPoint startPoint;

@end

@implementation FWResizeControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 44.0f, 44.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint translationInView = [gestureRecognizer translationInView:self.superview];
//        self.startPoint = CGPointMake(roundf(translationInView.x), translationInView.y);
////        NSLog(@"began:%@", NSStringFromCGPoint(translationInView));
//        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidBeginResizing:)]) {
//            [self.delegate resizeConrolViewDidBeginResizing:self];
//        }
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [gestureRecognizer translationInView:self.superview];
////        NSLog(@"changed:%@", NSStringFromCGPoint(translation));
//
//        self.translation = CGPointMake(roundf(self.startPoint.x + translation.x),
//                                       roundf(self.startPoint.y + translation.y));
////        if (self.translation.x < 0 || self.translation.y < 0) {
////            return;
////        }
////        NSLog(@"x.%@,superView:%@,sx=%f,sy=%f",NSStringFromCGPoint(self.translation),NSStringFromClass([self.superview class]),self.startPoint.x,self.startPoint.y);
//        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidResize:)]) {
//            [self.delegate resizeConrolViewDidResize:self];
//        }
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidEndResizing:)]) {
//            [self.delegate resizeConrolViewDidEndResizing:self];
//        }
//    }
    NSLog(@"-----------");
}

@end

//
//  FWResizeControl.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-5.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FWResizeControl : UIView

@property (weak, nonatomic) id delegate;
@property (nonatomic, readonly) CGPoint translation;

@end

@protocol FWRsizeControlViewDelegate <NSObject>

- (void)resizeConrolViewDidBeginResizing:(FWResizeControl *)resizeConrolView;
- (void)resizeConrolViewDidResize:(FWResizeControl *)resizeConrolView;
- (void)resizeConrolViewDidEndResizing:(FWResizeControl *)resizeConrolView;

@end
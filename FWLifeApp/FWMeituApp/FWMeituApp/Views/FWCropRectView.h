//
//  FWCropRectView.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-5.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWCropRectView : UIView

@property (nonatomic) id delegate;
@property (nonatomic) BOOL showsGridMajor;
@property (nonatomic) BOOL showsGridMinor;
@property (nonatomic) BOOL dragEnable;

@end

@protocol FWCropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(FWCropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(FWCropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(FWCropRectView *)cropRectView;

@end
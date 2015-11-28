//
//  FWTopView.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-9-18.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTopView : UIView

@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) UILabel  *textNumberLabel;

- (void)initView:(NSString *)numberString;

@end

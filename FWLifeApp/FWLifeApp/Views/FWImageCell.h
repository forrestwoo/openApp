//
//  FWImageCell.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FWImageViewOfCellGestureDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN
- (void)gestureImage:(UIImage *)image;

NS_ASSUME_NONNULL_END

@end

@interface FWImageCell : UITableViewCell

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic,nonnull, strong)UIImageView *FirstImageView;
@property (nonatomic,nonnull, strong)UIImageView *secondImageView;
@property (nonatomic, weak) id<FWImageViewOfCellGestureDelegate> gesturedelegate;
NS_ASSUME_NONNULL_END

- (void)setViews;

@end

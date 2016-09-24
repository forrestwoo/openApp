//
//  FWPhotoCell.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/23.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface FWPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) PHImageManager *imageManager;

@end

//
//  FWPhotoCollectionViewController.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/23.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "FWPhotoAlbums.h"

@interface FWPhotoCollectionViewController : UICollectionViewController

@property (nonatomic, strong) FWPhotoAlbums *model;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout model:(FWPhotoAlbums *)model;

@end

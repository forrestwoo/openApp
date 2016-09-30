//
//  FWPhotoMagager.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/24.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPhotoAlbums.h"

@interface FWPhotoManager : NSObject

+ (instancetype)sharedManager;

- (NSArray <FWPhotoAlbums *> *)getPhotoAlbums;

- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image, NSDictionary *info))completion;

- (void)requestImageForAsset:(PHAsset *)asset scale:(CGFloat)scale resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

- (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset ;
@end

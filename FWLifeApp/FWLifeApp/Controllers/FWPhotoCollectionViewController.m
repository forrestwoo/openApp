//
//  FWPhotoCollectionViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/23.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWPhotoCollectionViewController.h"
#import "FWPhotoCell.h"
#import "FWPhotoManager.h"
#import "FWPhotosLayout.h"
#import "FWDisplayBigImageViewController.h"

@interface FWPhotoCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    NSArray<PHAsset *> *_dataSouce;
}
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@end

@implementation FWPhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout model:(FWPhotoAlbums *)model
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.model = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.navigationController.navigationBarHidden = YES;
    // Register cell classes
    CGRect frame = self.collectionView.frame;
    frame.origin.y+=44;
    self.collectionView.frame = frame;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initSource];
}

//- (void)setModel:(FWPhotoAlbums *)model
//{
//    self.model = model;
//    
//    [self initSource];
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)initSource
{
    [self.collectionView registerClass:[FWPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.title = self.model.albumName;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.assetCollection = self.model.assetCollection;
    _dataSouce = [[FWPhotoManager sharedManager] getAssetsInAssetCollection:self.assetCollection ascending:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSouce count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWPhotosLayout *lay = (FWPhotosLayout *)collectionViewLayout;
    return CGSizeMake([lay cellWidth],[lay cellWidth]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = _dataSouce[indexPath.row];
    __block UIImage *bImage = nil;
    CGSize size = cell.frame.size;
    size.width *= 3;
    size.height *= 3;
    [[FWPhotoManager sharedManager] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        bImage = image;
    }];
    
    [cell setImage:bImage];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = _dataSouce[indexPath.row];

    [[FWPhotoManager sharedManager] requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        FWDisplayBigImageViewController *vc = [[FWDisplayBigImageViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
   
}
#pragma mark <UICollectionViewDelegate>

@end

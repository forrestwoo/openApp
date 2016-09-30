//
//  FWPhotoAblumTableViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/23.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWPhotoAlbumTableViewController.h"
#import "FWPhotoManager.h"
#import "UIButton+TextAndImageHorizontalDisplay.h"
#import "FWPhotoCollectionViewController.h"
#import "FWPhotosLayout.h"

@interface FWPhotoAlbumTableViewController ()
{
    NSMutableArray<FWPhotoAlbums *> *mArr;
}

@end

@implementation FWPhotoAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册";
    
    mArr= [[[FWPhotoManager sharedManager] getPhotoAlbums] mutableCopy];
    
    [self initNavgationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initNavgationBar
{
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBar.frame = CGRectMake(0, 0, 68, 32);
    [rightBar setImage:[UIImage imageNamed:@"Camera"] withTitle:@"相机" forState:UIControlStateNormal];
    [rightBar addTarget:self action:@selector(cameraClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
}

- (void)cameraClicked
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    FWPhotoAlbums *album = mArr[indexPath.row];
    cell.textLabel.text =album.albumName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",album.albumImageCount];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    __block UIImage *img = nil;
    [[FWPhotoManager sharedManager] requestImageForAsset:album.firstImageAsset size:CGSizeMake(60 * 3, 60 * 3) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
        img = image;
    }];
    cell.imageView.image = img;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWPhotoAlbums *model = [mArr objectAtIndex:indexPath.row];
    FWPhotosLayout *layout = [[FWPhotosLayout alloc] init];
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 5.0;
    FWPhotoCollectionViewController *vc = [[FWPhotoCollectionViewController alloc] initWithCollectionViewLayout:layout model:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

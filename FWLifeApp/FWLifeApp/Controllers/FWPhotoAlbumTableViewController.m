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

@interface FWPhotoAlbumTableViewController ()
{
    NSMutableArray<FWPhotoAlbums *> *mArr;
}

@end

@implementation FWPhotoAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择照片";
    
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
    return 88;
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d张",album.albumImageCount];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    [[FWPhotoManager sharedManager] requestImageForAsset:album.firstImageAsset size:CGSizeMake(50 * 3, 50 * 3) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
        cell.imageView.image = image;
    }];
   
    cell.imageView.frame = CGRectMake(10, 9, 50, 50);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

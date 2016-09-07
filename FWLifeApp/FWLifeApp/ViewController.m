//
//  ViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/8/21.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "ViewController.h"

#import "FWConst.h"
#import "TFHpple.h"
#import "Web_API.h"
#import "UIImageView+WebCache.h"
#import "NSString+ArrayForImage.h"
#import "FWImageCell.h"
#import "SDWebImageManager.h"
#import "FWFullImageViewController.h"

#define kMargin 5
@interface ViewController () <FWImageViewOfCellGestureDelegate>
{
    CGFloat _adjustheight;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITextField *tx = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, 200, 30)];
//    tx.textColor = [UIColor blackColor];
//    [self.view addSubview:tx];
    _adjustheight = 0.0;
    
    NSString *urlString = [kWebsite stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
self.title = @"图片";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [self screenWidth], [self screenheight] - 0) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    

    [self.view addSubview:self.tableView];
    [[Web_API sharedInstance] htmlDataWithURLString:urlString completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSData *jsonData = [str jsonDataWithBeginString:@"\"data\":"];
//        NSLog(@"%@",NSStringFromClass( [str class]));
        
        self.imageUrls = [str imageUrlsWithBeginString:@"\"objURL\":\"" endString:@".jpg"];
      
     
        __weak UITableView *weakTable = self.tableView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakTable reloadData];
            
        });
    }];
    
//    [[UIScreen mainScreen] bounds].size
    
/*
 i1 i2
 
 
 
 
 **/
}

- (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)screenheight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (void)setFrame4ImageViewWithImage1:(UIImage *)image1 image2:(UIImage *)image2
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat image1_width  = image1.size.width;
    CGFloat image1_height = image1.size.height;
    CGFloat image2_width  = image2.size.width;
    CGFloat image2_height = image2.size.height;
    CGFloat adjust_height = (screenWidth - 3 * kMargin) / (image1_width / image1_height + image2_width / image2_height);
    CGFloat image1_adjustWith = (image1_width * adjust_height) / image1_height;
    CGFloat image2_adjustWith = (image2_width * adjust_height) / image2_height;
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceilf(self.imageUrls.count / 2.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)gestureImage:(UIImage *)image
{
//    UIImage *im = image;
    FWFullImageViewController *vc = [[FWFullImageViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:vc animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FWImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[FWImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.gesturedelegate = self;
    }
    
    [cell.FirstImageView setShowActivityIndicatorView:YES];
    [cell.FirstImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell.secondImageView setShowActivityIndicatorView:YES];
    [cell.secondImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];

    cell.FirstImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.FirstImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:indexPath.row *2]]
                      placeholderImage:[UIImage imageNamed:@"ll.png"] options:SDWebImageRefreshCached];
    
    if (indexPath.row + 1 < [self.imageUrls count]) {
        [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:(indexPath.row * 2 + 1)]]
                                placeholderImage:[UIImage imageNamed:@"ll.png"] options:SDWebImageRefreshCached];
    }
    
    return cell;
}



- (CGSize)CellSizeToFit:(CGSize)size
{
    CGFloat width = [self screenWidth];
    CGFloat imageWidth = size.width;
    CGFloat adjustHeight = (width - 10) * size.height / imageWidth;
    _adjustheight = adjustHeight;
    return CGSizeMake(width - 10, adjustHeight);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

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
#import "FWBeautyViewController.h"
#import "FWDisplayBigImageViewController.h"
#import "MBProgressHUD.h"

#define kMargin 5
@interface ViewController () <FWImageViewOfCellGestureDelegate>
{
    CGFloat _adjustheight;
    int _pageNumber;
    
}

@end

@implementation ViewController

- (instancetype)initWithURLString:(NSString *)urlString keyWord:(NSString *)keyWord
{
    if (self = [super init])
    {
        self.urlString = urlString;
        self.keyWord = keyWord;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adjustheight = 0.0;
    _pageNumber = 0;

    self.title = @"图片";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [self screenWidth], [self screenheight] - 0) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.view addSubview:self.tableView];
    
//    self.tabBarController.it
    
    [[Web_API sharedInstance] htmlDataWithURLString:self.urlString completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSData *jsonData = [str jsonDataWithBeginString:@"\"data\":"];
        //        NSLog(@"%@",NSStringFromClass( [str class]));
        if (!error) {
            self.imageUrls = [str imageUrlsWithBeginString:@"\"objURL\":\"" endString:@".jpg"];
            
            __weak UITableView *weakTable = self.tableView;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
        }
    }];
}


- (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)screenheight
{
    return [[UIScreen mainScreen] bounds].size.height;
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
    FWDisplayBigImageViewController *vc111 = [[FWDisplayBigImageViewController alloc] initWithImage:image];

    [self.navigationController pushViewController:vc111 animated:YES];
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
    if (indexPath.row *2 < [self.imageUrls count]) {
        [cell.FirstImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:indexPath.row *2]]
                               placeholderImage:[UIImage imageNamed:@"ll.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (!image) {
                                       //                                   [self.imageUrls removeObjectAtIndex:indexPath.row *2];
                                       //
                                       //                                   [tableView reloadData];
                                       
                                       cell.FirstImageView.userInteractionEnabled = NO;
                                       //
                                   }
                               }];
    }
    if (indexPath.row *2 + 1 < [self.imageUrls count]) {
        [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:(indexPath.row * 2 + 1)]]
                                placeholderImage:[UIImage imageNamed:@"ll.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (!image) {
                                        //                                        [self.imageUrls removeObjectAtIndex:indexPath.row *2 + 1];
                                        //                                        [tableView reloadData];
                                        cell.secondImageView.userInteractionEnabled = NO;
                                        
                                    }
                                }];
    }
    
    return cell;
}

//上拉加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y - scrollView.contentSize.height > - [self screenheight] + 20)
    {
        
        _pageNumber++;
        NSString *urlString = [[[[Web_API sharedInstance] getRootURL] stringByAppendingFormat:@"%@&pn=%d",self.keyWord,_pageNumber * 30] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"new url is %@",urlString);
        [[Web_API sharedInstance] htmlDataWithURLString:urlString completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //        NSData *jsonData = [str jsonDataWithBeginString:@"\"data\":"];
            //        NSLog(@"%@",NSStringFromClass( [str class]));
            if (!error) {
                NSMutableArray *ma= [str imageUrlsWithBeginString:@"\"objURL\":\"" endString:@".jpg"];
                [self.imageUrls addObjectsFromArray:ma];
                __weak UITableView *weakTable = self.tableView;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTable reloadData];
                    
                });
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

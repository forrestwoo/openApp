//
//  FWSearchImageViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/14.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWSearchImageViewController.h"
#import "ViewController.h"
#import "Web_API.h"
#import "TFHpple.h"
#import "MBProgressHUD.h"
#import "FWDisplayBigImageViewController.h"
#import "FWImageCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface FWSearchImageViewController ()<FWImageViewOfCellGestureDelegate>
{
    UISearchBar *_searchBar;
    NSMutableArray *_imageURLs;
    MBProgressHUD *_HUD;
}
@end

@implementation FWSearchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入您要搜索的图片！";
    self.navigationItem.titleView = _searchBar;
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在搜索";
    [_HUD show:YES];
    [self.navigationController.view addSubview:_HUD];


    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
 
    NSLog(@"%f",self.tableView.tableHeaderView.frame.size.height);
    [self.view addSubview:self.tableView];
    [[Web_API sharedInstance] htmlDataWithURLString:@"http://vi.sualize.us/" completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
        
        NSArray *elementsForAuthor = [htmlParser searchWithXPathQuery:@"//img[@class = 'bookmark-thumbnail']"];
        if ([elementsForAuthor count])
        {
            _imageURLs = [[NSMutableArray alloc] initWithCapacity:[elementsForAuthor count]];
            for (int i = 0; i < [elementsForAuthor count]; i++) {
                TFHppleElement *element = [elementsForAuthor objectAtIndex:i];
                NSDictionary *dict = [element attributes];
                NSString *imageURL = [dict objectForKey:@"src"];
                [_imageURLs addObject:imageURL];
            }
            
            __weak UITableView *weakTable = self.tableView;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakTable reloadData];
                                    [_HUD removeFromSuperview];
                
            });
            
        }
    }];
    
}

#pragma mark - Table View

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 30)];
    label.text = @"推荐";
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceilf(_imageURLs.count / 2.0);
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
    if (indexPath.row *2 < [_imageURLs count]) {
        [cell.FirstImageView sd_setImageWithURL:[NSURL URLWithString:[_imageURLs objectAtIndex:indexPath.row *2]]
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
    if (indexPath.row *2 + 1 < [_imageURLs count]) {
        [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:[_imageURLs objectAtIndex:(indexPath.row * 2 + 1)]]
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


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *baseURL = [[[[Web_API sharedInstance] getRootURL] stringByAppendingFormat:@"%@&pn=0",searchBar.text] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ViewController *vc = [[ViewController alloc] initWithURLString:baseURL keyWord:searchBar.text];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

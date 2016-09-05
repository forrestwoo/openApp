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
#import "FWtestVC.h"
#import "FWImageCell.h"
#import "SDWebImageManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *tx = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, 200, 30)];
    tx.textColor = [UIColor blackColor];
    [self.view addSubview:tx];
    
    
    NSString *urlString = [kWebsite stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableArray *thumbImageUrls = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *objImageUrls = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 320, 480) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [[Web_API sharedInstance] htmlDataWithURLString:urlString completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        thumbImageUrls = [str imageUrlsWithBeginString:@"" endString:@""];
        self.imageUrls = [str imageUrlsWithBeginString:@"\"objURL\":\"" endString:@".jpg"];
      
        __weak UITableView *weakTable = self.tableView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakTable reloadData];
            
        });
    }];
    
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageUrls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FWImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[FWImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.imageView setShowActivityIndicatorView:YES];
    [cell.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSLog(@"url string is %@", [self.imageUrls objectAtIndex:indexPath.row]);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:indexPath.row]]
                      placeholderImage:[UIImage imageNamed:@"ll.png"] options:SDWebImageRefreshCached];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

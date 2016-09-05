//
//  FWtestVC.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWtestVC.h"
#import "UIImageView+WebCache.h"

@interface FWtestVC ()
{

}
@end
@implementation FWtestVC

- (void)viewDidLoad
{
    [self flushCache];
}
- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.imageView setShowActivityIndicatorView:YES];
    [cell.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSLog(@"url string is %@", [self.imageUrls objectAtIndex:indexPath.row]);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:indexPath.row]]
                      placeholderImage:[UIImage imageNamed:@"ll.png"] ];
    return cell;
}

@end

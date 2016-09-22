//
//  FWSearchImageViewController.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/14.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWSearchImageViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, strong) UITableView *tableView;
NS_ASSUME_NONNULL_END

@end

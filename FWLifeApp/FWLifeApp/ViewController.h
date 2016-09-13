//
//  ViewController.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/8/21.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic, strong) UITableView *tableView;

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *keyWord;

- (instancetype)initWithURLString:(NSString *)urlString keyWord:(NSString *)keyWord;
NS_ASSUME_NONNULL_END

@end


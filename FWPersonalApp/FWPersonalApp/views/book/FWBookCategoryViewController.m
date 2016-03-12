//
//  FWBookCategoryViewController.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/22.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWBookCategoryViewController.h"
#import "FWBookCategoryViewModel.h"

@interface FWBookCategoryViewController ()

@property (nonatomic, strong) NSString *urlString;
@end

@implementation FWBookCategoryViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init])
    {
        self.urlString = urlString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screenSize.width, 20)];
    la.text = self.urlString;
    
    [self.view addSubview:la];
    self.view.backgroundColor = [UIColor redColor];
    
    FWBookCategoryViewModel *model = [[FWBookCategoryViewModel alloc] initWithUrlString:self.urlString];
    
}

- (void)setupTopView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

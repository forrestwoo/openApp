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

@interface FWSearchImageViewController ()
{
    UISearchBar *_searchBar;
}
@end

@implementation FWSearchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 74, 266, 30)];
    _searchBar.delegate = self;
    

    [self.view addSubview:_searchBar];
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

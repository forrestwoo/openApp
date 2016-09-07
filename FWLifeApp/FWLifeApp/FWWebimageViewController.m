//
//  FWWebimageViewController.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/7.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWWebimageViewController.h"

@implementation FWWebimageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
}

#pragma mark - BDDynamicGridViewDelegate

- (NSUInteger)maximumViewsPerCell
{
    return 2;
}

- (NSUInteger)numberOfViews
{
  return [[self images] count];
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
//    UIImageView *imageView =
    return nil;
}
@end

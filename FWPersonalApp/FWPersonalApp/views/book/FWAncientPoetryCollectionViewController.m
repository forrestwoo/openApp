//
//  FWAncientPoetryCollectionViewController.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/17.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//



#import "FWAncientPoetryCollectionViewController.h"

#import "FWBookShelfDecarationView.h"
#import "FWBookshelfCollectionViewLayout.h"
#import "FWBookCategoryViewController.h"

@interface FWAncientPoetryCollectionViewController () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation FWAncientPoetryCollectionViewController

static NSString * const cellReuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"古籍";
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookShelfBackground.png"]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    self.books = [[NSMutableArray alloc] initWithArray:[self bookNameOfAllBooks]];
}

- (NSArray *)bookNameOfAllBooks
{
  return [[FWDataManager getDataForPoetry] allKeys];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:self.books[indexPath.item]];
    cell.backgroundColor = [UIColor colorWithPatternImage:image];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *theBookName = self.books[fromIndexPath.item];
    [self.books removeObjectAtIndex:fromIndexPath.item];
    [self.books insertObject:theBookName atIndex:toIndexPath.item];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth, kCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWBookCategoryViewController *vc = [[FWBookCategoryViewController alloc] initWithUrlString:[[FWDataManager getDataForPoetry] objectForKey:self.books[indexPath.item]]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [self.books removeAllObjects];
    self.books = nil;
}

@end

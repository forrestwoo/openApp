//
//  FWAncientPoetryCollectionViewController.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/17.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWAncientPoetryCollectionViewController.h"
#import "FWDataManager.h"
#import "FWBookShelfDecarationView.h"
#import "FWBookshelfCollectionViewLayout.h"

@interface FWAncientPoetryCollectionViewController () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation FWAncientPoetryCollectionViewController

static NSString * const cellReuseIdentifier = @"Cell";
static NSString * const headerReuseIdentifier = @"Header";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookShelfBackground.png"]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    self.books = [[NSMutableArray alloc] initWithArray:[self bookNameOfAllBooks]];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(375, 50);
}

//
//- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
//    header.backgroundColor = [UIColor yellowColor];
//    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(150, 25, 375, 20)];
//    la.text = @"古籍";
//    [header addSubview:la];
//    
//    return header;
//}

#pragma mark - UICollectionViewDelegateFlowLayout

//配置每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 150);
}

////配置item的边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 20, 0, 20);
//}

//- (NSLayoutAttribute *)


#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

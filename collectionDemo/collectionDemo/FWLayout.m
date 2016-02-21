//
//  FWLayout.m
//  collectionDemo
//
//  Created by hzkmn on 16/2/16.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWLayout.h"

#import "DecorationViwe.h"

@implementation FWLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self registerClass:[DecorationViwe class] forDecorationViewOfKind:@"lay"];
}

- (CGSize)screenSize
{
    
    return [UIScreen mainScreen].bounds.size;
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", NSStringFromCGSize([self screenSize]));375 667
    UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = CGRectMake(20 + indexPath.item * (100 + 17.5), 45+ indexPath.section * (146 + 65), 100, 146);
    attris.frame = frame;
    NSLog(@"%@", NSStringFromCGRect(frame));

    return attris;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attris.frame=CGRectMake(0, (216*indexPath.section)/2, [self screenSize].width, 216);
    attris.zIndex = -1;
    return attris;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray* attributes = [NSMutableArray array];
    
    //把Decoration View的布局加入可见区域布局。
    
    for (int y=0; y<3; y++)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:3 inSection:y];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:@"lay" atIndexPath:indexPath]];
    }
    
    for (NSInteger i=0 ; i < 3; i++)
    {
        for (NSInteger t=0; t<3; t++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:t inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return attributes;
}
@end

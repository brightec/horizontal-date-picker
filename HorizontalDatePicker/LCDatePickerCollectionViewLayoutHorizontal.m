//
//  LCDatePickerCollectionViewLayoutHorizontal.m
//  Lowcost
//
//  Created by Cameron Cooke on 29/07/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "LCDatePickerCollectionViewLayoutHorizontal.h"


static CGFloat const LCHeaderHeight = 60.0f;
static CGFloat const LCItemSize = 40.0f;
static CGFloat const LCContentInset = 20.0f;


NSString *const LCDatePickerCollectionViewElementKindCell = @"LCDatePickerCollectionViewElementKindCell";
NSString *const LCDatePickerCollectionViewElementKindSectionHeader = @"LCDatePickerCollectionViewElementKindSectionHeader";


@interface LCDatePickerCollectionViewLayoutHorizontal ()
@property (nonatomic) NSMutableDictionary *layoutInformation;
@property (nonatomic) NSInteger numberOfColumns;
@end


@implementation LCDatePickerCollectionViewLayoutHorizontal


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _layoutInformation = [@[] mutableCopy];
        _numberOfColumns = 7;
    }
    
    return self;
}


# pragma mark -
# pragma mark Helpers

- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row / self.numberOfColumns;
    NSInteger column = indexPath.row % self.numberOfColumns;
    
    CGFloat w = LCItemSize;
    CGFloat h = LCItemSize;
    CGFloat y = LCHeaderHeight + (row * h);
    CGFloat x = column * w;
    
    // apply offset to cell to account for section (i.e. month)
    x += [self offsetForIndexPath:indexPath];
    
    CGRect frame = CGRectMake(x, y, w, h);
    return frame;
}


- (CGRect)frameForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame;
    if (kind == LCDatePickerCollectionViewElementKindSectionHeader) {
        CGFloat containerWidth = [self containerWidth];
        
        CGFloat w = containerWidth;
        CGFloat h = LCHeaderHeight;
        CGFloat y = 0;
        CGFloat x = indexPath.section * CGRectGetWidth(frame);
        
        // apply offset to header to account for section (i.e. month)
        x += [self offsetForIndexPath:indexPath];
        
        frame = CGRectMake(x, y, w, h);
    }
    return frame;
}



- (CGFloat)offsetForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat containerWidth = [self containerWidth];
    NSInteger page = floorf(indexPath.section / 2) + 1;
    CGFloat offset = (indexPath.section * (containerWidth + LCContentInset)) + (page * LCContentInset);
    return offset;
}


- (CGFloat)containerWidth;
{
    CGFloat containerWidth = (self.collectionView.bounds.size.width - (LCContentInset * 3)) / 2;
    return containerWidth;
}


# pragma mark -
# pragma mark Overrides

- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.numberOfSections * self.collectionView.bounds.size.width;
    CGFloat height = self.collectionView.bounds.size.height;
    CGSize contentSize = CGSizeMake(width, height);
    return contentSize;
}


- (void)prepareLayout
{
    NSMutableDictionary *cellInformation = [@{} mutableCopy];
    NSMutableDictionary *headerInformation = [@{} mutableCopy];
    NSMutableDictionary *layoutInformation = [@{} mutableCopy];
    
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = [self frameForCellAtIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
        }
        
        // section header
        UICollectionViewLayoutAttributes *headerAttrbutes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:LCDatePickerCollectionViewElementKindSectionHeader withIndexPath:indexPath];
        headerAttrbutes.frame = [self frameForSupplementaryViewOfKind:LCDatePickerCollectionViewElementKindSectionHeader atIndexPath:indexPath];
        [headerInformation setObject:headerAttrbutes forKey:[NSIndexPath indexPathForRow:0 inSection:section]];
    }
    
    [layoutInformation setObject:cellInformation forKey:LCDatePickerCollectionViewElementKindCell];
    [layoutInformation setObject:headerInformation forKey:LCDatePickerCollectionViewElementKindSectionHeader];
    self.layoutInformation = layoutInformation;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInformation[LCDatePickerCollectionViewElementKindCell][indexPath];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInformation[kind][indexPath];
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    
    for(NSString *key in self.layoutInformation) {
        NSDictionary *attributesDict = self.layoutInformation[key];
        for(NSIndexPath *indexPath in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = attributesDict[indexPath];
            if(CGRectIntersectsRect(rect, attributes.frame)){
                [layoutAttributes addObject:attributes];
            }
        }
    }
    
    return layoutAttributes;
}


@end

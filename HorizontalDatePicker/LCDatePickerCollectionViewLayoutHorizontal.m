//
//  LCDatePickerCollectionViewLayoutHorizontal.m
//  Lowcost
//
//  Created by Cameron Cooke on 29/07/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "LCDatePickerCollectionViewLayoutHorizontal.h"


static CGFloat const LCMinInterItemSpacing = 0;
static CGFloat const LCMinLineSpacing = 0;
static CGFloat const LCInsetTop = 0;
static CGFloat const LCInsetLeft = 0;
static CGFloat const LCInsetBottom = 0;
static CGFloat const LCInsetRight = 0;
static CGFloat const LCHeaderHeight = 60.0f;
static CGFloat const LCItemSize = 87.0f;


@implementation LCDatePickerCollectionViewLayoutHorizontal


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.minimumInteritemSpacing = LCMinInterItemSpacing;
        self.minimumLineSpacing = LCMinLineSpacing;
        self.sectionInset = UIEdgeInsetsMake(LCInsetTop, LCInsetLeft, LCInsetBottom, LCInsetRight);
        self.headerReferenceSize = CGSizeMake(LCHeaderHeight, 0);
        self.itemSize = CGSizeMake(LCItemSize, LCItemSize);
    }
    
    return self;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    CGFloat x;
    CGFloat y;
    NSInteger columnCounter = 0;
    NSInteger rowCounter = 0;
    NSInteger section = 0;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {

            // if new section then reset row back to zero
            if (attribute.indexPath.section != section) {
                section = attribute.indexPath.section;
                rowCounter = 0;
            }
            
            CGFloat w = self.itemSize.width;
            CGFloat h = self.itemSize.height;
            x = columnCounter * w;
            x = x + (section * self.collectionView.bounds.size.width);
            y = rowCounter * h;
            
            CGRect frame = CGRectMake(x, y, w, h);
            attribute.frame = frame;
            
            NSLog(@"Row=%li Col=%li x=%f y=%f section=%li", (long)rowCounter, (long)columnCounter, x, y, (long)section);
            
            // if next column is 7 i.e. Sat move to new row
            columnCounter++;
            if (columnCounter == 7) {
                rowCounter++;
                columnCounter = 0;
            }
            
        } else if (attribute.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            CGRect frame = attribute.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            attribute.frame = frame;
        }
    }
    
    return attributes;
}


@end

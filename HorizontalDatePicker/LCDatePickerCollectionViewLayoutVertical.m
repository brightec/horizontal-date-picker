//
//  LCDatePickerCollectionViewLayoutVertical.m
//
//  Created by m dani on 12/05/14.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "LCDatePickerCollectionViewLayoutVertical.h"


static CGFloat const LCMinInterItemSpacing = 0.0f;
static CGFloat const LCMinLineSpacing = 0.0f;
static CGFloat const LCInsetTop = 0.0f;
static CGFloat const LCInsetLeft = 2.4f;
static CGFloat const LCInsetBottom = 0.0f;
static CGFloat const LCInsetRight = 2.4f;
static CGFloat const LCHeaderHeight = 60.0f;


@implementation LCDatePickerCollectionViewLayoutVertical


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.minimumInteritemSpacing = LCMinInterItemSpacing;
        self.minimumLineSpacing = LCMinLineSpacing;
        self.sectionInset = UIEdgeInsetsMake(LCInsetTop, LCInsetLeft, LCInsetBottom, LCInsetRight);
        self.headerReferenceSize = CGSizeMake(0, LCHeaderHeight);
        self.itemSize = CGSizeMake(45.0f, 45.0f);
    }
    
    return self;
}


@end

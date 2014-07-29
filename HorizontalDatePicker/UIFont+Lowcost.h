//
//  UIFont+Lowcost.h
//  Lowcost
//
//  Created by Cameron Cooke on 03/10/2013.
//  Copyright (c) 2013 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIFont (Lowcost)
+ (UIFont *)lowcostFontWithSize:(CGFloat)size;
+ (UIFont *)lowcostBoldFontWithSize:(CGFloat)size;
+ (UIFont *)lowcostMediumFontWithSize:(CGFloat)size;
+ (UIFont *)lowcostThinFontWithSize:(CGFloat)size;
+ (UIFont *)lowcostUltraThinFontWithSize:(CGFloat)size;

+ (UIFont *)lowcostTableViewSectionHeaderFont;
+ (UIFont *)lowcostButtonTitleFont;
@end
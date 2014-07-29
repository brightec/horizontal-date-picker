//
//  UIFont+Lowcost.m
//  Lowcost
//
//  Created by Cameron Cooke on 03/10/2013.
//  Copyright (c) 2013 Brightec Ltd. All rights reserved.
//

#import "UIFont+Lowcost.h"


@implementation UIFont (Lowcost)

# pragma mark -
# pragma mark Standard fonts

+ (UIFont *)lowcostFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}


+ (UIFont *)lowcostBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}


+ (UIFont *)lowcostMediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}


+ (UIFont *)lowcostThinFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}


+ (UIFont *)lowcostUltraThinFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}


# pragma mark -
# pragma mark UI fonts

+ (UIFont *)lowcostTableViewSectionHeaderFont
{
    return [self lowcostThinFontWithSize:16.0f];
}


+ (UIFont *)lowcostButtonTitleFont
{
    return [self lowcostMediumFontWithSize:22.0f];
}


@end
//
//  UIColor+Lowcost.m
//  Lowcost
//
//  Created by Cameron Cooke on 03/10/2013.
//  Copyright (c) 2013 Brightec Ltd. All rights reserved.
//

#import "UIColor+Lowcost.h"
#import "UIColor+ColorWithHex.h"


@implementation UIColor (Lowcost)


+ (UIColor *)lowcostTintColor
{
    return [self lowcostGreenColor];
}


+ (UIColor *)lowcostGreenColor
{
    return [UIColor colorWithHex:0x3fadad];
}


+ (UIColor *)lowcostRedColor
{
    return [UIColor colorWithHex:0xd61842];
}


+ (UIColor *)lowcostMenuTableViewCellColor
{
    return [UIColor colorWithHex:0xf2f2f2];
}


+ (UIColor *)lowcostButtonColor
{
    return [self lowcostGreenColor];
}


+ (UIColor *)lowcostButtonHighlightedColor
{
    return [self colorWithHex:0x256361];
}


+ (UIColor *)lowcostRedButtonColor
{
    return [self lowcostRedColor];
}


+ (UIColor *)lowcostRedButtonHighlightedColor
{
    return [self colorWithHex:0xA01338];
}



+ (UIColor *)lowcostBackgroundColor
{
    return [self colorWithHex:0xf2f2f2];
}


+ (UIColor *)tableViewSepeatorColor
{
    static UIColor *colour = nil;
    if (colour == nil) {
        UITableView *tv = [UITableView new];
        colour = tv.separatorColor;
    }
    return colour;
}


@end

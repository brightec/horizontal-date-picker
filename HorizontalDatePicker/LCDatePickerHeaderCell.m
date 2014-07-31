//
//  LCDatePickerHeaderCell.m
//
//  Created by m dani on 06/05/2014.
//  Refactored by Cameron Cooke on 28/05/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "LCDatePickerHeaderCell.h"
#import "UIFont+Lowcost.h"
#import "UIColor+ColorWithHex.h"
#import "UIView+autolayout.h"


@implementation LCDatePickerHeaderCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // Month name label
        _currentMonthLb = [UILabel new];
        _currentMonthLb.textAlignment = NSTextAlignmentLeft;
        _currentMonthLb.translatesAutoresizingMaskIntoConstraints = NO;
        _currentMonthLb.font = [UIFont lowcostFontWithSize:17.0f];
        _currentMonthLb.textColor = [UIColor colorWithHex:0x808080];
        _currentMonthLb.backgroundColor = [UIColor clearColor];
        [self addSubview:_currentMonthLb];
        [self pinView:_currentMonthLb toEdges:BTPinnedEdgeLeading margin:12.0f];
        [self pinView:_currentMonthLb toEdges:BTPinnedEdgeTrailing margin:12.0f];
        
        // create weekday labels
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.calendar = [NSCalendar currentCalendar];
        NSArray *weekDays = [dateFormatter shortWeekdaySymbols];

        UILabel *lastLabel = nil;
        for (NSString *weekDay in weekDays) {
            
            // create label
            UILabel *label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.font = [UIFont lowcostFontWithSize:10.0f];
            label.textColor = [UIColor colorWithHex:0xbababa];
            label.text = [weekDay uppercaseString];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            
            if (lastLabel == nil) {
                [self pinView:label toEdge:NSLayoutAttributeTop ofView:_currentMonthLb edge:NSLayoutAttributeBottom withSpacing:5.0f];
                [self pinView:label toEdge:NSLayoutAttributeBottom ofView:self edge:NSLayoutAttributeBottom withSpacing:-5.0f];
                [self pinView:label toEdge:NSLayoutAttributeLeading ofView:self edge:NSLayoutAttributeLeading withSpacing:0];
            } else {
                [self pinView:label toEdge:NSLayoutAttributeBaseline ofView:lastLabel edge:NSLayoutAttributeBaseline withSpacing:0];
                [self pinView:label toEdge:NSLayoutAttributeLeading ofView:lastLabel edge:NSLayoutAttributeTrailing withSpacing:0];
                [self pinView:label toEdge:NSLayoutAttributeWidth ofView:lastLabel edge:NSLayoutAttributeWidth withSpacing:0];
            }
            
            if (weekDays.lastObject == weekDay) {
                [self pinView:label toEdge:NSLayoutAttributeTrailing ofView:self edge:NSLayoutAttributeTrailing withSpacing:0];
            }
            
            lastLabel = label;
        }
        
        // Add a saperator at the of the header
        UIView *separatorView = [UIView new];
        separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        separatorView.backgroundColor = [UIColor colorWithHex:0xe1e0df];
        [self addSubview:separatorView];
        [separatorView pinHeight:1.0f];
        [self pinView:separatorView toEdges:BTPinnedEdgeLeading|BTPinnedEdgeTrailing];
        [self pinView:separatorView toEdges:BTPinnedEdgeBottom margin:0];
    }

    return self;
}


@end

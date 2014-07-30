//
//  LCDatePickerDateCell.m
//
//  Created by m dani on 05/05/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "LCDatePickerDateCell.h"
#import "UIFont+Lowcost.h"
#import "UIColor+ColorWithHex.h"
#import "UIColor+Lowcost.h"
#import "UIView+autolayout.h"


@interface LCDatePickerDateCell ()
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isPastDate;

@property (nonatomic) UIColor *defaultTextColor;
@property (nonatomic) UIColor *highlightedTextColor;
@property (nonatomic) UIColor *disabledTextColor;
@property (nonatomic) UIColor *firstLastDateTextColor;
@property (nonatomic) UIColor *highlightedCellBackgroundColor;
@property (nonatomic) UIFont *defaultFont;
@property (nonatomic) UIFont *firstLastDateFont;
@property (nonatomic) UIFont *todayFont;
@property (nonatomic) UIColor *defaultBackgroundColor;
@end


@implementation LCDatePickerDateCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _dateValue = nil;
        _defaultTextColor = [UIColor colorWithHex:0x808080];
        _highlightedTextColor = [UIColor colorWithHex:0x5d5d5d];
        _disabledTextColor = [UIColor colorWithHex:0xdcdcdc];
        _firstLastDateTextColor = [UIColor whiteColor];
        _highlightedCellBackgroundColor = [UIColor colorWithHex:0x9CE2DF];
        _defaultFont = [UIFont lowcostFontWithSize:19.0f];
        _firstLastDateFont = [UIFont lowcostMediumFontWithSize:19.0f];
        _todayFont = [UIFont lowcostMediumFontWithSize:19.0f];
        _defaultBackgroundColor = [UIColor randomColor];

        // Set a new UILabel & its properties to display on Custom Cell. */
        _dateLb = [UILabel new];
        _dateLb.textAlignment = NSTextAlignmentCenter;
        self.dateLb.textColor = self.defaultTextColor;
        [self.contentView addSubview:self.dateLb];
        self.dateLb.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateLb.backgroundColor = [UIColor clearColor];

        self.dateLb.layer.masksToBounds = YES;


        // Set relative position of the lable into the cell, recrusively */
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLb attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        // add seperator
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


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.layer.contents = nil;
}


/*Task-**: Set actual date value (day) into date lable. */
- (void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSString *day = @"";

    if (date && calendar) {
        _dateValue = date;
        day = [LCDatePickerDateCell getDayOfDate:date withCalendar:calendar];
    }
    self.dateLb.text = day;
}


/*Task-**: Retrun a day from the given date.*/
+ (NSString *)getDayOfDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d";
    });

    //Test if the calendar is different than the current dateFormatter calendar property
    if (! [dateFormatter.calendar isEqual:calendar]) {
        dateFormatter.calendar = calendar;
    }

    return [dateFormatter stringFromDate:date];
}


/* Task-5.1 : Setter method for a "selected" flag */
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}


/* Task-5.2 : Set first date bg, text color and mark it as "selected". */
- (void)setFirstDateSelected
{
    [self setSelected:true];

//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"first-date-selected"]];
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"first-date-selected"].CGImage;
    self.dateLb.textColor = self.firstLastDateTextColor;
    self.dateLb.font = self.firstLastDateFont;

}


- (void)nonSelectableDate
{
    self.dateLb.textColor = self.disabledTextColor;
    self.dateLb.font = self.defaultFont;
    self.backgroundColor = self.defaultBackgroundColor;
    self.layer.contents = nil;
}


- (void)selectableDate
{
    self.dateLb.textColor = self.defaultTextColor;
    self.dateLb.font = self.defaultFont;
    self.backgroundColor = self.defaultBackgroundColor;
    self.layer.contents = nil;
}


/* Task-7.2 : Set end date with bg, text color and mark it as "selected". */
- (void)setLastDateSelected
{
    [self setSelected:true];

//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"last-date-selected"]];
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"last-date-selected"].CGImage;
    self.dateLb.textColor = self.firstLastDateTextColor;
    self.dateLb.font = self.firstLastDateFont;
}


/* Task-8.2 : Set bg color, text color and mark it as "deselected"*/
- (void)deselectDate
{
    [self setSelected:false];

    self.backgroundColor = self.defaultBackgroundColor;
    self.dateLb.textColor = self.defaultTextColor;
    self.dateLb.font = self.defaultFont;
    self.layer.contents = nil;
}


/* Task-7.4 : Set bg color, text color of the falling into the range. */
- (void)highlightDate
{
    self.backgroundColor = self.highlightedCellBackgroundColor;
    self.dateLb.textColor = self.highlightedTextColor;
    self.dateLb.font = self.defaultFont;
}


/* Task-9.3 : Set bg color and text color for "dehighlighted" state */
- (void)deHighlightDate
{
    self.backgroundColor = self.defaultBackgroundColor;
    self.dateLb.textColor = self.defaultTextColor;
    self.dateLb.font = self.defaultFont;
    self.layer.contents = nil;;
}


/* Task-11.2  : Style current date's text */
- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;

    self.dateLb.font = self.todayFont;
    self.backgroundColor = self.defaultBackgroundColor;
    self.layer.contents = nil;
}

@end

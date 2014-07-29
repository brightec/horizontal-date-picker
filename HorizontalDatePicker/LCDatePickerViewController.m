//
//  LCDatePickerViewController.m
//
//  Created by m dani on 05/05/2014.
//  Modifications and refactoring by Cameron Cooke on 28/05/2014
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"

typedef struct {
    NSInteger year;
    NSInteger month;
    NSInteger day;
} CustomDatePickerDate;


#import "LCDatePickerViewController.h"
#import "LCDatePickerDateCell.h"
#import "LCDatePickerHeaderCell.h"
#import "LCDatePickerCollectionViewLayoutVertical.h"


static NSString *calendarCellID = @"myCell";
static NSString *calenderHeaderCellID = @"sectionHeader";


@interface LCDatePickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedDatesButton;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UIView *infoBar;
@property (nonatomic) IBOutlet UILabel *infoBarLabel;
@property (nonatomic) NSString *infoBarDefaultText;
@property (nonatomic) NSString *infoBarSelectedFutureDateText;

@property (nonatomic) NSDateFormatter *headerDateFormatter;
@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSDate *firstDateOfUpperBound;
@property (nonatomic) NSDate *lastDateOfLowerBound;
@property (nonatomic) NSDate *firstSelectedDate;
@property (nonatomic) NSDate *lastSelectedDate;
@end


@implementation LCDatePickerViewController


- (void)dealloc
{
    NSLog(@"%@ dealloc'ed", NSStringFromClass([self class]));
}


- (id)initWithSelectedStartDate:(NSDate *)startDate endDate:(NSDate *)endDate delegate:(id<LCDatePickerViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        _calendar = [NSCalendar currentCalendar];
        [_calendar setFirstWeekday:1];
        
        _delegate = delegate;
        
        _firstSelectedDate = [self clampDate:startDate toComponents:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear];
        _lastSelectedDate = [self clampDate:endDate toComponents:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear];;

        _infoBarDefaultText = NSLocalizedString(@"Tap one date followed by another later date", nil);
        _infoBarSelectedFutureDateText = NSLocalizedString(@"Now tap a later date", nil);
    }
    return self;
}


# pragma mark -
# pragma mark View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasTouched:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasTouched:)];
    
    self.infoBarLabel.text = self.infoBarDefaultText;

    // Register the extended/custom cell to be used instead of default Collection View Cell
    [self.collectionView registerClass:[LCDatePickerDateCell class] forCellWithReuseIdentifier:calendarCellID];

    // Register the cell header which we customized
    [self.collectionView registerClass:[LCDatePickerHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:calenderHeaderCellID];

    // Add border radius to button
    self.todayButton.layer.cornerRadius = 10;
    self.todayButton.alpha = 0;
    self.selectedDatesButton.layer.cornerRadius = 10;
    self.selectedDatesButton.alpha = 0;
    
    [self updateUIState];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    NSDate *date = self.firstSelectedDate ? self.firstSelectedDate : [NSDate date];
//    NSIndexPath *indexPath = [self indexPathForCellAtDate:date];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    }
//}
//
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    if (self.firstSelectedDate) {
//        [self scrollToDate:self.firstSelectedDate animated:YES];
//        [self performSelector:@selector(updateTodayButton) withObject:nil afterDelay:1.0];
//    }
//}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}


# pragma mark -
# pragma mark Setters

- (void)setLowerBoundDate:(NSDate *)lowerBoundDate
{
    if (lowerBoundDate) {
        _lowerBoundDate = [self clampDate:lowerBoundDate toComponents:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear];
    } else {
        _lowerBoundDate = nil;
    }
}

- (void)setUpperBoundDate:(NSDate *)upperBoundDate
{
    if (upperBoundDate) {
        _upperBoundDate = [self clampDate:upperBoundDate toComponents:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear];
    } else {
        _upperBoundDate = nil;
    }
}


# pragma mark -
# pragma mark UI


- (void)showTodayButton
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.todayButton setAlpha:1.0];
    }];
}


- (void)hideTodayButton
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.todayButton setAlpha:0.0];
    }];
}


- (void)updateTodayButton
{
    if (self.todayButton.alpha < 1.0 && ! [self.collectionView.visibleCells containsObject:[self cellForItemAtDate:[NSDate date]]]) {
        [self showTodayButton];
    }
    if (self.todayButton.alpha > 0.0 && [self.collectionView.visibleCells containsObject:[self cellForItemAtDate:[NSDate date]]]) {
        [self hideTodayButton];
    }
}


- (void)showSelectedDatesButton
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.selectedDatesButton setAlpha:1.0];
    }];
}


- (void)hideSelectedDatesButton
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.selectedDatesButton setAlpha:0.0];
    }];
}


- (void)updateSelectedDatesButton
{
    if (self.firstSelectedDate) {
        if (self.selectedDatesButton.alpha < 1.0 && ! [self.collectionView.visibleCells containsObject:[self cellForItemAtDate:self.firstSelectedDate]]) {
            [self showSelectedDatesButton];
        }
        if (self.selectedDatesButton.alpha > 0.0 && [self.collectionView.visibleCells containsObject:[self cellForItemAtDate:self.firstSelectedDate]]) {
            [self hideSelectedDatesButton];
        }
    }
}


// Generic method to jump/scroll to date
//- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
//{
//    @try {
//        NSIndexPath *selectedDateIndexPath = [self indexPathForCellAtDate:date];
//
//        if (! [[self.collectionView indexPathsForVisibleItems] containsObject:selectedDateIndexPath]) {
//            NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:selectedDateIndexPath.section];
//            UICollectionViewLayoutAttributes *sectionLayoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:sectionIndexPath];
//            CGPoint origin = sectionLayoutAttributes.frame.origin;
//            origin.x = 0;
//            origin.y -= (70.0f + 5.0f + self.collectionView.contentInset.top);
//            [self.collectionView setContentOffset:origin animated:animated];
//        }
//    } @catch (NSException *exception) {
//        //Exception occurred (it should not according to the documentation, but in reality...) let's scroll to the IndexPath then
//        NSInteger section = [self sectionForDate:date];
//        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
//        [self.collectionView scrollToItemAtIndexPath:sectionIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
//    }
//}


- (void)updateUIState
{
    self.navigationItem.rightBarButtonItem.enabled = self.firstSelectedDate && self.lastSelectedDate;
    
    if (self.firstSelectedDate && !self.lastSelectedDate) {
        self.infoBarLabel.text = self.infoBarSelectedFutureDateText;
    } else if(self.firstSelectedDate && self.lastSelectedDate) {
        self.infoBarLabel.text = [self infoBarTextForSelectedDates];
    } else {
        self.infoBarLabel.text = self.infoBarDefaultText;
    }
}


- (NSString *)infoBarTextForSelectedDates
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE dd MMM"];
    NSString *fromDateStr = [formatter stringFromDate:self.firstSelectedDate];
    NSString *toDateStr = [formatter stringFromDate:self.lastSelectedDate];
    
    NSUInteger count = [self countDaysFromDate:self.firstSelectedDate toDate:self.lastSelectedDate];
    NSString *daysCount = [NSString stringWithFormat:@"%@ - %@ (%ld %@) ", fromDateStr, toDateStr, (long)count, NSLocalizedString(@"Nights", nil)];
    return daysCount;
}


# pragma mark -
# pragma mark Target action

- (IBAction)scrollToToday:(id)sender
{
//    self.firstDateOfUpperBound = nil;
//    self.lastDateOfLowerBound = nil;
//    [self.collectionView reloadData];
//    [self scrollToDate:[NSDate date] animated:YES];
//    [self performSelector:@selector(hideTodayButton) withObject:nil afterDelay:1.0];
//    [self performSelector:@selector(updateSelectedDatesButton) withObject:nil afterDelay:1.0];
}


- (IBAction)selectedDatesButtonWasTouched:(UIButton *)sender
{
//    [self scrollToDate:self.firstSelectedDate animated:YES];
//    [self performSelector:@selector(hideSelectedDatesButton) withObject:nil afterDelay:1.0];
//    [self performSelector:@selector(updateTodayButton) withObject:nil afterDelay:1.0];
}


- (void)cancelButtonWasTouched:(UIBarButtonItem *)button
{
    [self.delegate datePickerViewControllerCancelButtonWasTouched:self];
}


- (void)doneButtonWasTouched:(UIBarButtonItem *)button
{
    if (!self.firstSelectedDate && !self.lastSelectedDate) {
        return;
    }
    
    [self.delegate datePickerViewControllerDoneButtonWasTouched:self userPickedStartDate:self.firstSelectedDate endDate:self.lastSelectedDate];
}


# pragma mark -
# pragma mark Date Helpers

/*Task-3.2 - Returns first day of the month from the given date. */
- (NSDate *)firstDateOfMonth
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.firstDateOfUpperBound];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}


/*Task-3.3 - Returns last day of the month from the given date. */
- (NSDate *)lastDateOfMonth
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.lastDateOfLowerBound];
    components.month ++;
    components.day = 0;
    return [self.calendar dateFromComponents:components];
}


/*Task-3.3 - Returns first day of the calendar from a given upper bound of the calendar. */
- (NSDate *)firstDateOfUpperBound
{
    if (self.lowerBoundDate != nil) {
        [self setFirstDateOfUpperBound:self.lowerBoundDate];
    }


    if (_firstDateOfUpperBound == nil) {
        NSDate *now = [self.calendar dateFromComponents:[self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]]];
        CustomDatePickerDate firstDate = [self pickerDateFromDate:[self.calendar dateByAddingComponents:((^{
            NSDateComponents *components = [NSDateComponents new];
            components.year = - 6;
            return components;
        })())                                                                                    toDate:now options:0]];

        [self setFirstDateOfUpperBound:[self dateFromPickerDate:firstDate]];
    }

    return _firstDateOfUpperBound;
}


/*Task-3.4 - Returns last day of the calendar from a given lower bound of the calendar. */
- (NSDate *)lastDateOfLowerBound
{
    if (self.upperBoundDate != nil) {
        [self setLastDateOfLowerBound:self.upperBoundDate];
    }

    if (_lastDateOfLowerBound == nil) {
        NSDate *now = [self.calendar dateFromComponents:[self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]]];
        CustomDatePickerDate lastDate = [self pickerDateFromDate:[self.calendar dateByAddingComponents:((^{
            NSDateComponents *components = [NSDateComponents new];
            components.year = 6;
            return components;
        })())                                                                                   toDate:now options:0]];

        [self setLastDateOfLowerBound:[self dateFromPickerDate:lastDate]];
    }

    return _lastDateOfLowerBound;
}


// Generic method check whether given date is today's date or not
- (BOOL)isTodayDate:(NSDate *)date
{
    return [self clampAndCompareDate:date withReferenceDate:[NSDate date]];
}


/* Task-6.4 : Date marking method inside calendar object. */
- (NSDate *)clampDate:(NSDate *)date toComponents:(NSCalendarUnit)unitFlags
{
    if (!date) {
        return nil;
    }
    
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    return [self.calendar dateFromComponents:components];
}




/* Task-10.1 : Count the day/night range between start and end dates, and set a result string. */
- (NSUInteger)countDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    return [components day];
}


/* Task-6.3 : Utility to provide UI difference between dates. */
- (BOOL)clampAndCompareDate:(NSDate *)date withReferenceDate:(NSDate *)referenceDate
{
    NSDate *refDate = [self clampDate:referenceDate toComponents:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
    NSDate *clampedDate = [self clampDate:date toComponents:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
    return [refDate isEqualToDate:clampedDate];
}

// returns YES is reference date is between start and end date (not inclusive)
- (BOOL)isDate:(NSDate *)referenceDate betweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (!startDate || !endDate) {
        return NO;
    }
    
    BOOL result = [referenceDate compare:startDate] == NSOrderedDescending && [referenceDate compare:endDate] == NSOrderedAscending;
    return result;
}


# pragma mark -
# pragma mark General helpers

/*Task-3.7 - Returns first date of a given section (which is a month). */
- (NSDate *)firstDateOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    return [self.calendar dateByAddingComponents:offset toDate:self.firstDateOfMonth options:0];
}


/*Task-3.8 - Map cell index of a section with respective cell date. */
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstDateOfMonthForSection:indexPath.section];
    NSInteger ordinalityOfFirstDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstOfMonth];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
    return [self.calendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}


/*Task-4.9: Utility method to get the month and year out of a date formatter. */
- (NSDateFormatter *)headerDateFormatter
{
    if (! _headerDateFormatter) {
        _headerDateFormatter = [[NSDateFormatter alloc] init];
        _headerDateFormatter.calendar = self.calendar;
        _headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy LLLL" options:0 locale:self.calendar.locale];
    }
    return _headerDateFormatter;
}


/* Task-6.2 : Controlling the "selected" flag for first selected date depending on clamping logic. */
- (BOOL)isFirstSelectedDate:(NSDate *)date
{
    if (! self.firstSelectedDate) {
        return NO;
    }
    return [self clampAndCompareDate:date withReferenceDate:self.firstSelectedDate];
}


/* Task-7.6 : Controlling the "selected" flag for last selected date depending on clamping logic. */
- (BOOL)isLastSelectedDate:(NSDate *)date
{
    if (! self.lastSelectedDate) {
        return NO;
    }
    return [self clampAndCompareDate:date withReferenceDate:self.lastSelectedDate];
}


// Return the custom cell containing a given date.
- (LCDatePickerDateCell *)cellForItemAtDate:(NSDate *)date
{
    return (LCDatePickerDateCell *) [self.collectionView cellForItemAtIndexPath:[self indexPathForCellAtDate:date]];
}


- (NSIndexPath *)indexPathForCellAtDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }

    NSInteger section = [self sectionForDate:date];

    NSDate *firstOfMonth = [self firstDateOfMonthForSection:section];
    NSInteger ordinalityOfFirstDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstOfMonth];

    NSDateComponents *dateComponents = [self.calendar components:NSDayCalendarUnit fromDate:date];
    NSDateComponents *firstOfMonthComponents = [self.calendar components:NSDayCalendarUnit fromDate:firstOfMonth];
    NSInteger item = (dateComponents.day - firstOfMonthComponents.day) - (1 - ordinalityOfFirstDay);

    return [NSIndexPath indexPathForItem:item inSection:section];
}


/* Task-5.7 : Returns section for the selected date. */
- (NSInteger)sectionForDate:(NSDate *)date
{
    return [self.calendar components:NSMonthCalendarUnit fromDate:self.firstDateOfMonth toDate:date options:0].month;
}


- (CustomDatePickerDate)pickerDateFromDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    return (CustomDatePickerDate) {components.year, components.month, components.day};
}


- (NSDate *)dateFromPickerDate:(CustomDatePickerDate)dateStruct
{
    return [self.calendar dateFromComponents:[self dateComponentsFromPickerDate:dateStruct]];
}


- (NSDateComponents *)dateComponentsFromPickerDate:(CustomDatePickerDate)dateStruct
{
    NSDateComponents *components = [NSDateComponents new];
    components.year = dateStruct.year;
    components.month = dateStruct.month;
    components.day = dateStruct.day;
    return components;
}


- (void)appendPastDates
{

    [self shiftDatesByComponents:((^{
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.year = - 6;
        return dateComponents;
    })())];

}


- (void)appendFutureDates
{

    [self shiftDatesByComponents:((^{
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.year = 6;
        return dateComponents;
    })())];

}


- (void)shiftDatesByComponents:(NSDateComponents *)components
{
    UICollectionView *cv = self.collectionView;
    UICollectionViewFlowLayout *cvLayout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;

    NSArray *visibleCells = [self.collectionView visibleCells];
    if (! [visibleCells count])
        return;

    NSIndexPath *fromIndexPath = [cv indexPathForCell:((UICollectionViewCell *) visibleCells[0])];
    NSInteger fromSection = fromIndexPath.section;
    NSDate *fromSectionOfDate = [self dateForFirstDayInSection:fromSection];
    UICollectionViewLayoutAttributes *fromAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:fromSection]];
    CGPoint fromSectionOrigin = [self.view convertPoint:fromAttrs.frame.origin fromView:cv];

    self.firstDateOfUpperBound = [self dateFromPickerDate:[self pickerDateFromDate:[self.calendar dateByAddingComponents:components toDate:self.firstDateOfUpperBound options:0]]];
    self.lastDateOfLowerBound = [self dateFromPickerDate:[self pickerDateFromDate:[self.calendar dateByAddingComponents:components toDate:self.lastDateOfLowerBound options:0]]];

    [cv reloadData];
    [cvLayout invalidateLayout];
    [cvLayout prepareLayout];

    NSInteger toSection = [self.calendar components:NSMonthCalendarUnit fromDate:[self dateForFirstDayInSection:0] toDate:fromSectionOfDate options:0].month;
    UICollectionViewLayoutAttributes *toAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:toSection]];
    CGPoint toSectionOrigin = [self.view convertPoint:toAttrs.frame.origin fromView:cv];

    [cv setContentOffset:(CGPoint) {cv.contentOffset.x, cv.contentOffset.y + (toSectionOrigin.y - fromSectionOrigin.y)}];

}


- (NSDate *)dateForFirstDayInSection:(NSInteger)section
{

    return [self.calendar dateByAddingComponents:((^{
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.month = section;
        return dateComponents;
    })())                                 toDate:self.firstDateOfUpperBound options:0];

}


# pragma mark -
# pragma mark UICollectionViewDataSource/Delegate

/*Task-3.5 - Each section represents a month. This method will return total number of months between
 upperbound and lowerbound. */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //Each Section is a Month
    return [self.calendar components:NSMonthCalendarUnit fromDate:self.firstDateOfMonth toDate:self.lastDateOfMonth options:0].month + 1;
}


/*Task-3.6 - Returns a total number of cell needed to be display into each section. */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate *firstOfMonth = [self firstDateOfMonthForSection:section];
    NSRange rangeOfWeeks = [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstOfMonth];
    return (rangeOfWeeks.length * 7);
}


/*Task-3.8 - Prepare each custom cell with/without appropriate date value, bg and text color.
 Also, Queue/Dequeue up the cell using identifier.*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCDatePickerDateCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:calendarCellID forIndexPath:indexPath];

    NSDate *firstOfMonth = [self firstDateOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];

    NSDateComponents *cellDateComponents = [self.calendar components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:NSMonthCalendarUnit fromDate:firstOfMonth];

    /* Task-6 : Date marking state maintenance logic. */
    BOOL isFirstSelectedDate = NO;

    /* Task- 7.7 : Last Date marking state maintenance logic. */
    BOOL isLastSelectedDate = NO;

    /* Task- 7.9 : Highlighted/ranged Date marking state maintenance logic. */
    BOOL isHighLightedDate = NO;

    /* Task-11 : Set current date with bold letter. */
    BOOL isTodayDate = NO;

    BOOL nonSelectable = NO;

    /*Task-6.1: Verify and mark start date on tap. */
    if (cellDateComponents.month == firstOfMonthsComponents.month) {
        isFirstSelectedDate = ([self isFirstSelectedDate:cellDate] && (indexPath.section == [self sectionForDate:cellDate]));

        /*Task-7.8: Verify and mark last date on tap. */
        isLastSelectedDate = ([self isLastSelectedDate:cellDate] && (indexPath.section == [self sectionForDate:cellDate]));

        // if cell is between start and end dates then highlight
        isHighLightedDate = [self isDate:cellDate betweenStartDate:self.firstSelectedDate endDate:self.lastSelectedDate];

        /* Task-11.1 :  Verify and mark current date */
        isTodayDate = [self isTodayDate:cellDate];
        
        // disbale cell if date is outside of bounds or max nights
        BOOL cellDateIsBeforeLowerBound = (self.lowerBoundDate && ([cellDate compare:self.lowerBoundDate] == NSOrderedAscending));
        BOOL cellDateIsAfterUpperBound = (self.upperBoundDate && ([cellDate compare:self.upperBoundDate] == NSOrderedDescending));
        
        // calculate the number of days between first selected date and current cell date
        NSUInteger numberOfDays = 0;
        if (self.firstSelectedDate && cellDate) {
             numberOfDays = [self countDaysFromDate:self.firstSelectedDate toDate:cellDate];
        }
        BOOL cellDateGreaterThanMaxNumberOfNightsFromStartDate = self.firstSelectedDate && self.maxNumberOfNights > 0 && numberOfDays > self.maxNumberOfNights && [cellDate compare:self.firstSelectedDate] == NSOrderedDescending;
        
        if (cellDateIsAfterUpperBound || cellDateIsBeforeLowerBound || (!self.lastSelectedDate && cellDateGreaterThanMaxNumberOfNightsFromStartDate)) {
            nonSelectable = TRUE;
        }
        
        [cell setDate:cellDate calendar:self.calendar];
    } else {
        [cell setDate:nil calendar:nil];
        nonSelectable = TRUE;
    }

    /* Logic for maintaining state for selected, highlighted and today's date */
    if (isFirstSelectedDate) {
        [cell setFirstDateSelected];
    } else if (isLastSelectedDate) {
        [cell setLastDateSelected];
    } else if (isHighLightedDate) {
        [cell highlightDate];
    } else if (nonSelectable) {
        [cell nonSelectableDate];
    } else {
        [cell selectableDate];
    }
    
    cell.userInteractionEnabled = !nonSelectable;
    
    return cell;
}


/*Task-4.8: Override a delegate method of Cell Reusable View. This will be called on
 addition of the section. It will replace the month text into the header cell.*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        LCDatePickerHeaderCell *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:calenderHeaderCellID
                                                                                            forIndexPath:indexPath];

        headerView.currentMonthLb.text = [self.headerDateFormatter stringFromDate:[self firstDateOfMonthForSection:indexPath.section]].uppercaseString;

        headerView.layer.shouldRasterize = YES;
        headerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        return headerView;
    }
    return nil;
}


/* Task-6.6 : Delegate method to determine the selection based on valid date on a given index. */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstDateOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];

    NSDateComponents *cellDateComponents = [self.calendar components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:NSMonthCalendarUnit fromDate:firstOfMonth];

    return (cellDateComponents.month == firstOfMonthsComponents.month);
}


/* Task-6.5 : Delegate method for selecting and highlighting a first date and last date */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.firstSelectedDate == nil) {
        // first date selected
        self.firstSelectedDate = [self dateForCellAtIndexPath:indexPath];
    } else if (self.lastSelectedDate == nil) {
        // second date selected
        
        self.lastSelectedDate = [self dateForCellAtIndexPath:indexPath];

        // if date selected is same as first then clear any previous selection and return
        if ([self.lastSelectedDate compare:self.firstSelectedDate] == NSOrderedSame) {
            self.lastSelectedDate = nil;
            [self updateUIState];
            return;
        }
        
        // if date selected is earlier than previous selected date set this date
        // as the a new first selected date and clear any previous selection
        if ([self.lastSelectedDate compare:self.firstSelectedDate] == NSOrderedAscending) {
            self.firstSelectedDate = [self dateForCellAtIndexPath:indexPath];
            self.lastSelectedDate = nil;
        } else {
            
            // date selected is after the previous selected date  (GOOD!)

            // inform  delegate that user has made a valid selection
            [self.delegate datePickerViewController:self userPickedStartDate:self.firstSelectedDate endDate:self.lastSelectedDate];
        }
    } else {

        // first and last dates where already selected and user
        // selected another date so clear last selected date and set new
        // first selected date
        self.lastSelectedDate = nil;
        self.firstSelectedDate = [self dateForCellAtIndexPath:indexPath];
    }
    
    [self.collectionView reloadData];
    [self updateUIState];
}


# pragma mark -
# pragma mark UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
//    NSInteger numberOfColumns = 7;
//    CGFloat itemWidth = (self.collectionView.bounds.size.width / numberOfColumns) - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * (numberOfColumns -2)));
//    return CGSizeMake(itemWidth, itemWidth);
//}


# pragma mark -
# pragma mark UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y < 0.0f && ! self.lowerBoundDate) {
//        [self appendPastDates];
//    }
//
//    if ((scrollView.contentOffset.y > (scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds))) && ! self.upperBoundDate) {
//        [self appendFutureDates];
//    }
//}


/* Task-12.1 : Delegate method to pop out "Today" button while scrolling starts. */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self updateTodayButton];
    [self updateSelectedDatesButton];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updateTodayButton];
    [self updateSelectedDatesButton];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateTodayButton];
    [self updateSelectedDatesButton];
}

@end

#pragma clang diagnostic pop
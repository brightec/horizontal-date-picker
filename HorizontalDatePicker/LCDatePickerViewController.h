//
//  LCDatePickerViewController.h
//
//  Created by m dani on 05/05/2014.
//  Modifications and refactoring by Cameron Cooke on 28/05/2014
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LCDatePickerViewController;

@protocol LCDatePickerViewControllerDelegate <NSObject>
- (void)datePickerViewController:(LCDatePickerViewController *)datePickerViewController userPickedStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)datePickerViewControllerDoneButtonWasTouched:(LCDatePickerViewController *)datePickerViewController userPickedStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)datePickerViewControllerCancelButtonWasTouched:(LCDatePickerViewController *)datePickerViewController;
@end


@interface LCDatePickerViewController : UIViewController
@property (nonatomic, weak) id<LCDatePickerViewControllerDelegate> delegate;
@property (nonatomic) NSDate *lowerBoundDate;
@property (nonatomic) NSDate *upperBoundDate;
@property (nonatomic) NSUInteger maxNumberOfNights;

- (id)initWithSelectedStartDate:(NSDate *)startDate endDate:(NSDate *)endDate delegate:(id<LCDatePickerViewControllerDelegate>)delegate;
@end

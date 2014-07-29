//
//  LCDatePickerDateCell.h
//
//  Created by m dani on 05/05/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCDatePickerDateCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isToday;

- (void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar;
-(void)setFirstDateSelected;
-(void)setLastDateSelected;
-(void)highlightDate;
-(void)deselectDate;
-(void)deHighlightDate;
-(void)nonSelectableDate;
-(void)selectableDate;
@end

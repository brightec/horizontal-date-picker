//
//  UIWindow+AutoLayoutDebug.h
//  Lowcost
//
//  Created by Cameron Cooke on 28/10/2013.
//  Copyright (c) 2013 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (AutoLayoutDebug)
+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;
@end


@interface UIView (AutoLayoutDebug)
- (NSString *)_autolayoutTrace;
- (NSString *)recursiveDescription;
@end
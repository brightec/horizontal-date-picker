//
//  UIView+autolayout.h
//
//  Created by Cameron Cooke on 16/01/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, BTPinnedEdge) {
    BTPinnedEdgeAll      = 0,
    BTPinnedEdgeLeading  = 1 << 1,
    BTPinnedEdgeTrailing = 1 << 2,
    BTPinnedEdgeTop      = 1 << 3,
    BTPinnedEdgeBottom   = 1 << 4
};


@interface UIView (autolayout)

// auto layout debugging
- (void)setNameTag:(NSString *)nameTag;
- (NSString *)nameTag;

// pins view to all edges of the receiver
- (void)pinView:(UIView *)view;

// pins view to edges of the receiver view as defined in edges bitmask
- (void)pinView:(UIView *)view toEdges:(BTPinnedEdge)edges;
- (void)pinView:(UIView *)view toEdges:(BTPinnedEdge)edges margin:(CGFloat)margin;

// pin viewA to viewB
- (NSLayoutConstraint *)pinView:(UIView *)viewA withAttribute:(NSLayoutAttribute)attribute toView:(UIView *)viewB;
- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing;
- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority;

// pin views height/width
- (NSLayoutConstraint *)pinWidth:(CGFloat)width;
- (NSLayoutConstraint *)pinHeight:(CGFloat)height;
- (void)pinWidth:(CGFloat)width height:(CGFloat)height;

- (void)pinToCenterWithView:(UIView *)view;
- (void)pinToVerticalCenterWithView:(UIView *)view;
- (void)pinToHorizontalCenterWithView:(UIView *)view;
@end

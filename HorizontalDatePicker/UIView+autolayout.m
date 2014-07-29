//
//  UIView+autolayout.m
//
//  Created by Cameron Cooke on 16/01/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "UIView+autolayout.h"
#import <objc/runtime.h>


@implementation UIView (autolayout)

# pragma mark -
# pragma mark Debugging

static const char tag;
- (void)setNameTag:(NSString *)nameTag
{
    objc_setAssociatedObject(self, &tag, nameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSString *)nameTag
{
    return objc_getAssociatedObject(self, &tag);
}


# pragma mark -
# pragma mark Pinning

- (void)pinView:(UIView *)view
{
    [self pinView:view toEdges:BTPinnedEdgeAll];
}


- (void)pinView:(UIView *)view toEdges:(BTPinnedEdge)edges
{
    return [self pinView:view toEdges:edges margin:0];
}


- (void)pinView:(UIView *)view toEdges:(BTPinnedEdge)edges margin:(CGFloat)margin
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    NSMutableArray *constraints = [@[] mutableCopy];
    
    // leading
    if (edges == BTPinnedEdgeAll || edges & BTPinnedEdgeLeading) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0f
                                                             constant:margin]];
    }
    
    // trailing
    if (edges == BTPinnedEdgeAll || edges & BTPinnedEdgeTrailing) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0f
                                                             constant:-margin]];
    }
    
    // top
    if (edges == BTPinnedEdgeAll || edges & BTPinnedEdgeTop) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:margin]];
    }
        
    // top
    if (edges == BTPinnedEdgeAll || edges & BTPinnedEdgeBottom) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:-margin]];
    }
    
    [self addConstraints:constraints];
}


- (NSLayoutConstraint *)pinView:(UIView *)viewA withAttribute:(NSLayoutAttribute)attribute toView:(UIView *)viewB
{
    return [self pinView:viewA toEdge:attribute ofView:viewB edge:attribute withSpacing:0 priority:UILayoutPriorityRequired];
}


- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing
{
    return [self pinView:viewA toEdge:firstAttribute ofView:viewB edge:secondAttribute withSpacing:spacing priority:UILayoutPriorityRequired];
}


- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority
{
    UIView *ancestor = viewA;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = viewB;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewA
                                                                  attribute:firstAttribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewB
                                                                  attribute:secondAttribute
                                                                 multiplier:1.0f
                                                                   constant:spacing];
    constraint.priority = priority;
    [self addConstraint:constraint];
    
    return constraint;
}


- (NSLayoutConstraint *)pinWidth:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:width];
    [self addConstraint:constraint];
    return constraint;
}


- (NSLayoutConstraint *)pinHeight:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    [self addConstraint:constraint];
    return constraint;
}


- (void)pinWidth:(CGFloat)width height:(CGFloat)height
{
    [self pinWidth:width];
    [self pinHeight:height];
}


- (void)pinToCenterWithView:(UIView *)view
{
    [self pinToHorizontalCenterWithView:view];
    [self pinToVerticalCenterWithView:view];
}


- (void)pinToVerticalCenterWithView:(UIView *)view
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0]];
}


- (void)pinToHorizontalCenterWithView:(UIView *)view
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0]];
}


@end


// NSLayoutConstraint Category

//@interface NSLayoutConstraint (autolayout)
//#ifdef DEBUG
//- (NSString *)asciiArtDescription;
//#endif
//@end
//
//#pragma clang diagnostic ignored "-Wincomplete-implementation"
//@implementation NSLayoutConstraint (autolayout)
//
//#ifdef DEBUG
//- (NSString *)description
//{
//    NSString *description = super.description;
//    NSString *asciiArtDescription = self.asciiArtDescription;
//    
//    NSString *firstItemDesc;
//    if ((firstItemDesc = [self.firstItem nameTag]) == nil) {
//        firstItemDesc = [NSString stringWithFormat:@"%p", self.firstItem];
//    }
//    
//    NSString *secondItemDesc;
//    if ((secondItemDesc = [self.secondItem nameTag]) == nil) {
//        secondItemDesc = [NSString stringWithFormat:@"%p", self.secondItem];
//    }
//    
//    if (asciiArtDescription) {
//        return [description stringByAppendingFormat:@" %@ (%@, %@)", asciiArtDescription, firstItemDesc, secondItemDesc];
//    } else {
//        return [description stringByAppendingFormat:@" (%@, %@)", firstItemDesc, secondItemDesc];
//    }
//}
//#endif
//
//@end

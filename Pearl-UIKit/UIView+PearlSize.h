//
// Created by Maarten Billemont on 2017-11-17.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(PearlSize)

/** A minimum bound for the view's intrinsic size and fitting size. */
@property(nonatomic) IBInspectable CGSize minimumIntrinsicSize;

/** The alignment rectangle in the superview's bounds. */
@property(nonatomic, readonly) CGRect alignmentRect;

/** The distance between the view's alignment rectangle and its superview's bounds.
 * eg. right = distance between the right side of the frame and the right bound. */
@property(nonatomic, readonly) UIEdgeInsets autoresizingMargins;

/** The distance between the view's alignment rectangle and its superview's bounds.
 * eg. right = distance between the right side of the frame and the right bound. */
@property(nonatomic, readonly) UIEdgeInsets alignmentMargins;

/** The distance between the view's alignment rectangle and its superview's opposite bounds.
 * eg. right = distance between the right side of the frame and the left bound.
 *
 * Ideal for determining the bound margins to use for other views that relate to this view's frame. */
@property(nonatomic, readonly) UIEdgeInsets alignmentAnchors;

/** Create a view that wraps another view inside its margins. */
+ (UIView *)viewContaining:(UIView *)subview withLayoutMargins:(UIEdgeInsets)margins;

/** Set default alignment rectangle insets.  Can be overridden by subviews that implement -alignmentRectInsets or -alignmentRectForFrame: */
- (void)setAlignmentRectInsets:(UIEdgeInsets)alignmentRectInsets;
/** Adjust the alignment rectangle outwardly.  Equal to -setAlignmentRectInsets: with all values the opposite of their outset values. */
- (void)setAlignmentRectOutsets:(UIEdgeInsets)alignmentRectOutsets;

@end

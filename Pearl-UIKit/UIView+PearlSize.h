//
// Created by Maarten Billemont on 2017-11-17.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(PearlSize)

/** A minimum bound for the view's intrinsic size and fitting size. */
@property(nonatomic) IBInspectable CGSize minimumIntrinsicSize;

/** Create a view that wraps another view inside its margins. */
+ (UIView *)viewContaining:(UIView *)subview withLayoutMargins:(UIEdgeInsets)margins;

/** Set default alignment rectangle insets.  Can be overridden by subviews that implement -alignmentRectInsets or -alignmentRectForFrame: */
- (void)setAlignmentRectInsets:(UIEdgeInsets)alignmentRectInsets;
/** Adjust the alignment rectangle outwardly.  Equal to -setAlignmentRectInsets: with all values the opposite of their outset values. */
- (void)setAlignmentRectOutsets:(UIEdgeInsets)alignmentRectOutsets;

@end

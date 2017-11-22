//
// Created by Maarten Billemont on 2017-11-17.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "UIView+PearlSize.h"

static CGSize PearlNoIntrinsicMetric;

@implementation UIView(PearlSize)

+ (void)load {
    PearlNoIntrinsicMetric = CGSizeMake( UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric );
}

+ (UIView *)viewContaining:(UIView *)subview withLayoutMargins:(UIEdgeInsets)margins {
    UIView *container = [UIView new];
    [container addSubview:subview];
    [container setLayoutMargins:margins];
    [container setFrame:CGRectMake( 0, 0,
        margins.left + subview.frame.size.width + margins.right, margins.top + subview.frame.size.height + margins.bottom )];
    CGRectSetOrigin( subview.frame, CGPointMake( margins.left, margins.top ) );
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return container;
}

- (CGSize)minimumIntrinsicSize {
    NSValue *minimumIntrinsicSize = objc_getAssociatedObject( self, @selector( minimumIntrinsicSize ) );
    return minimumIntrinsicSize? [minimumIntrinsicSize CGSizeValue]: PearlNoIntrinsicMetric;
}

- (void)setMinimumIntrinsicSize:(CGSize)minimumIntrinsicSize {
    PearlSwizzle( [self class], @selector( intrinsicContentSize ), @selector( _pearl_minimumSize_intrinsicContentSize ) );
    PearlSwizzle( [self class], @selector( sizeThatFits: ), @selector( _pearl_minimumSize_sizeThatFits: ) );

    objc_setAssociatedObject( self, @selector( minimumIntrinsicSize ),
        [NSValue valueWithCGSize:minimumIntrinsicSize], OBJC_ASSOCIATION_RETAIN );
}

- (CGSize)_pearl_minimumSize_intrinsicContentSize {
    CGSize intrinsicContentSize = [self intrinsicContentSize];

//    UIEdgeInsets paddingInsets = self.paddingInsets;
//    intrinsicContentSize.width -= (paddingInsets.left + paddingInsets.right);
//    intrinsicContentSize.height -= (paddingInsets.top + paddingInsets.bottom);

    CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
    if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
        intrinsicContentSize.width = MAX( intrinsicContentSize.width, minimumIntrinsicSize.width );
    if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
        intrinsicContentSize.height = MAX( intrinsicContentSize.height, minimumIntrinsicSize.height );

    return intrinsicContentSize;
}

- (CGSize)_pearl_minimumSize_sizeThatFits:(CGSize)fitSize {
    CGSize fittingSize = [self sizeThatFits:fitSize];

//    UIEdgeInsets paddingInsets = self.paddingInsets;
//    fittingSize.width -= (paddingInsets.left + paddingInsets.right);
//    fittingSize.height -= (paddingInsets.top + paddingInsets.bottom);

    CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
    if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
        fittingSize.width = MAX( fittingSize.width, minimumIntrinsicSize.width );
    if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
        fittingSize.height = MAX( fittingSize.height, minimumIntrinsicSize.height );

    return fittingSize;
}

- (UIEdgeInsets)_pearl_minimumSize_alignmentRectInsets {
    return [objc_getAssociatedObject( self, @selector( setAlignmentRectInsets: ) ) UIEdgeInsetsValue];
}

- (void)setAlignmentRectInsets:(UIEdgeInsets)alignmentRectInsets {
    PearlSwizzle( [self class], @selector( alignmentRectInsets ), @selector( _pearl_minimumSize_alignmentRectInsets ) );

    objc_setAssociatedObject( self, @selector( setAlignmentRectInsets: ),
        [NSValue valueWithUIEdgeInsets:alignmentRectInsets], OBJC_ASSOCIATION_RETAIN );
}

- (void)setAlignmentRectOutsets:(UIEdgeInsets)alignmentRectOutsets {
    [self setAlignmentRectInsets:UIEdgeInsetsMake(
        -alignmentRectOutsets.top, -alignmentRectOutsets.left,
        -alignmentRectOutsets.bottom, -alignmentRectOutsets.right )];
}

@end

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
    PearlSwizzleTR( [self class], @selector( intrinsicContentSize ), ^CGSize(UIView *self), {
        CGSize intrinsicContentSize = [self intrinsicContentSize];

        CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
        if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
            intrinsicContentSize.width = MAX( intrinsicContentSize.width, minimumIntrinsicSize.width );
        if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
            intrinsicContentSize.height = MAX( intrinsicContentSize.height, minimumIntrinsicSize.height );

        return intrinsicContentSize;
    }, CGSizeValue );
    PearlSwizzleTR( [self class], @selector( sizeThatFits: ), ^CGSize(UIView *self, CGSize fitSize), {
        CGSize fittingSize = [self sizeThatFits:fitSize];

        CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
        if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
            fittingSize.width = MAX( fittingSize.width, minimumIntrinsicSize.width );
        if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
            fittingSize.height = MAX( fittingSize.height, minimumIntrinsicSize.height );

        return fittingSize;
    }, CGSizeValue );

    objc_setAssociatedObject( self, @selector( minimumIntrinsicSize ),
        [NSValue valueWithCGSize:minimumIntrinsicSize], OBJC_ASSOCIATION_RETAIN );
}

- (void)setAlignmentRectInsets:(UIEdgeInsets)alignmentRectInsets {
    PearlSwizzleTR( [self class], @selector( alignmentRectInsets ), ^UIEdgeInsets(UIView *self), {
        return [objc_getAssociatedObject( self, @selector( setAlignmentRectInsets: ) ) UIEdgeInsetsValue];
    }, UIEdgeInsetsValue );

    objc_setAssociatedObject( self, @selector( setAlignmentRectInsets: ),
        [NSValue valueWithUIEdgeInsets:alignmentRectInsets], OBJC_ASSOCIATION_RETAIN );
}

- (void)setAlignmentRectOutsets:(UIEdgeInsets)alignmentRectOutsets {
    [self setAlignmentRectInsets:UIEdgeInsetsMake(
        -alignmentRectOutsets.top, -alignmentRectOutsets.left,
        -alignmentRectOutsets.bottom, -alignmentRectOutsets.right )];
}

- (CGRect)alignmentRect {
    return [self alignmentRectForFrame:self.frame];
}

- (UIEdgeInsets)alignmentMargins {
    return UIEdgeInsetsFromCGRectInCGSize( self.alignmentRect, self.superview.bounds.size );
}

- (UIEdgeInsets)alignmentPolarMargins {
    CGRect alignmentRect = self.alignmentRect;
    return UIEdgeInsetsMake(
        self.superview.bounds.size.height - (alignmentRect.origin.y + alignmentRect.size.height),
        self.superview.bounds.size.width - (alignmentRect.origin.x + alignmentRect.size.width),
        alignmentRect.origin.y + alignmentRect.size.height,
        alignmentRect.origin.x + alignmentRect.size.width );
}

@end

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

+ (UIView *)viewContaining:(UIView *)subview {

    return [self viewContaining:subview init:nil];
}

+ (UIView *)viewContaining:(UIView *)subview withLayoutMargins:(UIEdgeInsets)margins {
    return [self viewContaining:subview init:^(UIView *container) {
        [container setLayoutMargins:margins];
    }];
}

+ (UIView *)viewContaining:(UIView *)subview init:(void(^)(UIView *container))initBlock {
    UIView *container = [UIView new];
    [container addSubview:subview];
    if (initBlock)
        initBlock(container);
    UIEdgeInsets margins = container.layoutMargins;
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

- (void)setMinimumIntrinsicSize:(CGSize)aMinimumIntrinsicSize {
    objc_setAssociatedObject( self, @selector( minimumIntrinsicSize ),
        [NSValue valueWithCGSize:aMinimumIntrinsicSize], OBJC_ASSOCIATION_RETAIN );

    PearlSwizzle( UIView, @selector( intrinsicContentSize ), CGSize, {
        CGSize intrinsicContentSize = orig( self, sel );

        CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
        if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
            intrinsicContentSize.width = MAX( intrinsicContentSize.width, minimumIntrinsicSize.width );
        if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
            intrinsicContentSize.height = MAX( intrinsicContentSize.height, minimumIntrinsicSize.height );

        return intrinsicContentSize;
    } );
    PearlSwizzle( UIView, @selector( sizeThatFits: ), CGSize, {
        CGSize fittingSize = orig( self, sel, fitSize );

        CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
        if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
            fittingSize.width = MAX( fittingSize.width, minimumIntrinsicSize.width );
        if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
            fittingSize.height = MAX( fittingSize.height, minimumIntrinsicSize.height );

        return fittingSize;
    }, CGSize fitSize );
}

- (void)setAlignmentRectInsets:(UIEdgeInsets)alignmentRectInsets {
    objc_setAssociatedObject( self, @selector( alignmentRectInsets ),
        [NSValue valueWithUIEdgeInsets:alignmentRectInsets], OBJC_ASSOCIATION_RETAIN );
}

- (UIEdgeInsets)alignmentRectInsets {
    return [objc_getAssociatedObject( self, @selector( alignmentRectInsets ) ) UIEdgeInsetsValue];
}

- (void)setAlignmentRectOutsets:(UIEdgeInsets)alignmentRectOutsets {
    [self setAlignmentRectInsets:UIEdgeInsetsMake(
        -alignmentRectOutsets.top, -alignmentRectOutsets.left,
        -alignmentRectOutsets.bottom, -alignmentRectOutsets.right )];
}

- (CGRect)alignmentRect {
    return [self alignmentRectForFrame:self.frame];
}

- (UIEdgeInsets)autoresizingMargins {
    if (!self.superview)
        return UIEdgeInsetsZero;

    return UIEdgeInsetsFromCGRectInCGSize( self.frame, self.superview.bounds.size );
}

- (UIEdgeInsets)alignmentMargins {
    if (!self.superview)
        return UIEdgeInsetsZero;

    return UIEdgeInsetsFromCGRectInCGRect(
        [self alignmentRectForFrame:self.frame],
        [self.superview alignmentRectForFrame:self.superview.bounds] );
}

- (UIEdgeInsets)alignmentAnchors {
    CGRect alignmentRect = self.alignmentRect;
    return UIEdgeInsetsMake(
        self.superview.bounds.size.height - alignmentRect.origin.y,
        self.superview.bounds.size.width - alignmentRect.origin.x,
        alignmentRect.origin.y + alignmentRect.size.height,
        alignmentRect.origin.x + alignmentRect.size.width );
}

@end

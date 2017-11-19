//
// Created by Maarten Billemont on 2017-11-17.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "UIView+PearlMinimumSize.h"

static CGSize PearlNoIntrinsicMetric;

@implementation UIView(PearlMinimumSize)

+ (void)load {
    PearlNoIntrinsicMetric = CGSizeMake( UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric );
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
    CGSize intrinsicContentSize = [self intrinsicContentSize], minimumIntrinsicSize = self.minimumIntrinsicSize;
    if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
        intrinsicContentSize.width = MAX( intrinsicContentSize.width, minimumIntrinsicSize.width );
    if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
        intrinsicContentSize.height = MAX( intrinsicContentSize.height, minimumIntrinsicSize.height );
  
    return intrinsicContentSize;
}

- (CGSize)_pearl_minimumSize_sizeThatFits:(CGSize)fitSize {
    fitSize = [self sizeThatFits:fitSize];
  
    CGSize minimumIntrinsicSize = self.minimumIntrinsicSize;
    if (minimumIntrinsicSize.width != UIViewNoIntrinsicMetric)
        fitSize.width = MAX( fitSize.width, minimumIntrinsicSize.width );
    if (minimumIntrinsicSize.height != UIViewNoIntrinsicMetric)
        fitSize.height = MAX( fitSize.height, minimumIntrinsicSize.height );
  
    return fitSize;
}

@end

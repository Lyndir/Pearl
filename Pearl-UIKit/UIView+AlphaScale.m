//
// Created by Maarten Billemont on 2014-07-18.
//

#import "UIView+AlphaScale.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "InfiniteRecursion"

@interface UIView(AlphaScale_Private)

@property(nonatomic) BOOL alphaScaleApplied;

@end

@implementation UIView(AlphaScale)

+ (void)load {

    PearlSwizzle( self, @selector( setAlpha: ), @selector( alphaMod_setAlpha: ) );
}

- (void)setNoAlphaScale:(BOOL)noAlphaScale {

    objc_setAssociatedObject( self, @selector( noAlphaScale ), @(noAlphaScale), OBJC_ASSOCIATION_RETAIN );
    [self alphaMod_updateAlpha];
}

- (BOOL)noAlphaScale {

    NSNumber *noAlphaScale = objc_getAssociatedObject( self, @selector( noAlphaScale ) );
    if (!noAlphaScale)
        if ([self isKindOfClass:[UITabBar class]] || [self isKindOfClass:[UIToolbar class]]
            || [self isKindOfClass:[UINavigationBar class]] || [self isKindOfClass:[UISearchBar class]])
            return YES;

    return [noAlphaScale boolValue];
}

/**
* @return The alpha scale that is currently applied to the view's font.
*/
- (BOOL)alphaScaleApplied {

    return [objc_getAssociatedObject( self, @selector( alphaScaleApplied ) ) boolValue];
}

- (void)setAlphaScaleApplied:(BOOL)alphaScaleApplied {

    objc_setAssociatedObject( self, @selector( alphaScaleApplied ), @(alphaScaleApplied), OBJC_ASSOCIATION_RETAIN );
}

- (void)alphaMod_updateAlpha {

    PearlAddNotificationObserver( UIAccessibilityReduceTransparencyStatusDidChangeNotification, nil, [NSOperationQueue mainQueue],
            ^(id self, NSNotification *note) {
                [self alphaMod_updateAlpha];
            });

    BOOL alphaScaleApplied = self.alphaScaleApplied;
    BOOL alphaScaleRequested = !self.noAlphaScale && UIAccessibilityIsReduceTransparencyEnabled();
    if (alphaScaleRequested == alphaScaleApplied)
        return;
    self.alphaScaleApplied = alphaScaleRequested;

    CGFloat originalAlpha = self.alpha;
    [self alphaMod_setAlpha:self.alphaScaleApplied? (CGFloat)sqrt( originalAlpha ): originalAlpha];
}

- (void)alphaMod_setAlpha:(CGFloat)newAlpha {

    [self alphaMod_setAlpha:newAlpha];
    [self setAlphaScaleApplied:NO];
    [self alphaMod_updateAlpha];
}

@end

#pragma clang diagnostic pop

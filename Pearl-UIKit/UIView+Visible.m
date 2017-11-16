//
// Created by Maarten Billemont on 2014-07-18.
//

#import "UIView+Visible.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "InfiniteRecursion"

@implementation UIView(Visible)

+ (void)load {
    PearlSwizzle( self, @selector( setAlpha: ), @selector( visible_setAlpha: ) );
}

- (void)setVisible:(BOOL)visible {

    if (!visible && self.visible && !self.visible_originalAlpha)
        [self visible_setOriginalAlpha:self.alpha];

    objc_setAssociatedObject( self, @selector( visible ), @(visible), OBJC_ASSOCIATION_RETAIN );
    [self visible_updateAlpha];
}

- (BOOL)visible {

    return [objc_getAssociatedObject( self, @selector( visible ) )?: @YES boolValue];
}

- (void)visible_setOriginalAlpha:(CGFloat)alpha {
    objc_setAssociatedObject( self, @selector( visible_updateAlpha ), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSNumber *)visible_originalAlpha {
    return objc_getAssociatedObject( self, @selector( visible_updateAlpha ) );
}

- (void)visible_updateAlpha {

    if (self.visible) {
        NSNumber *originalAlpha = self.visible_originalAlpha;
        if (originalAlpha)
            [self visible_setAlpha:(CGFloat)[originalAlpha doubleValue]];
    } else
        [self visible_setAlpha:0];
}

- (void)visible_setAlpha:(CGFloat)newAlpha {

    [self visible_setOriginalAlpha:newAlpha];
    [self visible_updateAlpha];
}

@end

#pragma clang diagnostic pop

//
// Created by Maarten Billemont on 2014-07-18.
//

#import "UIView+Visible.h"

@implementation UIView(Visible)

- (BOOL)visible {
    return [objc_getAssociatedObject( self, @selector( visible ) )?: @YES boolValue];
}

- (void)setVisible:(BOOL)visible {
    if (self.visible == visible)
        return;

    PearlSwizzle( [self class], @selector( setAlpha: ), @selector( _pearl_visible_setAlpha: ) );
    objc_setAssociatedObject( self, @selector( visible ), @(visible), OBJC_ASSOCIATION_RETAIN );
    
    if (!visible)
        [self setAlpha:self.alpha];
    else
        [self setAlpha:self._pearl_visible_desiredAlpha];
}

- (CGFloat)_pearl_visible_desiredAlpha {
    return (CGFloat)[objc_getAssociatedObject( self, @selector( _pearl_visible_desiredAlpha ) ) doubleValue];
}

- (void)_pearl_visible_setDesiredAlpha:(CGFloat)alpha {
    objc_setAssociatedObject( self, @selector( _pearl_visible_desiredAlpha ), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)_pearl_visible_setAlpha:(CGFloat)desiredAlpha {
    [self _pearl_visible_setDesiredAlpha:desiredAlpha];
    
    if (self.visible)
        [self setAlpha:desiredAlpha];
    else
        [self setAlpha:0];
}

@end

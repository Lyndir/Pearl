//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+FontScale.h"

@interface UIApplication(FontScale)

- (CGFloat)preferredContentSizeCategoryFontScale;

@end

@implementation UIView(FontScale)

+ (void)load {

    for (Class type in @[ [UILabel class], [UITextField class], [UITextView class] ]) {
        PearlSwizzle( type, @selector( updateConstraints ), ^(id self), {
            [self _pearl_fontMod_updateFont];
            [self updateConstraints];
        } );
        PearlSwizzle( type, @selector( setFont: ), ^(UIView *self, UIFont *originalFont), {
            if (NSNullToNil( [originalFont.fontDescriptor objectForKey:@"NSCTFontUIUsageAttribute"] ) ||
                ([(id)self respondsToSelector:@selector( adjustsFontForContentSizeCategory )] && [(id)self adjustsFontForContentSizeCategory]))
                [(UILabel *)self setFont:originalFont];

            else {
                CGFloat appliedFontScale = self.appliedFontScale = self.noFontScale? 1: UIApp.preferredContentSizeCategoryFontScale;
                [(UILabel *)self setFont:[originalFont fontWithSize:originalFont.pointSize * appliedFontScale]];
            }
        } );
    }
}

- (BOOL)noFontScale {

    return [objc_getAssociatedObject( self, @selector( noFontScale ) ) boolValue];
}

- (void)setNoFontScale:(BOOL)noFontScale {

    objc_setAssociatedObject( self, @selector( noFontScale ), @(noFontScale), OBJC_ASSOCIATION_RETAIN );
    [self _pearl_fontMod_updateFont];
}

/**
* @return The font scale that is currently applied to the view's font.
*/
- (CGFloat)appliedFontScale {

    return [objc_getAssociatedObject( self, @selector( appliedFontScale ) )?: @(1.0f) floatValue];
}

- (void)setAppliedFontScale:(CGFloat)appliedFontScale {

    objc_setAssociatedObject( self, @selector( appliedFontScale ), appliedFontScale == 0? nil: @(appliedFontScale), OBJC_ASSOCIATION_RETAIN );
}

- (void)_pearl_fontMod_updateFont {

    PearlAddNotificationObserver( UIContentSizeCategoryDidChangeNotification, nil, [NSOperationQueue mainQueue],
            ^(id self, NSNotification *note) {
                [self _pearl_fontMod_updateFont];
            } );

    UIFont *appliedFont = [(UILabel *)self font];
    [(UILabel *)self setFont:[appliedFont fontWithSize:appliedFont.pointSize / self.appliedFontScale]];
    if (![appliedFont isEqual:[(UILabel *)self font]]) {
        [self setNeedsUpdateConstraints];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.superview isKindOfClass:[UIControl class]])
                  [self.superview setNeedsLayout];
        }];
    }
}

@end

@implementation UIApplication (FontScale)

- (CGFloat)preferredContentSizeCategoryFontScale {
    // Based on UIFontTextStyleBody

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge])
        return 21 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraExtraLarge])
        return 20 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraLarge])
        return 19 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityLarge])
        return 19 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityMedium])
        return 18 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraExtraExtraLarge])
        return 18 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraExtraLarge])
        return 17 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraLarge])
        return 16 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryLarge])
        return 15 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryMedium])
        return 14 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategorySmall])
        return 13 / 15.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraSmall])
        return 12 / 15.f;

    return 1.0f;
}

@end

//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+FontScale.h"

@implementation UIView(FontScale)

+ (void)load {

    for (Class type in @[ [UILabel class], [UITextField class], [UITextView class] ]) {
        PearlSwizzle( type, @selector( updateConstraints ), ^, (id self), {
            [self _pearl_fontMod_updateFont];
            [self updateConstraints];
        } );
        PearlSwizzle( type, @selector( setFont: ), ^, (UIView *self, UIFont *originalFont), {
            UIFont *newFont = originalFont;

            if (!NSNullToNil( [originalFont.fontDescriptor objectForKey:@"NSCTFontUIUsageAttribute"] ) &&
                !([(id)self respondsToSelector:@selector( adjustsFontForContentSizeCategory )] &&
                    [(id)self adjustsFontForContentSizeCategory])) {
                CGFloat appliedFontScale = self.appliedFontScale = self.noFontScale? 1: UIApp.preferredContentSizeCategoryFontScale;
                newFont = [originalFont fontWithSize:originalFont.pointSize * appliedFontScale];
            }

            if (UIAccessibilityIsBoldTextEnabled() && !self.noFontBolding && !self.originalFont) {
                UIFont *originalFont = self.originalFont = newFont;
                UIFontDescriptor *boldFontDescriptor = [originalFont.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
                newFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0]?: newFont;
            }
            if ((!UIAccessibilityIsBoldTextEnabled() || self.noFontBolding) && self.originalFont) {
                newFont = newFont? [self.originalFont fontWithSize:newFont.pointSize]: self.originalFont;
                self.originalFont = nil;
            }

          [(UILabel *)self setFont:newFont];
        } );
    }
}

- (BOOL)noFontScale {

    return [objc_getAssociatedObject( self, @selector( noFontScale ) ) boolValue] || self.superview.noFontScale;
}

- (void)setNoFontScale:(BOOL)noFontScale {

    objc_setAssociatedObject( self, @selector( noFontScale ), @(noFontScale), OBJC_ASSOCIATION_RETAIN );

    [self enumerateViews:^(UIView *subview, BOOL *stop, BOOL *recurse) {
        [self setNeedsUpdateConstraints];
    }            recurse:YES];
}

- (BOOL)noFontBolding {

    return [objc_getAssociatedObject( self, @selector( noFontBolding ) ) boolValue] || self.superview.noFontBolding;
}

- (void)setNoFontBolding:(BOOL)noFontBolding {

    objc_setAssociatedObject( self, @selector( noFontBolding ), @(noFontBolding), OBJC_ASSOCIATION_RETAIN );

    [self enumerateViews:^(UIView *subview, BOOL *stop, BOOL *recurse) {
        [self setNeedsUpdateConstraints];
    }            recurse:YES];
}

- (UIFont *)originalFont {

  return objc_getAssociatedObject( self, @selector( originalFont ) );
}

- (void)setOriginalFont:(UIFont *)originalFont {

  objc_setAssociatedObject( self, @selector( originalFont ), originalFont, OBJC_ASSOCIATION_RETAIN );
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
                [self setNeedsUpdateConstraints];
            } );
    PearlAddNotificationObserver( UIAccessibilityBoldTextStatusDidChangeNotification, nil, [NSOperationQueue mainQueue],
            ^(id self, NSNotification *note) {
                [self setNeedsUpdateConstraints];
            } );

    // Not sure why this sometimes happens:
    //* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
    //  * frame #0: 0x000000010fdc8645 libobjc.A.dylib`objc_msgSend + 5
    //    frame #1: 0x00000001146044e4 UIKitCore`-[_UILabelAttributedStringContent defaultValueForAttribute:] + 82
    //    frame #2: 0x00000001145fc7b9 UIKitCore`-[UILabel font] + 58
    //    frame #3: 0x000000010d80b03e MasterPassword`-[UIView(self=0x00007ffc26029a80, _cmd="_pearl_fontMod_updateFont") _pearl_fontMod_updateFont] at UIView+FontScale.m:104:27
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

- (void)setPreferredContentSizeCategoryFontScale:(CGFloat)fontScale {

    objc_setAssociatedObject( self, @selector( preferredContentSizeCategoryFontScale ),
        fontScale == 0? nil: @(fontScale), OBJC_ASSOCIATION_RETAIN );
}

- (CGFloat)preferredContentSizeCategoryFontScale {

    CGFloat fontScale = [objc_getAssociatedObject( self, @selector( preferredContentSizeCategoryFontScale ) ) floatValue];
    if (fontScale != 0)
        return fontScale;

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

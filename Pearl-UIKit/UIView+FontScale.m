//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+FontScale.h"

@interface NSObject(FontScale_JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;

@end

@interface UIApplication(FontScale)

- (CGFloat)preferredContentSizeCategoryFontScale;

@end

#pragma clang diagnostic push
#pragma ide diagnostic ignored "InfiniteRecursion"

@interface UIView(FontScale_Private)

@property (nonatomic) CGFloat appliedFontScale;

@end

@implementation UIView(FontScale)

+ (void)load {

    // JRSwizzle must be present
    if (![self respondsToSelector:@selector( jr_swizzleMethod:withMethod:error: )]) {
        wrn( @"Missing JRSwizzle, cannot load UIView(FontScale)" );
        return;
    }

    NSError *error = nil;
    for (Class type in @[ [UILabel class], [UITextField class], [UITextView class] ]) {
        if ([type jr_swizzleMethod:@selector( updateConstraints ) withMethod:@selector( fontMod_updateConstraints ) error:&error] &&
            [type jr_swizzleMethod:@selector( setFont: ) withMethod:@selector( fontMod_setFont: ) error:&error])
            if (error)
                err( @"While installing UIView(FontScale): %@", [error fullDescription] );
    }
}

- (void)setNoFontScale:(BOOL)noFontScale {

    objc_setAssociatedObject( self, @selector( noFontScale ), @(noFontScale), OBJC_ASSOCIATION_RETAIN );
    [self fontMod_updateFont];
}

- (BOOL)noFontScale {

    return [objc_getAssociatedObject( self, @selector( noFontScale ) ) boolValue];
}

/**
* @return The font scale that is currently applied to the view's font.
*/
- (CGFloat)appliedFontScale {

    return [objc_getAssociatedObject( self, @selector( appliedFontScale ) ) floatValue]?: 1;
}

- (void)setAppliedFontScale:(CGFloat)appliedFontScale {

    objc_setAssociatedObject( self, @selector( appliedFontScale ), @(appliedFontScale), OBJC_ASSOCIATION_RETAIN );
}

- (void)fontMod_updateFont {

    PearlAddNotificationObserver( UIContentSizeCategoryDidChangeNotification, nil, [NSOperationQueue mainQueue],
            ^(id self, NSNotification *note) {
                [self fontMod_updateFont];
            } );

    UIFont *originalFont = [(UILabel *)self font];
    UIFont *scaledFont = [self fontMod_scaledFontFor:originalFont appliedFontScale:self.appliedFontScale];
    if (scaledFont != originalFont) {
        [self fontMod_setFont:scaledFont];
        [self setNeedsUpdateConstraints];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.superview isKindOfClass:[UIControl class]])
                [self.superview setNeedsLayout];
        }];
    }
}

- (UIFont *)fontMod_scaledFontFor:(UIFont *)originalFont appliedFontScale:(CGFloat)appliedFontScale {

    if ([originalFont.fontDescriptor objectForKey:@"NSCTFontUIUsageAttribute"])
        return originalFont;
    if ([(id)self respondsToSelector:@selector( adjustsFontForContentSizeCategory )] && [(id)self adjustsFontForContentSizeCategory])
        return originalFont;
    CGFloat effectiveFontScale = self.noFontScale? 1: UIApp.preferredContentSizeCategoryFontScale;
    if (effectiveFontScale == appliedFontScale)
        return originalFont;

    self.appliedFontScale = effectiveFontScale;
    return [originalFont fontWithSize:originalFont.pointSize * effectiveFontScale / appliedFontScale];
}

- (void)fontMod_updateConstraints {

    [self fontMod_updateFont];
    [self fontMod_updateConstraints];
}

- (void)fontMod_setFont:(UIFont *)newFont {

    [self fontMod_setFont:[self fontMod_scaledFontFor:newFont appliedFontScale:1]];
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

#pragma clang diagnostic pop

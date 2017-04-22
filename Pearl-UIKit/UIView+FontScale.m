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
    [self setNeedsUpdateConstraints];
}

- (BOOL)noFontScale {

    return ([(id)self respondsToSelector:@selector( adjustsFontForContentSizeCategory )] && [(id)self adjustsFontForContentSizeCategory]) ||
           [objc_getAssociatedObject( self, @selector( noFontScale ) ) boolValue];
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
                [self setNeedsUpdateConstraints];
            } );

    CGFloat appliedFontScale = self.appliedFontScale;
    CGFloat effectiveFontScale = self.noFontScale? 1: UIApp.preferredContentSizeCategoryFontScale;
    if (effectiveFontScale == appliedFontScale)
        return;
    self.appliedFontScale = effectiveFontScale;

    UIFont *originalFont = [(UILabel *)self font];
    UIFont *scaledFont = [originalFont fontWithSize:originalFont.pointSize * effectiveFontScale / appliedFontScale];
    [self fontMod_setFont:scaledFont];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([self.superview isKindOfClass:[UIControl class]])
            [self.superview setNeedsLayout];
    }];
}

- (void)fontMod_updateConstraints {

    [self fontMod_updateFont];
    [self fontMod_updateConstraints];
}

- (void)fontMod_setFont:(UIFont *)newFont {

    [self fontMod_setFont:newFont];
    [self setAppliedFontScale:1];
    [self setNeedsUpdateConstraints];
}

@end

@implementation UIApplication (FontScale)

- (CGFloat)preferredContentSizeCategoryFontScale {

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge])
        return 23 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraExtraLarge])
        return 22 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityExtraLarge])
        return 21 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityLarge])
        return 20 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryAccessibilityMedium])
        return 19 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraExtraExtraLarge])
        return 19 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraExtraLarge])
        return 18 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraLarge])
        return 17 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryLarge])
        return 1.0f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryMedium])
        return 15 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategorySmall])
        return 14 / 16.f;

    if ([self.preferredContentSizeCategory isEqual:UIContentSizeCategoryExtraSmall])
        return 13 / 16.f;

    return 1.0f;
}

@end

#pragma clang diagnostic pop

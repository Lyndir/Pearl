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

@property (nonatomic) id contentSizeCategoryObserver;
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
    for (Class type in @[[UILabel class], [UITextField class], [UITextView class]]) {
        if ([type jr_swizzleMethod:@selector( updateConstraints ) withMethod:@selector( fontScale_updateConstraints ) error:&error] &&
            [type jr_swizzleMethod:@selector( setFont: ) withMethod:@selector( fontScale_setFont: ) error:&error])
        if (error)
            err( @"While installing UIView(FontScale): %@", [error fullDescription] );
    }
}

- (void)setFontScale:(CGFloat)fontScale {

    if (fontScale == self.fontScale)
        return;

    objc_setAssociatedObject( self, @selector(fontScale), @(fontScale), OBJC_ASSOCIATION_RETAIN );
    [self setNeedsUpdateFontScale];
}

- (CGFloat)fontScale {

    return [objc_getAssociatedObject( self, @selector( fontScale ) ) floatValue]?: 1;
}

- (void)setIgnoreFontScale:(BOOL)ignoreFontScale {

    objc_setAssociatedObject( self, @selector( ignoreFontScale ), @(ignoreFontScale), OBJC_ASSOCIATION_RETAIN );
    [self enumerateViews:^(UIView *subview, BOOL *stop, BOOL *recurse) {
        if ([subview respondsToSelector:@selector( setFont: )])
            [subview setNeedsLayout];
    } recurse:YES];
}

- (BOOL)ignoreFontScale {

    return [objc_getAssociatedObject( self, @selector( ignoreFontScale ) ) boolValue];
}

/**
* @return The font scale that should affect this view.  It is this view's scale modified by the scale of any of its superviews.
*/
- (CGFloat)effectiveFontScale {

    if (self.ignoreFontScale)
      return 1;

    CGFloat inheritedFontScale = [self isKindOfClass:[UIWindow class]]? 1: (self.window?: UIApp.keyWindow).exportedFontScale;
//    CGFloat inheritedFontScale = 1;
//    if (self.superview)
//        inheritedFontScale = self.superview.exportedFontScale;
//    else if (![self isKindOfClass:[UIWindow class]])
//        inheritedFontScale = [UIApp keyWindow].exportedFontScale;

    return UIApp.preferredContentSizeCategoryFontScale * (self.fontScale * inheritedFontScale?: 1);
}

/**
* @return The font scale that should affect our subviews.
*/
- (CGFloat)exportedFontScale {

    return self.effectiveFontScale;
}

- (id)contentSizeCategoryObserver {

    return objc_getAssociatedObject( self, @selector( contentSizeCategoryObserver ) );
}

- (void)setContentSizeCategoryObserver:(id)observer {

    objc_setAssociatedObject( self, @selector( contentSizeCategoryObserver ), observer, OBJC_ASSOCIATION_RETAIN );
}

/**
* @return The font scale that is currently applied to the view's font.
*/
- (CGFloat)appliedFontScale {

    return [objc_getAssociatedObject( self, @selector( appliedFontScale ) ) floatValue]?: 1;
}

- (void)setAppliedFontScale:(CGFloat)appliedFontScale {

    if (!self.contentSizeCategoryObserver) {
      Weakify( self );
      self.contentSizeCategoryObserver = [[NSNotificationCenter defaultCenter]
          addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            Strongify( self );
            [self setNeedsUpdateConstraints];
          }];
    }

    objc_setAssociatedObject( self, @selector( appliedFontScale ), @(appliedFontScale), OBJC_ASSOCIATION_RETAIN );
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];

//  Weakify( self );
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        Strongify( self );
//        [self invalidateIntrinsicContentSize];
//        for (UIView *view = self; view; view = [view superview])
//            [view setNeedsLayout];
//    }];
}

- (void)updateFontScale {

    CGFloat effectiveFontScale = [self effectiveFontScale], appliedFontScale = [self appliedFontScale];
    if (effectiveFontScale == appliedFontScale)
        return;

    self.appliedFontScale = self.effectiveFontScale;
    UIFont *originalFont = [(UILabel *)self font];
    [self fontScale_setFont:[originalFont fontWithSize:originalFont.pointSize * effectiveFontScale / appliedFontScale]];
}

- (void)setNeedsUpdateFontScale {
  [self setNeedsUpdateConstraints];

  for (UIView *subview in self.subviews)
    [subview setNeedsUpdateFontScale];
}

- (void)fontScale_updateConstraints {

    [self updateFontScale];
    [self fontScale_updateConstraints];
}

- (void)fontScale_setFont:(UIFont *)originalFont {

    if (!self.window) {
        [self fontScale_setFont:originalFont];
        [self setNeedsLayout];
        return;
    }

    CGFloat effectiveFontScale = self.effectiveFontScale;
    if (effectiveFontScale == 1)
        [self fontScale_setFont:originalFont];
    else
        [self fontScale_setFont:[originalFont fontWithSize:originalFont.pointSize * effectiveFontScale]];
    self.appliedFontScale = effectiveFontScale;
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

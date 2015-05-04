//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+FontScale.h"

@interface NSObject(FontScale_JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;

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
    for (Class type in @[[UILabel class], [UITextField class], [UITextView class]]) {
        if ([type jr_swizzleMethod:@selector( layoutSubviews ) withMethod:@selector( fontScale_layoutSubviews ) error:&error] &&
            [type jr_swizzleMethod:@selector( setFont: ) withMethod:@selector( fontScale_setFont: ) error:&error])
        if (error)
            err( @"While installing UIView(FontScale): %@", [error fullDescription] );
    }
}

- (void)setFontScale:(CGFloat)fontScale {

    if (fontScale == self.fontScale)
        return;

    objc_setAssociatedObject( self, @selector(fontScale), @(fontScale), OBJC_ASSOCIATION_RETAIN );
    [self enumerateViews:^(UIView *subview, BOOL *stop, BOOL *recurse) {
        if ([subview respondsToSelector:@selector( setFont: )])
            [subview setNeedsLayout];
    } recurse:YES];
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

    CGFloat inheritedFontScale = 1;
    if (self.superview)
        inheritedFontScale = self.superview.exportedFontScale;
    else if (![self isKindOfClass:[UIWindow class]])
        inheritedFontScale = [UIApp keyWindow].exportedFontScale;

    return self.fontScale * inheritedFontScale?: 1;
}

/**
* @return The font scale that should affect our subviews.
*/
- (CGFloat)exportedFontScale {

    return self.effectiveFontScale;
}

- (void)setAppliedFontScale:(CGFloat)appliedFontScale {

    objc_setAssociatedObject( self, @selector( appliedFontScale ), @(appliedFontScale), OBJC_ASSOCIATION_RETAIN );

    Weakify( self );
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        Strongify( self );
        [self invalidateIntrinsicContentSize];
        for (UIView *view = self; view; view = [view superview])
            [view setNeedsLayout];
    }];
}

/**
* @return The font scale that is currently applied to the view's font.
*/
- (CGFloat)appliedFontScale {

    return [objc_getAssociatedObject( self, @selector( appliedFontScale ) ) floatValue]?: 1;
}

- (void)updateFontScale {

    CGFloat effectiveFontScale = [self effectiveFontScale], appliedFontScale = [self appliedFontScale];
    if (effectiveFontScale == appliedFontScale)
        return;

    UIFont *originalFont = [(UILabel *)self font];
    [self fontScale_setFont:[originalFont fontWithSize:originalFont.pointSize * effectiveFontScale / appliedFontScale]];
    self.appliedFontScale = self.effectiveFontScale;
}

- (void)fontScale_layoutSubviews {

    [self updateFontScale];
    [self fontScale_layoutSubviews];
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

#pragma clang diagnostic pop

//
// Created by Maarten Billemont on 2017-11-21.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

// Modify the variable (of type CGRect) such that it contains a new CGRect derived from the original.
#define CGRectSetX(rect, value)                     ({ CGRect __new = CGRectWithX(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetY(rect, value)                     ({ CGRect __new = CGRectWithY(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetWidth(rect, value)                 ({ CGRect __new = CGRectWithWidth(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetHeight(rect, value)                ({ CGRect __new = CGRectWithHeight(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetOrigin(rect, value)                ({ CGRect __new = CGRectWithOrigin(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetSize(rect, value)                  ({ CGRect __new = CGRectWithSize(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetCenter(rect, value)                ({ CGRect __new = CGRectWithCenter(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetTop(rect, value)                   ({ CGRect __new = CGRectWithTop(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetRight(rect, value)                 ({ CGRect __new = CGRectWithRight(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetBottom(rect, value)                ({ CGRect __new = CGRectWithBottom(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetLeft(rect, value)                  ({ CGRect __new = CGRectWithLeft(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetTopLeft(rect, value)               ({ CGRect __new = CGRectWithTopLeft(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetTopRight(rect, value)              ({ CGRect __new = CGRectWithTopRight(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetBottomRight(rect, value)           ({ CGRect __new = CGRectWithBottomRight(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })
#define CGRectSetBottomLeft(rect, value)            ({ CGRect __new = CGRectWithBottomLeft(rect, value); if (!CGRectEqualToRect( rect, __new )) rect = __new; })

#define CGRectSetXDidChange(rect, value)            ({ CGRect __old = rect; CGRectSetX(rect, value); !CGRectEqualToRect(__old, rect); })
#define CGRectSetYDidChange(rect, value)            ({ CGRect __old = rect; CGRectSetY(rect, value); !CGRectEqualToRect(__old, rect); })
#define CGRectSetWidthDidChange(rect, value)        ({ CGRect __old = rect; CGRectSetWidth(rect, value); !CGRectEqualToRect(__old, rect); })
#define CGRectSetHeightDidChange(rect, value)       ({ CGRect __old = rect; CGRectSetHeight(rect, value); !CGRectEqualToRect(__old, rect); })
#define CGRectSetOriginDidChange(rect, value)       ({ CGRect __old = rect; CGRectSetOrigin(rect, value); !CGRectEqualToRect(__old, rect); })
#define CGRectSetSizeDidChange(rect, value)         ({ CGRect __old = rect; CGRectSetSize(rect, value); !CGRectEqualToRect(__old, rect); })

__BEGIN_DECLS
// Create a new CGRect derived from the original.
extern CGRect CGRectWithX(CGRect rect, CGFloat x);
extern CGRect CGRectWithY(CGRect rect, CGFloat y);
extern CGRect CGRectWithWidth(CGRect rect, CGFloat width);
extern CGRect CGRectWithHeight(CGRect rect, CGFloat height);
extern CGRect CGRectWithOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectWithSize(CGRect rect, CGSize size);

// Calculate the point of a certain part of a CGRect.
extern CGPoint CGRectGetCenter(CGRect rect);
extern CGPoint CGRectGetTop(CGRect rect);
extern CGPoint CGRectGetRight(CGRect rect);
extern CGPoint CGRectGetBottom(CGRect rect);
extern CGPoint CGRectGetLeft(CGRect rect);
extern CGPoint CGRectGetTopLeft(CGRect rect);
extern CGPoint CGRectGetTopRight(CGRect rect);
extern CGPoint CGRectGetBottomRight(CGRect rect);
extern CGPoint CGRectGetBottomLeft(CGRect rect);

// Create a new CGRect from the original anchored at a new position.
extern CGRect CGRectWithCenter(CGRect rect, CGPoint newCenter);
extern CGRect CGRectWithTop(CGRect rect, CGPoint newTop);
extern CGRect CGRectWithRight(CGRect rect, CGPoint newRight);
extern CGRect CGRectWithBottom(CGRect rect, CGPoint newBottom);
extern CGRect CGRectWithLeft(CGRect rect, CGPoint newLeft);
extern CGRect CGRectWithTopLeft(CGRect rect, CGPoint newTopLeft);
extern CGRect CGRectWithTopRight(CGRect rect, CGPoint newTopRight);
extern CGRect CGRectWithBottomRight(CGRect rect, CGPoint newBottomRight);
extern CGRect CGRectWithBottomLeft(CGRect rect, CGPoint newBottomLeft);

// Creating a CGRect.
extern CGRect CGRectFromOriginWithSize(const CGPoint origin, const CGSize size);
extern CGRect CGRectFromCenterWithSize(const CGPoint center, const CGSize size);
/** Use CGFLOAT_MAX in size or margin for auto values.  Currently, in every dimension, only one property may be CGFLOAT_MAX. */
extern CGRect CGRectInCGSizeWithSizeAndMargin(const CGSize container, CGSize size, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left);

// Creating a UIEdgeInsets
extern UIEdgeInsets UIEdgeInsetsFromCGRectInCGSize(const CGRect rect, const CGSize container);

extern CGSize CGSizeUnion(const CGSize size1, const CGSize size2);

typedef struct PearlLayout {
    CGFloat left;
    CGFloat top;
    CGFloat width;
    CGFloat height;
    CGFloat bottom;
    CGFloat right;
} PearlLayout;

typedef NS_OPTIONS( NSUInteger, PearlLayoutOption ) {
    PearlLayoutOptionNone = 0,
    /** Constrain the superview's bounds; ie. do not allow the superview to be resized if needed to fit the view. */
        PearlLayoutOptionConstrained = 1 << 0,
};

#define PearlAutoresizingMinimalLeftMargin   (UIViewAutoresizing)(1 << 6)
#define PearlAutoresizingMinimalWidth        (UIViewAutoresizing)(1 << 7)
#define PearlAutoresizingMinimalRightMargin  (UIViewAutoresizing)(1 << 8)
#define PearlAutoresizingMinimalTopMargin    (UIViewAutoresizing)(1 << 9)
#define PearlAutoresizingMinimalHeight       (UIViewAutoresizing)(1 << 10)
#define PearlAutoresizingMinimalBottomMargin (UIViewAutoresizing)(1 << 11)

__END_DECLS

@interface UIView(PearlLayout)

/**
 * Set the layout of the view based on the given layout string.
 *
 * Note: these values specify the layout of the view's alignment rectangle.
 * The alignment rectangle is usually the same as the view's frame,
 * but a view could offset its alignment rectangle for various reasons.
 * eg. \c -paddingInsets offsets the alignment rectangle negatively (outward), resulting in additional layout margin.
 *
 * Tip: always use -setFrameFrom after all subviews have been added to the view.
 * If changes are made that require superviews to be readjusted after -setFrameFrom was called,
 * such as adding new subviews or changes to fitting size, use -sizeToFitSubviews to update the hierarchy.
 *
 * @"left | top [ s_opt width / height ] bottom | right"
 *
 * A "-" = parent's layout margin, a "-" size = 44.
 * An "=" dimension retains its current value.
 * An "S" dimension substitutes the offset to bring the view inside the safe area.
 * A ">" left/top or "<" right/bottom margin = expand.
 * Empty margin = 0, empty size = fit or expand if both margins are fixed.
 * An "x", "y" or "z" will be replaced with the x, y and z parameter value.
 * s_opt specifies size layout options, | = PearlLayoutOptionConstrainSize
 * Spaces around operators are permitted.
 *
 * @"-[  ]-"       // Use the superview's left and right layout margin, top and bottom default to 0.
 *                 // Since width and height are unspecified but edges are fixed, they will fill available space.
 *
 * @"[  ]20"       // Left defaults to 0 and right is fixed to 20.  Top and bottom also default to 0.
 *                 // Since width and height are unspecified but edges are fixed, they will fill available space.
 *
 * @">[  ]<"       // Left and right edges expand, top and bottom default to 0.
 *                 // Width is unspecified but at least one horizontal edge wants to expand, so use the fitting width.
 *                 // Height is unspecified but the vertical edges are fixed, so height will still fill available space.
 *
 * @">|-[  ]-|-"   // expand left, 8pt from right, 5pt width.  8pt from top and bottom, expand height.
 * @">[ -/30 ]-|"  // expand left, fixed to right.  Fixed to top, 8pt from bottom,  44pt height.
 */
- (void)setFrameFrom:(NSString *)layoutString;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)setFrameFrom:(NSString *)layoutString using:(PearlLayout)layoutOverrides;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides
             options:(PearlLayoutOption)options;

- (void)setFrameFromCurrentSizeAndParentMarginTop:(CGFloat)top right:(CGFloat)right
                                           bottom:(CGFloat)bottom left:(CGFloat)left;
- (void)setFrameFromSize:(CGSize)size andParentMarginTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left;
- (void)setFrameFromSize:(CGSize)size andParentMarginTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options;

/** Shrink the subviews to their minimal frames that respect their autoresizing configuration.
 * The view will grow if needed to fit the subviews' new size. */
- (void)shrinkSubviews;
/** Shrink the view and its subviews to fit the minimal frames that respect their autoresizing configuration.
 * The superview will grow if needed to fit the view's new size. */
- (void)shrink;

/** @return The smallest size this view's frame can take up while still respecting its subviews' autoresizing configuration. */
- (CGSize)minimumAutoresizingSize;

/** @return true if the given mask is present on the view, also supports custom masks PearlAutoresizingMinimal. */
- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask;

@end

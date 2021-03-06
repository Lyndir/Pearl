//
// Created by Maarten Billemont on 2017-11-21.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

// Modify the variable (of type CGRect) such that it contains a new CGRect derived from the original.
#define CGRectSet(rect, value)                      ({ CGRect __new = value; CGRectEqualToRect( rect, __new )? 0: ({ rect = __new; 1; }); })
#define CGRectSetX(rect, value)                     ({ CGRectSet( rect, CGRectWithX( rect, value ) ); })
#define CGRectSetY(rect, value)                     ({ CGRectSet( rect, CGRectWithY( rect, value ) ); })
#define CGRectSetWidth(rect, value)                 ({ CGRectSet( rect, CGRectWithWidth( rect, value ) ); })
#define CGRectSetHeight(rect, value)                ({ CGRectSet( rect, CGRectWithHeight( rect, value ) ); })
#define CGRectSetOrigin(rect, value)                ({ CGRectSet( rect, CGRectWithOrigin( rect, value ) ); })
#define CGRectSetSize(rect, value)                  ({ CGRectSet( rect, CGRectWithSize( rect, value ) ); })
#define CGRectSetCenter(rect, value)                ({ CGRectSet( rect, CGRectWithCenter( rect, value ) ); })
#define CGRectSetTop(rect, value)                   ({ CGRectSet( rect, CGRectWithTop( rect, value ) ); })
#define CGRectSetRight(rect, value)                 ({ CGRectSet( rect, CGRectWithRight( rect, value ) ); })
#define CGRectSetBottom(rect, value)                ({ CGRectSet( rect, CGRectWithBottom( rect, value ) ); })
#define CGRectSetLeft(rect, value)                  ({ CGRectSet( rect, CGRectWithLeft( rect, value ) ); })
#define CGRectSetTopLeft(rect, value)               ({ CGRectSet( rect, CGRectWithTopLeft( rect, value ) ); })
#define CGRectSetTopRight(rect, value)              ({ CGRectSet( rect, CGRectWithTopRight( rect, value ) ); })
#define CGRectSetBottomRight(rect, value)           ({ CGRectSet( rect, CGRectWithBottomRight( rect, value ) ); })
#define CGRectSetBottomLeft(rect, value)            ({ CGRectSet( rect, CGRectWithBottomLeft( rect, value ) ); })

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
extern CGRect CGRectInCGSizeWithSizeAndMargins(const CGSize container, CGSize size, UIEdgeInsets margins);

// Creating a UIEdgeInsets
extern UIEdgeInsets UIEdgeInsetsFromCGRectInCGSize(const CGRect rect, const CGSize container);
extern UIEdgeInsets UIEdgeInsetsFromCGRectInCGRect(const CGRect rect, const CGRect container);

extern CGSize CGSizeUnion(const CGSize size1, const CGSize size2);

extern NSString *PearlDescribeF(const CGFloat fl);
extern NSString *PearlDescribeP(const CGPoint pt);
extern NSString *PearlDescribeS(const CGSize sz);
extern NSString *PearlDescribeR(const CGRect rct);
extern NSString *PearlDescribeI(const UIEdgeInsets ins);
extern NSString *PearlDescribeIS(const UIEdgeInsets ins, const CGSize sz);
extern NSString *PearlDescribeO(const UIOffset ofs);

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
    /** Refit the view without re-fitting its subviews. */
        PearlLayoutOptionShallow = 1 << 1,
    /** This layout operation should only update the frame, not change the autoresizing configuration. */
        PearlLayoutOptionUpdate = 1 << 2,
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
 * Set the layout of the view based on the given layout string.  The layout calculates the view's position and size in its parent.
 * The layout is subsequently maintained by iOS' autoresizing rules.
 *
 * Note: these values specify the layout of the view's alignment rectangle, not its frame.
 * eg. \c -paddingInsets offsets the alignment rectangle negatively (outward), resulting in additional layout margin.
 *
 * Tip: always use \c -setFrameFrom after all subviews have been added to the view.
 * If changes are made that require superviews to be readjusted after -setFrameFrom was called,
 * such as changes to views' fitting sizes, use \c -fitSubviews to re-evaluate a view's hierarchical layout configuration.
 *
 * \code @"left | top [ s_opt width / height ] bottom | right" \endcode
 *
 * \def A "-" = parent's layout margin, a "-" size = 44.
 * \def An "=" dimension retains its current value.
 * \def An "S" dimension offsets the view into the safe area (of the view hierarchy or application window if not yet attached).
 * \def A "&gt;" left/top or "&lt;" right/bottom margin = expand.
 * \def Empty margin = 0, empty size = fit or expand if both margins are fixed.
 * \def An "x", "y" or "z" will be replaced with the x, y and z parameter value.
 * \def s_opt specifies size layout options, | = PearlLayoutOptionConstrainSize
 * \note Spaces around operators are permitted.
 *
 * \code
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
 * \endcode
 */
- (void)setFrameFrom:(NSString *)layoutString;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)setFrameFrom:(NSString *)layoutString using:(PearlLayout)layoutOverrides;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides;
- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides
             options:(PearlLayoutOption)options;

- (void)setFrameFromCurrentSizeAndAlignmentMargins:(UIEdgeInsets)alignmentMargins;
- (void)setFrameFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins;
- (void)setFrameFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options;

/** @return The smallest size this view's frame can take up while still respecting its subviews' autoresizing configuration. */
- (CGSize)minimumAutoresizingSize;

/** @return true if the given mask is present on the view, also supports custom masks PearlAutoresizingMinimal. */
- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask;

/** The frame size for fitting this view in the available space, collapsing margins if permitted by its autoresizing configuration. */
- (CGSize)fittingSizeIn:(CGSize)availableSize;

/** Invalidate and resize this view's hierarchy to fit the superview's bounds.
 * @return YES if the operation caused our bounds to change. */
- (BOOL)fitSubviews;

@end

/**
 * A view for putting autoresizing view hierarchies inside a constraints-based view hierarchy such as a UIStackView.
 *
 * Call -setNeedsUpdateConstraints to invalidate the constraints in this view that cache the hierarchy's fitting size after
 * making a change that requires the hierarchy be re-fitted.
 */
@interface AutoresizingContainerView : UIView

+ (NSArray<AutoresizingContainerView *> *)wrap:(id<NSFastEnumeration>)views;
+ (instancetype)viewWithContent:(UIView *)view;

- (instancetype)initWithContent:(UIView *)contentView;

@end

/**
 * An image view that implements -preferredMaxLayoutWidth and uses its frame width to provide a fitting height.
 */
@interface AutoresizingImageView : UIImageView

/** Set to CGFLOAT_MIN to disable image based sizing (ie. adopt external constraints, scaling the image inside). */
@property(nonatomic) CGFloat preferredMaxLayoutWidth;

@end

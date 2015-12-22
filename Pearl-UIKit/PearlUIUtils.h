/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  PearlUIUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIApp [UIApplication sharedApplication]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Modify the variable (of type CGRect) such that it contains a new CGRect derived from the original.
#define CGRectSetX(rect, value)                     rect = CGRectWithX(rect, value)
#define CGRectSetY(rect, value)                     rect = CGRectWithY(rect, value)
#define CGRectSetWidth(rect, value)                 rect = CGRectWithWidth(rect, value)
#define CGRectSetHeight(rect, value)                rect = CGRectWithHeight(rect, value)
#define CGRectSetOrigin(rect, value)                rect = CGRectWithOrigin(rect, value)
#define CGRectSetSize(rect, value)                  rect = CGRectWithSize(rect, value)
#define CGRectSetCenter(rect, value)                rect = CGRectWithCenter(rect, value)
#define CGRectSetTop(rect, value)                   rect = CGRectWithTop(rect, value)
#define CGRectSetRight(rect, value)                 rect = CGRectWithRight(rect, value)
#define CGRectSetBottom(rect, value)                rect = CGRectWithBottom(rect, value)
#define CGRectSetLeft(rect, value)                  rect = CGRectWithLeft(rect, value)
#define CGRectSetTopLeft(rect, value)               rect = CGRectWithTopLeft(rect, value)
#define CGRectSetTopRight(rect, value)              rect = CGRectWithTopRight(rect, value)
#define CGRectSetBottomRight(rect, value)           rect = CGRectWithBottomRight(rect, value)
#define CGRectSetBottomLeft(rect, value)            rect = CGRectWithBottomLeft(rect, value)

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

/** Get the UIEdgeInsets that insets each edge by the largest edge of either a or b. */
UIEdgeInsets UIEdgeInsetsUnionEdgeInsets(UIEdgeInsets a, UIEdgeInsets b);

/** Get the UIEdgeInsets to apply to the insetRect in order to subtract the subtractRect from it. */
extern UIEdgeInsets UIEdgeInsetsForRectSubtractingRect(CGRect insetRect, CGRect subtractRect);

// UIViewAnimationCurve -> UIViewAnimationOptions
extern UIViewAnimationOptions UIViewAnimationCurveToOptions(UIViewAnimationCurve curve);

// CGPoint <-> CGSize.
extern CGPoint CGPointFromCGSize(const CGSize size);
extern CGPoint CGPointFromCGSizeCenter(const CGSize size);
extern CGSize CGSizeFromCGPoint(const CGPoint point);

// Creating a CGRect.
extern CGRect CGRectFromOriginWithSize(const CGPoint origin, const CGSize size);
extern CGRect CGRectFromCenterWithSize(const CGPoint center, const CGSize size);
/** Use CGFLOAT_MAX in size or padding for auto values.  Currently, in every dimension, only one property may be CGFLOAT_MAX. */
extern CGRect CGRectInCGRectWithSizeAndPadding(const CGRect parent, CGSize size, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left);

// Create a new CGPoint by applying an operation to an original CGPoint.
extern CGPoint CGPointMinusCGPoint(const CGPoint origin, const CGPoint subtract);
extern CGPoint CGPointPlusCGPoint(const CGPoint origin, const CGPoint add);
extern CGPoint CGPointMultiply(const CGPoint origin, const CGFloat multiply);
extern CGPoint CGPointMultiplyCGPoint(const CGPoint origin, const CGPoint multiply);

// Getting the distance between CGPoints.
extern CGPoint CGPointDistanceBetweenCGPoints(CGPoint from, CGPoint to);
extern CGFloat DistanceBetweenCGPointsSq(CGPoint from, CGPoint to);
extern CGFloat DistanceBetweenCGPoints(CGPoint from, CGPoint to);
__END_DECLS

@interface UIImage(PearlUIUtils)

/**
* Create a new image that represents this image, with a white overlay at 0.7 alpha on top.
*/
- (UIImage *)highlightedImage;

@end

@interface UILabel(PearlUIUtils)

/**
 * Automatically determines the size required to show all the text contents and resizes the view's frame accordingly.
 * The view's width is never modified, only the height is adjusted to fit the contents.
 */
- (void)autoSize;

@end

@interface UIScrollView(PearlUIUtils)

/**
 * @see -autoSizeContent:ignoreSubviewsArray:
 */
- (void)autoSizeContent;

/**
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 * @see -autoSizeContent:ignoreSubviewsArray:
 */
- (void)autoSizeContentIgnoreHidden:(BOOL)ignoreHidden
                    ignoreInvisible:(BOOL)ignoreInvisible
                       limitPadding:(BOOL)limitPadding
                     ignoreSubviews:(UIView *)ignoredSubviews, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 * We also listen for keyboard events.  When the keyboard appears, the latest scroll view that was passed to this method will get shrunk to fit above the keyboard and restored after the keyboard is dismissed.
 * You should call this method in your view controllers' -viewWillAppear method.
 *
 * @param ignoredSubviewsArray These subviews are ignored when determining the bounds of the scroll view's content.
 */
- (void)autoSizeContentIgnoreHidden:(BOOL)ignoreHidden
                    ignoreInvisible:(BOOL)ignoreInvisible
                       limitPadding:(BOOL)limitPadding
                ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray;

@end

@interface UIView(PearlUIUtils)

- (UILongPressGestureRecognizer *)dismissKeyboardOnTouch;
+ (void)animateWithDuration:(NSTimeInterval)duration uiAnimations:(void (^)(void))uiAnimations caAnimations:(void (^)(void))caAnimations
                 completion:(void (^)(BOOL finished))completion;
- (NSArray *)addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts
                               metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
- (NSArray *)addConstraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts
                                metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
/** @return All constraints in the view hierarchy that apply to this view. */
- (NSArray *)applicableConstraints;
- (NSDictionary *)applicableConstraintsByHolder;
/** @return The only constraint that applies to this view's given attribute. Aborts DEBUG builds if multiple matching contraints exist. */
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute;
/** @return The only constraint that applies to this view's given attribute and relates to the given other view. Aborts DEBUG builds if multiple matching contraints exist. */
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute otherView:(UIView *)otherView;
- (void)setFrameFromCurrentSizeAndParentPaddingTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
- (void)setFrameFromSize:(CGSize)size andParentPaddingTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/** Return the view or the first parent of it that is of the receiver's type. */
+ (instancetype)findAsSuperviewOf:(UIView *)view;
- (BOOL)isOrHasSuperviewOfKind:(Class)kind;
- (BOOL)enumerateViews:(void (^)(UIView *subview, BOOL *stop, BOOL *recurse))block recurse:(BOOL)recurseDefault;
- (void)printSuperHierarchy;
- (void)printChildHierarchy;
/** Return a string that briefly describes this view. */
- (NSString *)infoDescription;
/** Return a string that briefly describes this view's layout. */
- (NSString *)layoutDescription;

/**
 * Calculate which of this view's subviews have their center closest to the given point.
 */
- (UIView *)subviewClosestTo:(CGPoint)point;

/**
 * Calculate the bounds of the content of the given view by recursively iterating and checking the content bounds
 * of its subviews, so long as it does not clip them.
 *
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 */
- (CGRect)contentBoundsIgnoringSubviews:(UIView *)ignoredSubviews, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Calculate the bounds of the content of the given view by recursively iterating and checking the content bounds
 * of its subviews, so long as it does not clip them.
 *
 * @param ignoredSubviewsArray These subviews are ignored when determining the bounds of the scroll view's content.
 */
- (CGRect)contentBoundsIgnoringSubviewsArray:(NSArray *)ignoredSubviewsArray;

/**
 * Add a red box view to the given view's parent that tracks the given view's bounds.
 */
- (void)showBoundingBox;

/**
 * Add a box view to the given view's parent with the given color that tracks the given view's bounds.
 */
- (void)showBoundingBoxOfColor:(UIColor *)color;

/**
 * Create a rectangle that describes the given view's frame in the coordinates of the top-level view that contains it.
 */
- (CGRect)frameInWindow;

/**
 * Find the current first responder in the given view's hierarchy.
 * @return The given view or a subview of it that is the current first responder or nil if no view has first responder status.
 */
- (UIView *)findFirstResponderInHierarchy;

/**
 * Create a copy of the given view.  Currently supports copying properties of: UIView, UILabel, UIControl, UITextField, UIButton, UIImageView.
 * The copy is added as a child of the given view's superview.
 * @return An owned reference to a new view that has all supported properties of the given view copied.
 */
- (id)clone;

/**
 * Create a copy of the given view.  Currently supports copying properties of: UIView, UILabel, UIControl, UITextField.
 * @param superView The view to add the copy to after creation.  If nil, the copy is not added to any view.
 * @return An owned reference to a new view that has all supported properties of the given view copied.
 */
- (id)cloneAddedTo:(UIView *)superView;

/**
 * Expands localization keys to values in the given view and all its subviews.
 *
 * Properties localizable by this method are: text, placeholder.
 * Additionally, the following views are handled specially:
 *  - UISegmentedControl: Segment titles are localized.
 *  - UIButton: Control state titles are localized.
 *
 * See applyLocalization for the rules of localization expansion.
 */
- (UIView *)localizeProperties;

@end

@interface UIViewController(PearlUIUtils)

/**
 * Expands localization keys to values in the given view controller's properties and view hierarchy.
 */
- (UIViewController *)localizeProperties;

@end

@interface PearlUIUtils : NSObject {
}

/**
 * Calculate which of the given views' center is closest to the given point.
 */
+ (UIView *)viewClosestTo:(CGPoint)point of:(UIView *)views, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Calculate which of the given views' center is closest to the given point.
 */
+ (UIView *)viewClosestTo:(CGPoint)point ofArray:(NSArray *)views;

/**
 * Create a rectangle that describes the frame of the given tab bar item in the given tab bar.
 * @return CGRectNull if the given item is not showing in the given tab bar.
 */
+ (CGRect)frameForItem:(UITabBarItem *)item inTabBar:(UITabBar *)tabBar;

/**
 * Make the given views dismissable by shading the rest of the window to dark when the view becomes the first responder, and resigning the view's first responder status when the shaded area is touched.
 */
+ (void)makeDismissable:(UIView *)views, ... NS_REQUIRES_NIL_TERMINATION;
+ (void)makeDismissableArray:(NSArray *)respondersArray;

/**
 * Apply localization expansion on the given value.
 *
 * Localization expansion happens for values with the syntax: {localization-key[:Default Value]}
 * The localization key is used to look up a localized value.  The optional Default Value is expanded if no localized value could be found
 * for the key.
 *
 * Values that do not abide by this syntax are returned untouched.
 */
+ (NSString *)applyLocalization:(NSString *)localizableValue;

@end

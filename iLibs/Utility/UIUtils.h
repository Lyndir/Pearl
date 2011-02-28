//
//  UIUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIUtils : NSObject {

}

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 */
+ (void)autoSizeContent:(UIScrollView *)scrollView;

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 *
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 */
+ (void)autoSizeContent:(UIScrollView *)scrollView ignoreSubviews:(UIView *)ignoredSubviews, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 *
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 */
+ (void)autoSizeContent:(UIScrollView *)scrollView ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray;

/**
 * Calculate the bounds of the content of the given view by recursively iterating and checking the content bounds
 * of its subviews, so long as it does not clip them.
 *
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 */
+ (CGRect)contentBoundsFor:(UIView *)view ignoreSubviews:(UIView *)ignoredSubviews, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Calculate the bounds of the content of the given view by recursively iterating and checking the content bounds
 * of its subviews, so long as it does not clip them.
 *
 * @param ignoredSubviews These subviews are ignored when determining the bounds of the scroll view's content.
 */
+ (CGRect)contentBoundsFor:(UIView *)view ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray;

/**
 * Add a red box view to the given view's parent that tracks the given view's bounds.
 */
+ (void)showBoundingBoxForView:(UIView *)view;

/**
 * Add a box view to the given view's parent with the given color that tracks the given view's bounds.
 */
+ (void)showBoundingBoxForView:(UIView *)view color:(UIColor *)color;

/**
 * Create a rectangle that describes the given view's frame in the coordinates of the top-level view that contains it.
 */
+ (CGRect)frameInWindow:(UIView *)view;

/**
 * Find the current first responder in the key window.
 * @return The subview of the key window that is the current first responder or nil if no view has first responder status.
 */
+ (UIView *)findFirstResonder;

/**
 * Find the current first responder in the given view's hierarchy.
 * @return The given view or a subview of it that is the current first responder or nil if no view has first responder status.
 */
+ (UIView *)findFirstResonderIn:(UIView *)view;

/**
 * Make the given views dismissable by shading the rest of the window to dark when the view becomes the first responder, and resigning the view's first responder status when the shaded area is touched.
 */
+ (void)makeDismissable:(UIView *)views, ... NS_REQUIRES_NIL_TERMINATION;
+ (void)makeDismissableArray:(NSArray *)respondersArray;

/**
 * Create a copy of the given view.  Currently supports copying properties of: UIView, UILabel, UIControl, UITextField, UIButton, UIImageView.
 * The copy is added as a child of the given view's superview.
 * @return An owned reference to a new view that has all supported properties of the given view copied.
 */
+ (id)copyOf:(UIView *)view;

/**
 * Create a copy of the given view.  Currently supports copying properties of: UIView, UILabel, UIControl, UITextField.
 * @param superView The view to add the copy to after creation.  If nil, the copy is not added to any view.
 * @return An owned reference to a new view that has all supported properties of the given view copied.
 */
+ (id)copyOf:(id)view addTo:(UIView *)superView;

@end

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
//  NSLayoutConstraint (PearlUIKit)
//
//  Created by Maarten Billemont on 2/5/2014.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (PearlUIKit)

/**
 * Make a layout constraint active if it isn't yet.
 */
- (instancetype)activate;

/**
 * Make a layout constraint no longer active if it is.
 */
- (instancetype)deactivate;

/**
 * Update this constraint's constant with the given value, rebuilding it if necessary.
 * NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (instancetype)updateConstant:(CGFloat)constant;

/**
* Update this constraint's multiplier with the given value, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (instancetype)updateMultiplier:(CGFloat)constant;

/**
* Update this constraint's priority with the given value, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (instancetype)withPriority:(UILayoutPriority)priority;

/**
* Update this constraint's constant, multiplier and priority with the given values, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (instancetype)updateConstant:(CGFloat)constant mulitplier:(CGFloat)multiplier priority:(UILayoutPriority)priority;

/**
* Apply any layout changes incurred by this constraint's items.
*/
- (void)layoutIfNeeded;

/**
* Find the view that holds this constraint.
*/
- (nullable UIView *)constraintHolder;

/**
* Remove this constraint from its constraint holder.
*
* @return nil if the constraint wasn't currently held by a view, otherwise returns the view that held the constraint.
*/
- (nullable UIView *)removeFromHolder;

/**
 * Find the view that holds all the given constraints (the highest level superview that contains all the given constraint's items).
 * NOTE: Use this to update layout changes of a batch of constraints at once by calling layoutIfNeeded on the returned view.
 */
+ (nullable UIView *)constraintHolderForConstraints:(NSArray *)layoutConstraints;

@end

NS_ASSUME_NONNULL_END

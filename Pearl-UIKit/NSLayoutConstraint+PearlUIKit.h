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

@interface NSLayoutConstraint (PearlUIKit)

/**
 * Update this constraint's constant with the given value, rebuilding it if necessary.
 * NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (NSLayoutConstraint *)updateConstant:(CGFloat)constant;

/**
* Update this constraint's multiplier with the given value, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (NSLayoutConstraint *)updateMultiplier:(CGFloat)constant;

/**
* Update this constraint's priority with the given value, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (NSLayoutConstraint *)updatePriority:(UILayoutPriority)priority;

/**
* Update this constraint's constant, multiplier and priority with the given values, rebuilding it if necessary.
* NOTE: If you hold a reference to this constraint, update it with this return value in case the constraint was rebuilt.
 */
- (NSLayoutConstraint *)updateConstant:(CGFloat)constant mulitplier:(CGFloat)multiplier priority:(UILayoutPriority)priority;

/**
* Apply any layout changes incurred by this constraint's items.
*/
- (void)layout;

/**
* Find the view that holds this constraint.
*/
- (UIView *)constraintHolder;

/**
 * Find the view that holds all the given constraints (the highest level superview that contains all the given constraint's items).
 * NOTE: Use this to update layout changes of a batch of constraints at once by calling layoutIfNeeded on the returned view.
 */
+ (UIView *)constraintHolderForConstraints:(NSArray *)layoutConstraints;

@end

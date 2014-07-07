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
 * Apply the given constant and the layout changes this incurs on the constraint's items if in an animation block.
 */
- (NSLayoutConstraint *)updateConstant:(CGFloat)constant;

/**
 * Apply the given multiplier and the layout changes this incurs on the constraint's items if in an animation block.
 */
- (NSLayoutConstraint *)updateMultiplier:(CGFloat)constant;

/**
 * Apply the given priority and the layout changes this incurs on the constraint's items if in an animation block.
 */
- (NSLayoutConstraint *)updatePriority:(UILayoutPriority)priority;

/**
 * Apply the given constant and priority and the layout changes this incurs on the constraint's items if in an animation block.
 */
- (NSLayoutConstraint *)updateConstant:(CGFloat)constant mulitplier:(CGFloat)multiplier priority:(UILayoutPriority)priority;

/**
* Apply any layout changes incurred by this constraint's items if in an animation block.
*/
- (void)layout;

/**
* Find the view that holds this constraint.
*/
- (UIView *)constraintHolder;

/**
 * Find the view that holds all the given constraints (the highest level superview that contains all the given constraint's items).
 */
+ (UIView *)constraintHolderForConstraints:(NSArray *)layoutConstraints;

@end

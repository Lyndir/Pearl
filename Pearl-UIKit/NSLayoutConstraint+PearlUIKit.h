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
 * Apply any layout changes incurred by this constraint's items.
 */
- (void)layout;

/**
 * Apply the given constant and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithConstant:(CGFloat)constant;

/**
 * Apply the given priority and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithPriority:(UILayoutPriority)priority;

/**
 * Apply the given constant and priority and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithConstant:(CGFloat)constant priority:(UILayoutPriority)priority;

@end

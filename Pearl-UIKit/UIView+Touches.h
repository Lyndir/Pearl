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
//  UIView+Touches.h
//  UIView+Touches
//
//  Created by lhunath on 2014-03-17.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Touches)

//! YES to make this view ignore touches (but not its subviews).
@property(assign, nonatomic) IBInspectable BOOL ignoreTouches;

//! YES to base touch tests on the alignment rectangle, not the frame.
@property(assign, nonatomic) IBInspectable BOOL alignmentTouches;

@end

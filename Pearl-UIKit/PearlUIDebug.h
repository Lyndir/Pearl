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


@interface PearlUIDebug : NSObject {

}

/**
 * Remove all the debug elements currently showing.
 */
+ (void)clear;

/**
 * Show a rectangle in the window using the given color with smaller width than that of the last call to this method.
 */
+ (PearlBoxView *)showRect:(CGRect)rect color:(UIColor *)color;

/**
 * Show a rectangle in the window using the given color and the given width.
 */
+ (PearlBoxView *)showRect:(CGRect)rect color:(UIColor *)color width:(CGFloat)width;

/**
 * Fill a rectangle in the window using the given color.
 */
+ (PearlBoxView *)fillRect:(CGRect)rect color:(UIColor *)color;

@end

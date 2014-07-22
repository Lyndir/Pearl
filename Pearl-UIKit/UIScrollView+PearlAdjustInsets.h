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
//  UIScrollView(PearlAdjustInsets).h
//  UIScrollView(PearlAdjustInsets)
//
//  Created by lhunath on 2014-03-22.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView(PearlAdjustInsets)

/**
* @return The NSNotificationCenter observer to make the magic happen.
*/
- (id)automaticallyAdjustInsetsForKeyboard;

/**
* @return UIEdgeInsets needed to dodge any views that occlude this scroll view's content.
*/
- (UIEdgeInsets)occludedInsets;

/**
* Apply the occludedInsets to the current content insets.
*/
- (void)insetOcclusion;

@end

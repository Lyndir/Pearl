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

#import <UIKit/UIKit.h>

@interface UIView(PearlAdjustInsets)

/**
* @return UIEdgeInsets needed to dodge any views that occlude this scroll view's content.
*/
- (UIEdgeInsets)occludedInsets;

@end

@interface UIScrollView(PearlAdjustInsets)

/**
* Installs a keyboard appearance observer which adjusts the content insets of this scrollView to prevent occlusion.
*
* You can remove this observer with PearlRemoveNotificationObserversFrom( [scrollView] )
*/
- (void)automaticallyAdjustInsetsForKeyboard;

/**
* Apply the occludedInsets to the current content insets.
*/
- (void)insetOcclusion;

@end

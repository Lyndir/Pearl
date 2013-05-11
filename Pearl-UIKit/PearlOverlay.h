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
//  PearlOverlay.h
//  PearlOverlay
//
//  Created by lhunath on 2013-04-03.
//  Copyright, lhunath (Maarten Billemont) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PearlOverlay : NSObject

/**
 * The currently active overlay.
 */
+ (PearlOverlay *)activeOverlay;

/**
 * Create an overlay view controller that controls an overlay message.
 *
 * @param title             The title of the overlay.
 */
- (id)initWithTitle:(NSString *)title;

/**
 * Initializes and shows an overlay.  See -initWithTitle:
 */
+ (instancetype)showOverlayWithTitle:(NSString *)title;


#pragma mark ###############################
#pragma mark Behaviors

/**
 * Show the overlay managed by this view controller.
 *
 * @return  self, for chaining.
 */
- (PearlOverlay *)showOverlay;

/**
 * @return YES if the overlay is added to the view hierarchy.
 */
- (BOOL)isVisible;

/**
 * Dismiss the overlay managed by this view controller.
 */
- (PearlOverlay *)cancelOverlayAnimated:(BOOL)animated;

@end

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
+ (NSArray *)activeOverlays;

/**
 * Create an overlay view controller that controls an overlay message.
 *
 * @param title             The title of the overlay.
 * @param activity          YES if the overlay should have an activity spinner.
 * @param cancelOnTouch     If nil, the overlay will not inhibit touches.
 *                          If set, the overlay will darken the rest of the window and a touch will fire the block.
 *                          If the block returns NO, nothing will happen.  If it returns YES, the overlay will be cancelled.
 */
- (id)initWithTitle:(NSString *)title withActivity:(BOOL)activity cancelOnTouch:(BOOL (^)(void))cancelOnTouch;

/**
 * Initializes and shows an overlay.  See -initWithTitle:
 */
+ (instancetype)showProgressOverlayWithTitle:(NSString *)title;
+ (instancetype)showProgressOverlayWithTitle:(NSString *)title cancelOnTouch:(BOOL (^)(void))cancelOnTouch;
+ (instancetype)showTemporaryOverlayWithTitle:(NSString *)title dismissAfter:(NSTimeInterval)seconds;

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

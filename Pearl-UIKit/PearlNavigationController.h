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
//  PearlNavigationController.h
//  PearlNavigationController
//
//  Created by lhunath on 2013-04-15.
//  Copyright, lhunath (Maarten Billemont) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A UINavigationController subclass that allows you to customize behavior using properties or runtime attributes from IB.
 */
@interface PearlNavigationController : UINavigationController

/**
 * If set to YES, -shouldAutorotate and -supportedInterfaceOrientations will be forwarded to the top view controller.
 */
@property(nonatomic, assign) BOOL forwardInterfaceRotation;

/**
 * -[UIViewController (BOOL)shouldAutorotate]
 */
@property(nonatomic, assign) BOOL shouldAutorotate;

/**
 * -[UIViewController (NSUInteger)supportedInterfaceOrientations]
 */
@property(nonatomic, assign) NSUInteger supportedInterfaceOrientations;

@end

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
//  PearlDeviceUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PearlDeviceUtils : NSObject {
}

/** @return A string that very specifically identifies the exact platform.  This is a more detailed version of UIDevice-model. */
+ (NSString *)platform;

/** @return YES when the application binary has been encrypted. */
+ (BOOL)isAppEncrypted;

/** @return YES when the kernel allows execution of shell code. */
+ (BOOL)isJailbroken;

/** YES when invoked on an iPod touch device. */
+ (BOOL)isIPod;
/** YES when invoked on an iPad device. */
+ (BOOL)isIPad;
/** YES when invoked on an iPhone device. */
+ (BOOL)isIPhone;
/** YES when invoked on the iPhone simulator. */
+ (BOOL)isSimulator;

/** The scale difference of the device's user interface in comparison to an iPhone UI. */
+ (float)uiScale;

@end

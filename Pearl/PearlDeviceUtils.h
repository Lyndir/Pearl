/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
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

/** Generates a string that very specifically identifies the exact platform.  This is a more detailed version of UIDevice-model. */
+ (NSString *)platform;

/** Generate a string of hexadecimal characters that represents given deviceToken (APNs registration device trust token) */
+ (NSString *)deviceTokenAsHex:(NSData *)deviceToken;

/** Generate a string of hexadecimal characters that represents the current deviceToken (APNs registration device trust token) */
+ (NSString *)currentDeviceTokenAsHex;

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

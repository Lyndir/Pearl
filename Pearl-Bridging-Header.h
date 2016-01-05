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
//  Pearl-Bridging-Header.h
//

#import <Availability.h>

#ifdef __OBJC__
#import <Foundation/Foundation.h>

// Pearl Configuration
#ifdef PEARL
#import "Pearl.h"
#endif
#if TARGET_OS_IPHONE
#ifdef PEARL_COCOS2D
#import "Pearl-Cocos2D.h"
#endif
#endif
#ifdef PEARL_CRYPTO
#import "Pearl-Crypto.h"
#endif
#ifdef PEARL_MEDIA
#import "Pearl-Media.h"
#endif
#if TARGET_OS_IPHONE
#ifdef PEARL_UIKIT
#import <UIKit/UIKit.h>
#import "Pearl-UIKit.h"
#endif
#endif
#ifdef PEARL_WS
#import "Pearl-WS.h"
#endif

#endif

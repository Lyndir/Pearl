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
//  UIUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDebug : NSObject {

}

/**
 * Remove all the debug elements currently showing.
 */
+ (void)clear;

/**
 * Show a rectangle in the window using the given color with smaller width than that of the last call to this method.
 */
+ (BoxView *)showRect:(CGRect)rect color:(UIColor *)color;

/**
 * Show a rectangle in the window using the given color and the given width.
 */
+ (BoxView *)showRect:(CGRect)rect color:(UIColor *)color width:(CGFloat)width;

/**
 * Fill a rectangle in the window using the given color.
 */
+ (BoxView *)fillRect:(CGRect)rect color:(UIColor *)color;

@end

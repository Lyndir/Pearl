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

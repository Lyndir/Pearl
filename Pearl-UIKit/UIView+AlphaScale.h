//
// Created by Maarten Billemont on 2014-07-18.
//

#import <Foundation/Foundation.h>

/**
* Automatically scales to alpha to reduce the translucency when UIAccessibilityIsReduceTransparencyEnabled
*/
@interface UIView(AlphaScale)

/**
 * If YES, this view and its subviews ignore alpha scaling.
 */
@property(nonatomic) IBInspectable BOOL ignoreAlphaScale;

@end

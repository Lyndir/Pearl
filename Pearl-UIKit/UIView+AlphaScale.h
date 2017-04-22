//
// Created by Maarten Billemont on 2014-07-18.
//

#import <Foundation/Foundation.h>

/**
* Automatically scales to alpha to reduce the translucency when UIAccessibilityIsReduceTransparencyEnabled
*/
@interface UIView(AlphaScale)

/**
 * If YES, this view does not partake in automatic accessibility translucency scaling.
 */
@property(nonatomic) IBInspectable BOOL noAlphaScale;

@end

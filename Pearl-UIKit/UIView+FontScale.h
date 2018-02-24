//
// Created by Maarten Billemont on 2014-07-18.
//

#import <Foundation/Foundation.h>

/**
* Automatically scales to font size to match the accessible content size category
*/
@interface UIView(FontScale)

/**
 * If YES, this view does not partake in automatic dynamic font size scaling.
 */
@property(nonatomic) IBInspectable BOOL noFontScale;

/**
 * If YES, this view and its subviews do not partake in automatic font bolding.
 */
@property(nonatomic) IBInspectable BOOL noFontBolding;

@end

@interface UIApplication(FontScale)

/**
 * Returns the font scale that reflects the current content size category.
 *
 * Set to non-zero in order to override the current content size category with a custom font scale.
 */
@property(nonatomic) CGFloat preferredContentSizeCategoryFontScale;

@end

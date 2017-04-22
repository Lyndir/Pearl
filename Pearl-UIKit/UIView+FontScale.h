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

@end

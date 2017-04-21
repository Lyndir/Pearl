//
// Created by Maarten Billemont on 2014-07-18.
//

#import <Foundation/Foundation.h>

/**
* Adds a variant of -hidden that is animatable.
*/
@interface UIView(Visible)

/**
 * If NO, this view returns an alpha of 0 instead of its actual alpha.
 */
@property(nonatomic) IBInspectable BOOL visible;

@end

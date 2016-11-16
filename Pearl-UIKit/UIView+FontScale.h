//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* A category which allows you to scale the font point sizes of this view and all its subviews with a single assignment.
*/
@interface UIView(FontScale)

/**
 * The scale by which this view should scale its (and its subviews') fonts.
 */
@property(nonatomic) IBInspectable CGFloat fontScale;

/**
 * If YES, this view and its subviews ignore its and any inherited font scale.
 */
@property(nonatomic) IBInspectable BOOL ignoreFontScale;

- (void)setNeedsUpdateFontScale;

@end

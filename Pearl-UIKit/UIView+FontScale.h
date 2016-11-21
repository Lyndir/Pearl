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
 * If YES, this view and its subviews ignore its and any inherited font scale.
 */
@property(nonatomic) IBInspectable BOOL ignoreFontScale;

@end

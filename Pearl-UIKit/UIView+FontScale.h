//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView(FontScale)

/**
 * The scale by which this view should scale its (and its subviews') fonts.
 */
@property(nonatomic) CGFloat fontScale;

/**
 * If YES, this view and its subviews ignore its and any inherited font scale.
 */
@property(nonatomic) BOOL ignoreFontScale;

@end

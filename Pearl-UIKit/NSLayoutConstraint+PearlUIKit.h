//
// Created by Maarten Billemont on 2/5/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (PearlUIKit)

/**
 * Apply any layout changes incurred by this constraint's items.
 */
- (void)layout;

/**
 * Apply the given constant and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithConstant:(CGFloat)constant;

/**
 * Apply the given priority and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithPriority:(UILayoutPriority)priority;

/**
 * Apply the given constant and priority and the layout changes this incurs on the constraint's items.
 */
- (void)layoutWithConstant:(CGFloat)constant priority:(UILayoutPriority)priority;

@end

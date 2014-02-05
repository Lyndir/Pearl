//
// Created by Maarten Billemont on 2/5/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (PearlUIKit)

/**
 * Apply any changes these constraints have on the layout that have not yet been applied.
 */
- (void)apply;

@end

//
// Created by Maarten Billemont on 2/5/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "NSLayoutConstraint+PearlUIKit.h"


@implementation NSLayoutConstraint (PearlUIKit)

- (void)apply {
  if ([self.firstItem isKindOfClass:[UIView class]])
    [((UIView *) self.firstItem) layoutIfNeeded];
  if ([self.secondItem isKindOfClass:[UIView class]])
    [((UIView *) self.secondItem) layoutIfNeeded];
}

@end

//
// Created by Maarten Billemont on 2/5/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "NSLayoutConstraint+PearlUIKit.h"


@implementation NSLayoutConstraint (PearlUIKit)

- (void)layout {

  UIView *view;
  if ([self.firstItem isKindOfClass:[UIView class]]) {
    view = self.firstItem;
    [view setNeedsLayout];
    [view layoutIfNeeded];
    [view.superview layoutIfNeeded];
  }

  if ([self.secondItem isKindOfClass:[UIView class]]) {
    view = self.secondItem;
    [view setNeedsLayout];
    [view layoutIfNeeded];
    [view.superview layoutIfNeeded];
  }
}

- (void)layoutWithConstant:(CGFloat)constant {

  self.constant = constant;
  [self layout];
}

- (void)layoutWithPriority:(UILayoutPriority)priority {

  self.priority = priority;
  [self layout];
}

- (void)layoutWithConstant:(CGFloat)constant priority:(UILayoutPriority)priority {

  self.constant = constant;
  self.priority = priority;
  [self layout];
}

@end

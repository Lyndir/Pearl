/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  NSLayoutConstraint (PearlUIKit)
//
//  Created by Maarten Billemont on 2/5/2014.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NSLayoutConstraint+PearlUIKit.h"


@implementation NSLayoutConstraint (PearlUIKit)

- (void)layoutIfNeeded {

  // Lay out the constraint holder, and while its frame changes, also lay out the superview to allow dependant views to lay out correctly.
  UIView *layoutContainer = [self constraintHolder];
  CGRect oldFrame;
  while (layoutContainer) {
    oldFrame = layoutContainer.frame;
    [layoutContainer layoutIfNeeded];

    if (CGRectEqualToRect( oldFrame, layoutContainer.frame ))
      break;
    layoutContainer = [layoutContainer superview];
  };
}

- (NSLayoutConstraint *)updateConstant:(CGFloat)constant {

  return [self updateConstant:constant mulitplier:self.multiplier priority:self.priority];
}

- (NSLayoutConstraint *)updateMultiplier:(CGFloat)multiplier {

  return [self updateConstant:self.constant mulitplier:multiplier priority:self.priority];
}

- (NSLayoutConstraint *)updatePriority:(UILayoutPriority)priority {

  return [self updateConstant:self.constant mulitplier:self.multiplier priority:priority];
}

- (NSLayoutConstraint *)updateConstant:(CGFloat)constant mulitplier:(CGFloat)multiplier priority:(UILayoutPriority)priority {

  if ((self.priority != priority && (self.priority == UILayoutPriorityRequired || priority == UILayoutPriorityRequired)) ||
      self.multiplier != multiplier) {
    NSLayoutConstraint *rebuiltConstraint =
      [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation
                                      toItem:self.secondItem attribute:self.secondAttribute
                                  multiplier:multiplier constant:constant];
    rebuiltConstraint.priority = priority;

    // Find the view that holds the constraint and replace it with the new one.
    UIView *constraintHolder = [self constraintHolder];
    [constraintHolder removeConstraint:self];
    [constraintHolder addConstraint:rebuiltConstraint];

    return rebuiltConstraint;
  }

  if (self.constant != constant)
    self.constant = constant;
  if (self.priority != priority)
    self.priority = priority;

  return self;
}

- (UIView *)constraintHolder {

  UIView *constraintHolder = self.firstItem;
  while (constraintHolder && ![constraintHolder.constraints containsObject:self])
    constraintHolder = [constraintHolder superview];
  if (!constraintHolder) {
    constraintHolder = self.secondItem;
    while (constraintHolder && ![constraintHolder.constraints containsObject:self])
      constraintHolder = [constraintHolder superview];
  }
  return constraintHolder?: self.firstItem;
}

+ (UIView *)constraintHolderForConstraints:(NSArray *)layoutConstraints {

  UIView *constraintHolder = nil;
  for (NSLayoutConstraint *constraint in layoutConstraints)
    if (!constraintHolder ||
        ![constraint.firstItem isDescendantOfView:constraintHolder] ||
        ![constraint.secondItem isDescendantOfView:constraintHolder])
      constraintHolder = [constraint constraintHolder];

  return constraintHolder;
}

@end

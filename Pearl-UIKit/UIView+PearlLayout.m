//
// Created by Maarten Billemont on 2017-11-21.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "UIView+PearlLayout.h"

CGRect CGRectWithX(CGRect rect, CGFloat x) {

  return (CGRect){ { x, rect.origin.y }, { rect.size.width, rect.size.height } };
}

CGRect CGRectWithY(CGRect rect, CGFloat y) {

  return (CGRect){ { rect.origin.x, y }, { rect.size.width, rect.size.height } };
}

CGRect CGRectWithWidth(CGRect rect, CGFloat width) {

  return (CGRect){ rect.origin, { width, rect.size.height } };
}

CGRect CGRectWithHeight(CGRect rect, CGFloat height) {

  return (CGRect){ rect.origin, { rect.size.width, height } };
}

CGRect CGRectWithOrigin(CGRect rect, CGPoint origin) {

  return (CGRect){ origin, rect.size };
}

CGRect CGRectWithSize(CGRect rect, CGSize size) {

  return (CGRect){ rect.origin, size };
}

CGPoint CGRectGetCenter(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGRectGetTop(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y );
}

CGPoint CGRectGetRight(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGRectGetBottom(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height );
}

CGPoint CGRectGetLeft(CGRect rect) {

  return CGPointMake( rect.origin.x, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGRectGetTopLeft(CGRect rect) {

  return CGPointMake( rect.origin.x, rect.origin.y );
}

CGPoint CGRectGetTopRight(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y );
}

CGPoint CGRectGetBottomRight(CGRect rect) {

  return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height );
}

CGPoint CGRectGetBottomLeft(CGRect rect) {

  return CGPointMake( rect.origin.x, rect.origin.y + rect.size.height );
}

CGRect CGRectWithCenter(CGRect rect, CGPoint newCenter) {

  return CGRectFromCenterWithSize( newCenter, rect.size );
}

CGRect CGRectWithTop(CGRect rect, CGPoint newTop) {

  return CGRectFromCenterWithSize( CGPointMake( newTop.x, newTop.y + rect.size.height / 2 ), rect.size );
}

CGRect CGRectWithRight(CGRect rect, CGPoint newRight) {

  return CGRectFromCenterWithSize( CGPointMake( newRight.x - rect.size.width / 2, newRight.y ), rect.size );
}

CGRect CGRectWithBottom(CGRect rect, CGPoint newBottom) {

  return CGRectFromCenterWithSize( CGPointMake( newBottom.x, newBottom.y - rect.size.height / 2 ), rect.size );
}

CGRect CGRectWithLeft(CGRect rect, CGPoint newLeft) {

  return CGRectFromCenterWithSize( CGPointMake( newLeft.x + rect.size.width / 2, newLeft.y ), rect.size );
}

CGRect CGRectWithTopLeft(CGRect rect, CGPoint newTopLeft) {

  return CGRectFromOriginWithSize( newTopLeft, rect.size );
}

CGRect CGRectWithTopRight(CGRect rect, CGPoint newTopRight) {

  return CGRectFromOriginWithSize( CGPointMake( newTopRight.x - rect.size.width, newTopRight.y ), rect.size );
}

CGRect CGRectWithBottomRight(CGRect rect, CGPoint newBottomRight) {

  return CGRectFromOriginWithSize( CGPointMake( newBottomRight.x - rect.size.width, newBottomRight.y - rect.size.height ), rect.size );
}

CGRect CGRectWithBottomLeft(CGRect rect, CGPoint newBottomLeft) {

  return CGRectFromOriginWithSize( CGPointMake( newBottomLeft.x, newBottomLeft.y - rect.size.height ), rect.size );
}

CGRect CGRectFromOriginWithSize(const CGPoint origin, const CGSize size) {

  return CGRectMake( origin.x, origin.y, size.width, size.height );
}

CGRect CGRectFromCenterWithSize(const CGPoint center, const CGSize size) {

  return CGRectMake( center.x - size.width / 2, center.y - size.height / 2, size.width, size.height );
}

CGRect CGRectInCGRectWithSizeAndPadding(const CGRect parent, CGSize size, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {

  if (size.width == CGFLOAT_MAX) {
    if (left == CGFLOAT_MAX && right == CGFLOAT_MAX)
      left = right = size.width = parent.size.width / 3;
    else if (left == CGFLOAT_MAX)
      left = size.width = (parent.size.width - right) / 2;
    else if (right == CGFLOAT_MAX)
      right = size.width = (parent.size.width - left) / 2;
    else
      size.width = parent.size.width - left - right;
  }
  if (size.height == CGFLOAT_MAX) {
    if (top == CGFLOAT_MAX && bottom == CGFLOAT_MAX)
      top = bottom = size.height = parent.size.height / 3;
    else if (top == CGFLOAT_MAX)
      top = size.height = (parent.size.height - bottom) / 2;
    else if (bottom == CGFLOAT_MAX)
      bottom = size.height = (parent.size.height - top) / 2;
    else
      size.height = parent.size.height - top - bottom;
  }
  if (top == CGFLOAT_MAX) {
    if (bottom == CGFLOAT_MAX)
      top = (parent.size.height - size.height) / 2;
    else
      top = parent.size.height - size.height - bottom;
  }
  if (left == CGFLOAT_MAX) {
    if (right == CGFLOAT_MAX)
      left = (parent.size.width - size.width) / 2;
    else
      left = parent.size.width - size.width - right;
  }

  return CGRectFromOriginWithSize( CGPointMake( left, top ), size );
}

@implementation UIView(PearlLayout)

- (void)setFrameFromCurrentSizeAndParentPaddingTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {

  [self setFrameFromSize:self.frame.size andParentPaddingTop:top right:right bottom:bottom left:left];
}

- (void)setFrameFrom:(NSString *)layoutString {

  [self setFrameFrom:layoutString using:(PearlLayout){}];
}

- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x {

  [self setFrameFrom:layoutString x:x y:0 z:0 using:(PearlLayout){}];
}

- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y {

  [self setFrameFrom:layoutString x:x y:y z:0 using:(PearlLayout){}];
}

- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {

  [self setFrameFrom:layoutString x:x y:y z:z using:(PearlLayout){}];
}

- (void)setFrameFrom:(NSString *)layoutString using:(PearlLayout)layoutOverrides {

  [self setFrameFrom:layoutString x:0 y:0 z:0 using:layoutOverrides];
}

- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides {

  [self setFrameFrom:layoutString x:x y:y z:z using:layoutOverrides options:PearlLayoutOptionNone];
}

- (void)setFrameFrom:(NSString *)layoutString x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z using:(PearlLayout)layoutOverrides
             options:(PearlLayoutOption)options {

  static NSRegularExpression *layoutRE = nil;
  static dispatch_once_t once = 0;
  dispatch_once( &once, ^{
    layoutRE = [[NSRegularExpression alloc] initWithPattern:
            @" *([^\\[| ]*)(?: *\\| *([^\\] ]*))? *\\[ *([\\|]*) *([^\\]\\|/ ]*)(?: */ *([^\\]\\|/ ]*))? *(?:[\\|]*) *\\] *(?:([^|]*) *\\| *)?([^,]*) *"
                                                    options:0 error:nil];
  } );

  // Parse
  NSTextCheckingResult
      *layoutComponents = [layoutRE firstMatchInString:layoutString options:0 range:NSMakeRange( 0, layoutString.length )];
  NSString *leftLayoutString = [layoutComponents rangeAtIndex:1].location == NSNotFound? nil:
                               [layoutString substringWithRange:[layoutComponents rangeAtIndex:1]];
  NSString *topLayoutString = [layoutComponents rangeAtIndex:2].location == NSNotFound? nil:
                              [layoutString substringWithRange:[layoutComponents rangeAtIndex:2]];
  NSString *sizeLayoutString = [layoutComponents rangeAtIndex:3].location == NSNotFound? nil:
                               [layoutString substringWithRange:[layoutComponents rangeAtIndex:3]];
  NSString *widthLayoutString = [layoutComponents rangeAtIndex:4].location == NSNotFound? nil:
                                [layoutString substringWithRange:[layoutComponents rangeAtIndex:4]];
  NSString *heightLayoutString = [layoutComponents rangeAtIndex:5].location == NSNotFound? nil:
                                 [layoutString substringWithRange:[layoutComponents rangeAtIndex:5]];
  NSString *bottomLayoutString = [layoutComponents rangeAtIndex:6].location == NSNotFound? nil:
                                 [layoutString substringWithRange:[layoutComponents rangeAtIndex:6]];
  NSString *rightLayoutString = [layoutComponents rangeAtIndex:7].location == NSNotFound? nil:
                                [layoutString substringWithRange:[layoutComponents rangeAtIndex:7]];
  CGFloat leftLayoutValue = [leftLayoutString floatValue], rightLayoutValue = [rightLayoutString floatValue];
  CGFloat widthLayoutValue = [widthLayoutString floatValue], heightLayoutValue = [heightLayoutString floatValue];
  CGFloat topLayoutValue = [topLayoutString floatValue], bottomLayoutValue = [bottomLayoutString floatValue];

  // Overrides
  if (layoutOverrides.left)
    leftLayoutValue = layoutOverrides.left;
  if (layoutOverrides.top)
    topLayoutValue = layoutOverrides.top;
  if (layoutOverrides.width)
    widthLayoutValue = layoutOverrides.width;
  if (layoutOverrides.height)
    heightLayoutValue = layoutOverrides.height;
  if (layoutOverrides.bottom)
    bottomLayoutValue = layoutOverrides.bottom;
  if (layoutOverrides.right)
    rightLayoutValue = layoutOverrides.right;

  // Options
  if ([sizeLayoutString rangeOfString:@"|"].location != NSNotFound)
    options |= PearlLayoutOptionConstrainSize;

  // Left
  if ([leftLayoutString isEqualToString:@">"])
    leftLayoutValue = CGFLOAT_MAX;
  else if ([leftLayoutString isEqualToString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    leftLayoutValue = self.superview.layoutMargins.left;
  else if ([leftLayoutString isEqualToString:@"="])
    leftLayoutValue = self.frame.origin.x;
  else if ([leftLayoutString isEqualToString:@"S"])
//        leftLayoutValue = MAX( 0, CGRectGetMinX( self.safeAreaLayoutGuide.layoutFrame ) - CGRectGetMinX( self.frame ) );
    leftLayoutValue = 0;
  else if ([leftLayoutString isEqualToString:@"x"])
    leftLayoutValue = x;
  else if ([leftLayoutString isEqualToString:@"y"])
    leftLayoutValue = y;
  else if ([leftLayoutString isEqualToString:@"z"])
    leftLayoutValue = z;

  // Right
  if ([rightLayoutString isEqualToString:@"<"])
    rightLayoutValue = CGFLOAT_MAX;
  else if ([rightLayoutString isEqualToString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    rightLayoutValue = self.superview.layoutMargins.right;
  else if ([rightLayoutString isEqualToString:@"="])
    rightLayoutValue = CGRectGetRight( self.superview.bounds ).x - CGRectGetRight( self.frame ).x;
  else if ([rightLayoutString isEqualToString:@"S"])
//        rightLayoutValue = MAX( 0, CGRectGetMaxX( self.frame ) - CGRectGetMaxX( self.safeAreaLayoutGuide.layoutFrame ) );
    rightLayoutValue = 0;
  else if ([rightLayoutString isEqualToString:@"x"])
    rightLayoutValue = x;
  else if ([rightLayoutString isEqualToString:@"y"])
    rightLayoutValue = y;
  else if ([rightLayoutString isEqualToString:@"z"])
    rightLayoutValue = z;

  // Top
  if ([topLayoutString isEqualToString:@">"])
    topLayoutValue = CGFLOAT_MAX;
  else if ([topLayoutString isEqualToString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    topLayoutValue = self.superview.layoutMargins.top;
  else if ([topLayoutString isEqualToString:@"="])
    topLayoutValue = self.frame.origin.y;
  else if ([topLayoutString isEqualToString:@"S"])
//        topLayoutValue = MAX( 0, CGRectGetMinY( self.safeAreaLayoutGuide.layoutFrame ) - CGRectGetMinY( self.frame ) );
    topLayoutValue = UIApp.statusBarFrame.size.height;
  else if ([topLayoutString isEqualToString:@"x"])
    topLayoutValue = x;
  else if ([topLayoutString isEqualToString:@"y"])
    topLayoutValue = y;
  else if ([topLayoutString isEqualToString:@"z"])
    topLayoutValue = z;

  // Bottom
  if ([bottomLayoutString isEqualToString:@"<"])
    bottomLayoutValue = CGFLOAT_MAX;
  else if ([bottomLayoutString isEqualToString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    bottomLayoutValue = self.superview.layoutMargins.bottom;
  else if ([bottomLayoutString isEqualToString:@"="])
    bottomLayoutValue = CGRectGetBottom( self.superview.bounds ).y - CGRectGetBottom( self.frame ).y;
  else if ([bottomLayoutString isEqualToString:@"S"])
//        bottomLayoutValue = MAX( 0, CGRectGetMaxY( self.frame ) - CGRectGetMaxY( self.safeAreaLayoutGuide.layoutFrame ) );
    bottomLayoutValue = 0;
  else if ([bottomLayoutString isEqualToString:@"x"])
    bottomLayoutValue = x;
  else if ([bottomLayoutString isEqualToString:@"y"])
    bottomLayoutValue = y;
  else if ([bottomLayoutString isEqualToString:@"z"])
    bottomLayoutValue = z;

  // Width
  if ([widthLayoutString isEqualToString:@"-"])
    widthLayoutValue = 44;
  else if ([widthLayoutString isEqualToString:@"="])
    widthLayoutValue = self.frame.size.width;
  else if ([widthLayoutString isEqualToString:@"x"])
    widthLayoutValue = x;
  else if ([widthLayoutString isEqualToString:@"y"])
    widthLayoutValue = y;
  else if ([widthLayoutString isEqualToString:@"z"])
    widthLayoutValue = z;
  else if (!widthLayoutString.length)
    widthLayoutValue = CGFLOAT_MIN;
  if (leftLayoutValue < CGFLOAT_MAX && rightLayoutValue < CGFLOAT_MAX) {
    NSAssert( widthLayoutValue == CGFLOAT_MIN, @"Cannot have fixed left, right and width values." );
    widthLayoutValue = CGFLOAT_MAX;
  }

  // Height
  if ([heightLayoutString isEqualToString:@"-"])
    heightLayoutValue = 44;
  else if ([heightLayoutString isEqualToString:@"="])
    heightLayoutValue = self.frame.size.height;
  else if ([heightLayoutString isEqualToString:@"x"])
    heightLayoutValue = x;
  else if ([heightLayoutString isEqualToString:@"y"])
    heightLayoutValue = y;
  else if ([heightLayoutString isEqualToString:@"z"])
    heightLayoutValue = z;
  else if (!heightLayoutString.length)
    heightLayoutValue = CGFLOAT_MIN;
  if (topLayoutValue < CGFLOAT_MAX && bottomLayoutValue < CGFLOAT_MAX) {
    NSAssert( heightLayoutValue == CGFLOAT_MIN, @"Cannot have fixed top, bottom and height values." );
    heightLayoutValue = CGFLOAT_MAX;
  }

  // Apply layout
  [self setFrameFromSize:CGSizeMake( widthLayoutValue, heightLayoutValue )
     andParentPaddingTop:topLayoutValue right:rightLayoutValue bottom:bottomLayoutValue left:leftLayoutValue
                 options:options];
}

- (void)setFrameFromSize:(CGSize)size andParentPaddingTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left {

  [self setFrameFromSize:size andParentPaddingTop:top right:right bottom:bottom left:left options:PearlLayoutOptionNone];
}

- (void)setFrameFromSize:(CGSize)size andParentPaddingTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options {

  // Grow the superview if needed to fit the padding.
  CGFloat availableWidth = self.superview.bounds.size.width -
                           (left == CGFLOAT_MAX? 0: left) - (right == CGFLOAT_MAX? 0: right);
  CGFloat availableHeight = self.superview.bounds.size.height -
                            (top == CGFLOAT_MAX? 0: top) - (bottom == CGFLOAT_MAX? 0: bottom);
  if (availableWidth < 0)
    CGRectSetWidth( self.superview.bounds,
        (availableWidth = 0) + (left == CGFLOAT_MAX? 0: left) + (right == CGFLOAT_MAX? 0: right) );
  if (availableHeight < 0)
    CGRectSetHeight( self.superview.bounds,
        (availableHeight = 0) + (top == CGFLOAT_MAX? 0: top) + (bottom == CGFLOAT_MAX? 0: bottom) );

  // For the fitting size, use 0 for unknown minimal bounds and the available space for unknown maximal bounds.
  CGSize fittingSize = [self sizeThatFits:(CGSize){
      .width = size.width == CGFLOAT_MIN? 0: size.width == CGFLOAT_MAX? availableWidth: size.width,
      .height = size.height == CGFLOAT_MIN? 0: size.height == CGFLOAT_MAX? availableHeight: size.height,
  }];

  // Resolve our minimal size dimensions with our fitting size.
  CGSize resolvedSize = CGSizeMake(
      size.width == CGFLOAT_MIN? fittingSize.width: MAX( fittingSize.width, size.width ),
      size.height == CGFLOAT_MIN? fittingSize.height: MAX( fittingSize.height, size.height ) );

  // Grow the superview if needed to fit the resolved size and padding.
  CGSize requestedSize = CGSizeMake(
      resolvedSize.width == CGFLOAT_MAX? fittingSize.width: resolvedSize.width,
      resolvedSize.height == CGFLOAT_MAX? fittingSize.height: resolvedSize.height );
  if (requestedSize.width > availableWidth)
    CGRectSetWidth( self.superview.bounds,
        (availableWidth = requestedSize.width) + (left == CGFLOAT_MAX? 0: left) + (right == CGFLOAT_MAX? 0: right) );
  if (requestedSize.height > availableHeight)
    CGRectSetHeight( self.superview.bounds,
        (availableHeight = requestedSize.height) + (top == CGFLOAT_MAX? 0: top) + (bottom == CGFLOAT_MAX? 0: bottom) );

  if (options & PearlLayoutOptionConstrainSize)
    resolvedSize = CGSizeMake(
        resolvedSize.width == CGFLOAT_MAX? CGFLOAT_MAX: MIN( resolvedSize.width, availableWidth ),
        resolvedSize.height == CGFLOAT_MAX? CGFLOAT_MAX: MIN( resolvedSize.height, availableHeight ) );

  // Resolve the frame based on the parent's bounds and our layout parameters.
  self.frame = CGRectInCGRectWithSizeAndPadding( self.superview.bounds, resolvedSize, top, right, bottom, left );
  self.autoresizingMask = (UIViewAutoresizing)(
      (top == CGFLOAT_MAX? UIViewAutoresizingFlexibleTopMargin: 0) |
      (right == CGFLOAT_MAX? UIViewAutoresizingFlexibleRightMargin: 0) |
      (bottom == CGFLOAT_MAX? UIViewAutoresizingFlexibleBottomMargin: 0) |
      (left == CGFLOAT_MAX? UIViewAutoresizingFlexibleLeftMargin: 0) |
      (resolvedSize.width == CGFLOAT_MAX? UIViewAutoresizingFlexibleWidth: 0) |
      (resolvedSize.height == CGFLOAT_MAX? UIViewAutoresizingFlexibleHeight: 0));
}

- (UIEdgeInsets)frameInsets {
  return UIEdgeInsetsMake( CGRectGetMinY( self.frame ), CGRectGetMinX( self.frame ),
      self.superview.bounds.size.height - CGRectGetMaxY( self.frame ),
      self.superview.bounds.size.width - CGRectGetMaxX( self.frame ) );
}

- (CGSize)minimumAutoresizingSize {
  CGSize minSize = CGSizeZero;
//    if (self.autoresizingMask & UIViewAutoresizingFlexibleWidth || self.autoresizingMask & UIViewAutoresizingFlexibleHeight)
  for (UIView *subview in self.subviews) {
    UIEdgeInsets insets = subview.frameInsets;
    CGSize minSizeSubview = [subview minimumAutoresizingSize];
    minSize.width = MAX( minSize.width, minSizeSubview.width +
                                        (subview.autoresizingMask & UIViewAutoresizingFlexibleLeftMargin? 0: insets.left) +
                                        (subview.autoresizingMask & UIViewAutoresizingFlexibleRightMargin? 0: insets.right) );
    minSize.height = MAX( minSize.height, minSizeSubview.height +
                                          (subview.autoresizingMask & UIViewAutoresizingFlexibleTopMargin? 0: insets.top) +
                                          (subview.autoresizingMask & UIViewAutoresizingFlexibleBottomMargin? 0: insets.bottom) );
  }

  return minSize;
//        return CGSizeMake(
//                (self.autoresizingMask & UIViewAutoresizingFlexibleWidth? minSize.width: self.bounds.size.width ),
//                (self.autoresizingMask & UIViewAutoresizingFlexibleHeight? minSize.height: self.bounds.size.height) );
}

- (void)sizeToFitSubviews {
  UIEdgeInsets insets = self.frameInsets;
  CGRectSetSize( self.frame, [self minimumAutoresizingSize] );

  for (UIView *subview in self.subviews)
    [subview sizeToFitSubviews];

  [self setFrameFromSize:CGSizeMake(
          self.autoresizingMask & UIViewAutoresizingFlexibleWidth? CGFLOAT_MAX: self.frame.size.width,
          self.autoresizingMask & UIViewAutoresizingFlexibleHeight? CGFLOAT_MAX: self.frame.size.height )
     andParentPaddingTop:self.autoresizingMask & UIViewAutoresizingFlexibleTopMargin? CGFLOAT_MAX: insets.top
                   right:self.autoresizingMask & UIViewAutoresizingFlexibleRightMargin? CGFLOAT_MAX: insets.right
                  bottom:self.autoresizingMask & UIViewAutoresizingFlexibleBottomMargin? CGFLOAT_MAX: insets.bottom
                    left:self.autoresizingMask & UIViewAutoresizingFlexibleLeftMargin? CGFLOAT_MAX: insets.left
                 options:PearlLayoutOptionNone];
}

@end

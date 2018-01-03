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

CGRect CGRectInCGSizeWithSizeAndMargin(const CGSize container, CGSize size, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {

  if (size.width == CGFLOAT_MAX) {
    if (left == CGFLOAT_MAX && right == CGFLOAT_MAX)
      left = right = size.width = container.width / 3;
    else if (left == CGFLOAT_MAX)
      left = size.width = (container.width - right) / 2;
    else if (right == CGFLOAT_MAX)
      right = size.width = (container.width - left) / 2;
    else
      size.width = container.width - left - right;
  }
  if (size.height == CGFLOAT_MAX) {
    if (top == CGFLOAT_MAX && bottom == CGFLOAT_MAX)
      top = bottom = size.height = container.height / 3;
    else if (top == CGFLOAT_MAX)
      top = size.height = (container.height - bottom) / 2;
    else if (bottom == CGFLOAT_MAX)
      bottom = size.height = (container.height - top) / 2;
    else
      size.height = container.height - top - bottom;
  }
  if (top == CGFLOAT_MAX) {
    if (bottom == CGFLOAT_MAX)
      top = (container.height - size.height) / 2;
    else
      top = container.height - size.height - bottom;
  }
  if (left == CGFLOAT_MAX) {
    if (right == CGFLOAT_MAX)
      left = (container.width - size.width) / 2;
    else
      left = container.width - size.width - right;
  }

  return CGRectFromOriginWithSize( CGPointMake( left, top ), size );
}

UIEdgeInsets UIEdgeInsetsFromCGRectInCGSize(const CGRect rect, const CGSize container) {
  return UIEdgeInsetsMake(
      CGRectGetMinY( rect ), CGRectGetMinX( rect ),
      container.height - CGRectGetMaxY( rect ), container.width - CGRectGetMaxX( rect ) );
}

CGSize CGSizeUnion(const CGSize size1, const CGSize size2) {
  return CGSizeMake( MAX( size1.width, size2.width ), MAX( size1.height, size2.height ) );
}

@implementation UIView(PearlLayout)

- (void)setFrameFromCurrentSizeAndParentMarginTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {

  [self setFrameFromSize:self.frame.size andParentMarginTop:top right:right bottom:bottom left:left];
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
  CGRect alignmentRect = self.alignmentRect;
  UIEdgeInsets alignmentMargins = UIEdgeInsetsFromCGRectInCGSize( alignmentRect, self.superview.bounds.size );

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
    options |= PearlLayoutOptionConstrained;

  // Left
  if ([leftLayoutString isEqualToString:@">"])
    leftLayoutValue = CGFLOAT_MAX;
  else if ([leftLayoutString isEqualToString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    leftLayoutValue = self.superview.layoutMargins.left;
  else if ([leftLayoutString isEqualToString:@"="])
    leftLayoutValue = alignmentMargins.left;
  else if ([leftLayoutString isEqualToString:@"S"])
//        leftLayoutValue = MAX( 0, CGRectGetMinX( self.safeAreaLayoutGuide.layoutFrame ) - CGRectGetMinX( alignmentRect ) );
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
    rightLayoutValue = alignmentMargins.right;
  else if ([rightLayoutString isEqualToString:@"S"])
//        rightLayoutValue = MAX( 0, CGRectGetMaxX( alignmentRect ) - CGRectGetMaxX( self.safeAreaLayoutGuide.layoutFrame ) );
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
    topLayoutValue = alignmentMargins.top;
  else if ([topLayoutString isEqualToString:@"S"])
//        topLayoutValue = MAX( 0, CGRectGetMinY( self.safeAreaLayoutGuide.layoutFrame ) - CGRectGetMinY( alignmentRect ) );
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
    bottomLayoutValue = alignmentMargins.bottom;
  else if ([bottomLayoutString isEqualToString:@"S"])
//        bottomLayoutValue = MAX( 0, CGRectGetMaxY( alignmentRect ) - CGRectGetMaxY( self.safeAreaLayoutGuide.layoutFrame ) );
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
    widthLayoutValue = alignmentRect.size.width;
  else if ([widthLayoutString isEqualToString:@"x"])
    widthLayoutValue = x;
  else if ([widthLayoutString isEqualToString:@"y"])
    widthLayoutValue = y;
  else if ([widthLayoutString isEqualToString:@"z"])
    widthLayoutValue = z;
  else if (!widthLayoutString.length)
    widthLayoutValue = CGFLOAT_MIN;
  if (leftLayoutValue < CGFLOAT_MAX && rightLayoutValue < CGFLOAT_MAX && widthLayoutValue == CGFLOAT_MIN)
    widthLayoutValue = CGFLOAT_MAX;

  // Height
  if ([heightLayoutString isEqualToString:@"-"])
    heightLayoutValue = 44;
  else if ([heightLayoutString isEqualToString:@"="])
    heightLayoutValue = alignmentRect.size.height;
  else if ([heightLayoutString isEqualToString:@"x"])
    heightLayoutValue = x;
  else if ([heightLayoutString isEqualToString:@"y"])
    heightLayoutValue = y;
  else if ([heightLayoutString isEqualToString:@"z"])
    heightLayoutValue = z;
  else if (!heightLayoutString.length)
    heightLayoutValue = CGFLOAT_MIN;
  if (topLayoutValue < CGFLOAT_MAX && bottomLayoutValue < CGFLOAT_MAX && heightLayoutValue == CGFLOAT_MIN)
    heightLayoutValue = CGFLOAT_MAX;

  // Apply layout
  [self setFrameFromSize:CGSizeMake( widthLayoutValue, heightLayoutValue )
   andAlignmentMarginTop:topLayoutValue right:rightLayoutValue bottom:bottomLayoutValue left:leftLayoutValue
                 options:options];
}

- (void)setFrameFromSize:(CGSize)size andParentMarginTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left {

  [self setFrameFromSize:size andAlignmentMarginTop:top right:right bottom:bottom left:left options:PearlLayoutOptionNone];
}

- (void)setFrameFromSize:(CGSize)size andAlignmentMarginTop:(CGFloat)top right:(CGFloat)right
                  bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options {

  // Save the layout configuration in the autoresizing mask.
  [self setAutoresizingMaskFromSize:size andAlignmentMarginTop:top right:right bottom:bottom left:left options:options];

  // Determine the size available in the superview for our alignment rect.
  /// fittingSize = The measured size of the alignment rect based on the available space and given margins.
  CGRect alignmentRect = self.alignmentRect;
  UIEdgeInsets autoresizingMargins = UIEdgeInsetsMake(
      top - (alignmentRect.origin.y - self.frame.origin.y),
      left - (alignmentRect.origin.x - self.frame.origin.x),
      bottom - ((self.frame.origin.y + self.frame.size.height) - (alignmentRect.origin.y + alignmentRect.size.height)),
      right - ((self.frame.origin.x + self.frame.size.width) - (alignmentRect.origin.x + alignmentRect.size.width)) );
  CGSize fittingSize = [self fittingSizeIn:self.superview.bounds.size margins:autoresizingMargins];
  fittingSize = [self alignmentRectForFrame:(CGRect){ autoresizingMargins.left, autoresizingMargins.top, fittingSize }].size;

  /// requestedSize = The size we want for this view's alignment rect.  ie. The given size, but no less than the fitting size.
  CGSize requestedSize = CGSizeMake(
      size.width == CGFLOAT_MIN? fittingSize.width: size.width,
      size.height == CGFLOAT_MIN? fittingSize.height: size.height );

  /// requiredSize = The minimum space needed for this view's alignment rect. ie. The requested size, w/MAX minimized to fitting size.
  CGSize requiredSize = CGSizeMake(
      requestedSize.width == CGFLOAT_MAX? fittingSize.width: requestedSize.width,
      requestedSize.height == CGFLOAT_MAX? fittingSize.height: requestedSize.height );

  // Grow the superview if needed to fit the alignment rect and margin.
  CGSize container = CGSizeUnion( self.superview.frame.size, (CGSize){
      requiredSize.width + (left == CGFLOAT_MAX || left == CGFLOAT_MIN? 0: left) + (right == CGFLOAT_MAX || right == CGFLOAT_MIN? 0: right),
      requiredSize.height + (top == CGFLOAT_MAX || top == CGFLOAT_MIN? 0: top) + (bottom == CGFLOAT_MAX || bottom == CGFLOAT_MIN? 0: bottom)
  } );
  if (self.superview && self.autoresizingMask)
    if (!(options & PearlLayoutOptionConstrained)) {
      CGRectSetSize( self.superview.frame, container );
      // TODO: recurse down the superview hierarchy
      // TODO: currently the assumption is the user will never do a setFrameFrom: on a subview without also calling it on the superviews.
    }
    else if (!CGSizeEqualToSize( self.superview.frame.size, container ))
      wrn( @"Container: %@, is not be large enough for constrained fit of: %@ (need %@, has %@)",
          [self.superview infoName], [self infoName], NSStringFromCGSize( container ), NSStringFromCGSize( self.superview.frame.size ) );

  // Resolve the alignment rect from the requested size and margin, and the frame from the alignment rect.
  CGRectSet( self.frame, [self frameForAlignmentRect:
      CGRectInCGSizeWithSizeAndMargin( container, requestedSize, top, right, bottom, left )] );
}

- (CGSize)minimumAutoresizingSize {
  CGSize minSize = self.bounds.size;
  if ([self.superview isKindOfClass:[UITableViewCell class]])
    // Special case UITableViewCellContentView.
    minSize = CGSizeZero;
  else if (!self.autoresizingMask)
    // We don't autoresize.
    return minSize;

  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleWidth | PearlAutoresizingMinimalWidth])
    minSize.width = 0;
  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleHeight | PearlAutoresizingMinimalHeight])
    minSize.height = 0;
  if (!self.autoresizesSubviews)
    // Our subviews are unaffected by our size.
    return minSize;

  for (UIView *subview in self.subviews)
    if (subview.translatesAutoresizingMaskIntoConstraints && subview.autoresizingMask) {
      CGSize minSizeFromSubview = [subview minimumAutoresizingSize];

      UIEdgeInsets margins = subview.autoresizingMargins;
      if (![subview hasAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | PearlAutoresizingMinimalLeftMargin])
        minSizeFromSubview.width += margins.left;
      if (![subview hasAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | PearlAutoresizingMinimalRightMargin])
        minSizeFromSubview.width += margins.right;
      if (![subview hasAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | PearlAutoresizingMinimalTopMargin])
        minSizeFromSubview.height += margins.top;
      if (![subview hasAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | PearlAutoresizingMinimalBottomMargin])
        minSizeFromSubview.height += margins.bottom;

      minSize = CGSizeUnion( minSize, minSizeFromSubview );
    }

  return minSize;
}

- (UIEdgeInsets)fittingMargins {

  UIEdgeInsets margins = self.autoresizingMargins;
  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | PearlAutoresizingMinimalLeftMargin])
    margins.left = 0;
  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | PearlAutoresizingMinimalRightMargin])
    margins.right = 0;
  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | PearlAutoresizingMinimalTopMargin])
    margins.top = 0;
  if ([self hasAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | PearlAutoresizingMinimalBottomMargin])
    margins.bottom = 0;

  return margins;
}

- (CGSize)fittingSizeIn:(CGSize)availableSize {
  return [self fittingSizeIn:availableSize margins:self.fittingMargins];
}

- (CGSize)fittingSizeIn:(CGSize)availableSize margins:(UIEdgeInsets)autoresizingMargins {
  // TODO: This method repeats Tn times for a hierarchy n deep.  Can we avoid this or cache results?
  static NSMutableArray *stack;
  if (!stack)
    stack = [NSMutableArray new];
  [stack addObject:[self infoName]];
  NSMutableString *string = [NSMutableString new];
  for (id item in stack)
    [string appendFormat:@"%@ | ", item];
  trc( @"fittingSizeIn: %@", string );

  // Determine how the view wants to fit in the available space.
  CGSize minimumSize = self.autoresizingMask? [self minimumAutoresizingSize]: CGSizeZero;
  availableSize.width -= autoresizingMargins.left + autoresizingMargins.right;
  availableSize.height -= autoresizingMargins.top + autoresizingMargins.bottom;
  availableSize = CGSizeUnion( minimumSize, availableSize );
  CGSize fittingSize = CGSizeUnion( minimumSize, [self collapsedFittingSizeIn:availableSize] );

  // Grow to fit our autoresizing subviews.  Other subviews were handled by -systemLayoutSizeFittingSize.
  if (self.autoresizesSubviews)
    for (UIView *subview in self.subviews)
      if (subview.autoresizingMask) {
        CGSize subviewSize = [subview fittingSizeIn:availableSize];
        UIEdgeInsets subviewMargins = [subview fittingMargins];
        subviewSize.width += subviewMargins.left + subviewMargins.right;
        subviewSize.height += subviewMargins.top + subviewMargins.bottom;
        fittingSize = CGSizeUnion( fittingSize, subviewSize );
      }

  [stack removeLastObject];
  return fittingSize;
}

- (CGSize)collapsedFittingSizeIn:(CGSize)availableSize {
  // We bias/favour width fitting to height fitting to size multi-line UILabels right.
  // Not entirely sure why; some long UILabels do not limit on fittingSize properly without assigning its width to preferredMaxLayoutWidth.
  [self assignPreferredMaxLayoutWidth:availableSize];
  CGSize fittingSize = [self systemLayoutSizeFittingSize:availableSize
                           withHorizontalFittingPriority:[self hasAutoresizingMask:PearlAutoresizingMinimalWidth]?
                                                         UILayoutPriorityFittingSizeLevel: UILayoutPriorityDefaultHigh
                                 verticalFittingPriority:[self hasAutoresizingMask:PearlAutoresizingMinimalHeight]?
                                                         UILayoutPriorityFittingSizeLevel: UILayoutPriorityDefaultLow];
  [self resetPreferredMaxLayoutWidth];

  // If size of view is determined by constraints, don't collapse it.
  if (self.constraints.count)
    return fittingSize;

  // Preserve non-flexible layout sizes.
  if (![self hasAutoresizingMask:UIViewAutoresizingFlexibleWidth | PearlAutoresizingMinimalWidth])
    fittingSize.width = MAX( fittingSize.width, self.bounds.size.width );
  if (![self hasAutoresizingMask:UIViewAutoresizingFlexibleHeight | PearlAutoresizingMinimalHeight])
    fittingSize.height = MAX( fittingSize.height, self.bounds.size.height );

  // UIViews' -sizeThatFits: just returns -bounds.size, collapse it.
  // Shortcut logic where possible.
  if ([self.superview isKindOfClass:[UITableViewCell class]])
    fittingSize.height = 0;
  else if ([self class] == [UIView class])
    fittingSize = CGSizeZero;
  else {
    Class type = [self class];
    PearlFindMethod( type, @selector( sizeThatFits: ), &type );
    if (type == [UIView class])
      fittingSize = CGSizeZero;
  }

  return fittingSize;
}

- (BOOL)fitSubviews {
  return [self fitInAlignmentRect:self.alignmentRect margins:self.alignmentMargins];
}

- (BOOL)fitInAlignmentRect:(CGRect)alignmentRect margins:(UIEdgeInsets)alignmentMargins {
  CGRect oldBounds = self.bounds;

  // Recalculate the view's fitting size based on its autoresizing configuration.
  [self setFrameFromSize:CGSizeMake(
          [self hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]? CGFLOAT_MAX:
          [self hasAutoresizingMask:PearlAutoresizingMinimalWidth] || !self.autoresizingMask? CGFLOAT_MIN: alignmentRect.size.width,
          [self hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]? CGFLOAT_MAX:
          [self hasAutoresizingMask:PearlAutoresizingMinimalHeight] || !self.autoresizingMask? CGFLOAT_MIN: alignmentRect.size.height )
   andAlignmentMarginTop:[self hasAutoresizingMask:UIViewAutoresizingFlexibleTopMargin]? CGFLOAT_MAX:
                         [self hasAutoresizingMask:PearlAutoresizingMinimalTopMargin]? CGFLOAT_MIN: alignmentMargins.top
                   right:[self hasAutoresizingMask:UIViewAutoresizingFlexibleRightMargin]? CGFLOAT_MAX:
                         [self hasAutoresizingMask:PearlAutoresizingMinimalRightMargin]? CGFLOAT_MIN: alignmentMargins.right
                  bottom:[self hasAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin]? CGFLOAT_MAX:
                         [self hasAutoresizingMask:PearlAutoresizingMinimalBottomMargin]? CGFLOAT_MIN: alignmentMargins.bottom
                    left:[self hasAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin]? CGFLOAT_MAX:
                         [self hasAutoresizingMask:PearlAutoresizingMinimalLeftMargin]? CGFLOAT_MIN: alignmentMargins.left
                 options:PearlLayoutOptionConstrained];

  // Update fitting size for the subviews that are positioned by autoresizing.  Other subviews are handled by -layoutSubviews.
  if (self.autoresizesSubviews)
    for (UIView *subview in self.subviews)
      if (subview.autoresizingMask)
        [subview fitSubviews];

  BOOL changed = !CGRectEqualToRect( self.bounds, oldBounds );
//  if (changed) {
//    // FIXME: Does not coalesce multiple changes to a cell properly, only do -endUpdates after all updates have been performed.
//    [[UITableView findAsSuperviewOf:self] beginUpdates];
//    [self setNeedsUpdateConstraints];
//    [[UITableView findAsSuperviewOf:self] endUpdates];
//  }
  return changed;
}

- (void)assignPreferredMaxLayoutWidth:(CGSize)availableSize {
  if (![self respondsToSelector:@selector( preferredMaxLayoutWidth )] ||
      ![self respondsToSelector:@selector( setPreferredMaxLayoutWidth: )])
    return;

  int assignDepth = [objc_getAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ) ) intValue];

  if (!assignDepth) {
    CGFloat resetValue = [(UILabel *)self preferredMaxLayoutWidth];
    if (!resetValue) {
      objc_setAssociatedObject( self, @selector( resetPreferredMaxLayoutWidth ), @(resetValue), OBJC_ASSOCIATION_RETAIN );
      [(UILabel *)self setPreferredMaxLayoutWidth:availableSize.width];
    }
  }

  objc_setAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ), @(++assignDepth), OBJC_ASSOCIATION_RETAIN );
}

- (void)resetPreferredMaxLayoutWidth {
  if (![self respondsToSelector:@selector( preferredMaxLayoutWidth )] ||
      ![self respondsToSelector:@selector( setPreferredMaxLayoutWidth: )])
    return;

  int assignDepth = [objc_getAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ) ) intValue];
  objc_setAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ), @(--assignDepth), OBJC_ASSOCIATION_RETAIN );

  if (!assignDepth) {
    NSNumber *resetValue = objc_getAssociatedObject( self, @selector( resetPreferredMaxLayoutWidth ) );
    if (resetValue) {
      objc_setAssociatedObject( self, @selector( resetPreferredMaxLayoutWidth ), nil, OBJC_ASSOCIATION_RETAIN );
      [(UILabel *)self setPreferredMaxLayoutWidth:[resetValue floatValue]];
    }
  }
}

- (void)setAutoresizingMaskFromSize:(CGSize)size andAlignmentMarginTop:(CGFloat)top right:(CGFloat)right
                             bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options {
  UIViewAutoresizing mask = (UIViewAutoresizing)(
      (top == CGFLOAT_MAX? UIViewAutoresizingFlexibleTopMargin:
       top == CGFLOAT_MIN? PearlAutoresizingMinimalTopMargin: 0) |
      (right == CGFLOAT_MAX? UIViewAutoresizingFlexibleRightMargin:
       right == CGFLOAT_MIN? PearlAutoresizingMinimalRightMargin: 0) |
      (bottom == CGFLOAT_MAX? UIViewAutoresizingFlexibleBottomMargin:
       bottom == CGFLOAT_MIN? PearlAutoresizingMinimalBottomMargin: 0) |
      (left == CGFLOAT_MAX? UIViewAutoresizingFlexibleLeftMargin:
       left == CGFLOAT_MIN? PearlAutoresizingMinimalLeftMargin: 0) |
      (size.width == CGFLOAT_MAX? UIViewAutoresizingFlexibleWidth:
       size.width == CGFLOAT_MIN? PearlAutoresizingMinimalWidth: 0) |
      (size.height == CGFLOAT_MAX? UIViewAutoresizingFlexibleHeight:
       size.height == CGFLOAT_MIN? PearlAutoresizingMinimalHeight: 0));

  objc_setAssociatedObject( self, @selector( setAutoresizingMaskFromSize:andAlignmentMarginTop:right:bottom:left:options: ),
      @(mask), OBJC_ASSOCIATION_RETAIN );
  self.autoresizingMask = mask;

  [self.superview didSetSubview:self autoresizingMaskFromSize:size andAlignmentMarginTop:top right:right bottom:bottom left:left
                        options:options];
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
andAlignmentMarginTop:(CGFloat)top right:(CGFloat)right
               bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options {
}

- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask {
  return mask & [objc_getAssociatedObject( self,
      @selector( setAutoresizingMaskFromSize:andAlignmentMarginTop:right:bottom:left:options: ) )
                 ?: @(self.autoresizingMask) unsignedLongValue];
}

@end

@interface AutoresizingContainerView()

@property(nonatomic) UIEdgeInsets contentAlignmentMargins;

@end

@implementation AutoresizingContainerView

+ (NSArray<AutoresizingContainerView *> *)wrap:(id<NSFastEnumeration>)views {
  NSMutableArray<AutoresizingContainerView *> *wrapped = [NSMutableArray array];
  for (UIView *view in views)
    [wrapped addObject:[[self alloc] initWithContent:view]];

  return wrapped;
}

- (instancetype)initWithContent:(UIView *)contentView {
  if (!(self = [self initWithFrame:(CGRect){ CGPointZero, contentView.alignmentRect.size }]))
    return nil;

  if (!contentView.autoresizingMask)
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

  [self addSubview:contentView];
  [self setBounds:self.bounds];
  [self setAutoresizesSubviews:NO];

  [self.contentView observeKeyPath:@"frame" withBlock:^(id from, id to, NSKeyValueChange cause, id _self) {
    [self invalidateIntrinsicContentSize];
  }];
  [self.contentView observeKeyPath:@"bounds" withBlock:^(id from, id to, NSKeyValueChange cause, id _self) {
    [self invalidateIntrinsicContentSize];
  }];
  [self.contentView observeKeyPath:@"hidden" withBlock:^(id from, id to, NSKeyValueChange cause, id _self) {
    self.hidden = self.contentView.hidden;
  }];
  [self.contentView observeKeyPath:@"autoresizingMask" withBlock:^(id from, id to, NSKeyValueChange cause, id _self) {
    [self setContentHuggingPriority:
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalWidth]? UILayoutPriorityDefaultLow:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]? UILayoutPriorityDefaultHigh: UILayoutPriorityRequired
                            forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalHeight]? UILayoutPriorityDefaultLow:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]? UILayoutPriorityDefaultHigh: UILayoutPriorityRequired
                            forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalWidth]? UILayoutPriorityDefaultLow:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]? UILayoutPriorityDefaultHigh: UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalHeight]? UILayoutPriorityDefaultLow:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]? UILayoutPriorityDefaultHigh: UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisVertical];
  }];

  return self;
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
andAlignmentMarginTop:(CGFloat)top right:(CGFloat)right
               bottom:(CGFloat)bottom left:(CGFloat)left options:(PearlLayoutOption)options {
  self.contentAlignmentMargins = UIEdgeInsetsMake( top, left, bottom, right );
}

- (CGSize)intrinsicContentSize {
  CGRect alignmentRect = self.contentView.alignmentRect;
  UIEdgeInsets autoresizingMargins = self.contentAlignmentMargins;
  autoresizingMargins.top -= alignmentRect.origin.y - self.contentView.frame.origin.y;
  autoresizingMargins.left -= alignmentRect.origin.x - self.contentView.frame.origin.x;
  autoresizingMargins.bottom -= (self.contentView.frame.origin.y + self.contentView.frame.size.height)
                                - (alignmentRect.origin.y + alignmentRect.size.height);
  autoresizingMargins.right -= (self.contentView.frame.origin.x + self.contentView.frame.size.width)
                               - (alignmentRect.origin.x + alignmentRect.size.width);
  CGSize size = [self.contentView fittingSizeIn:self.superview.bounds.size margins:autoresizingMargins];
  return [self.contentView alignmentRectForFrame:(CGRect){ self.contentView.frame.origin, size }].size;
}

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];

  if (![self isHidden])
    [self.contentView fitInAlignmentRect:[self.contentView alignmentRectForFrame:bounds] margins:self.contentAlignmentMargins];
}

- (void)updateConstraints {
  [self invalidateIntrinsicContentSize];
  [super updateConstraints];
}

- (UIView *)contentView {
  return self.subviews.firstObject;
}

@end

@implementation AutoresizingImageView : UIImageView

- (CGSize)intrinsicContentSize {
  return [self sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize imageSize = [super sizeThatFits:size];

  CGFloat maxWidth = self.preferredMaxLayoutWidth;
  if (maxWidth == CGFLOAT_MIN)
    return CGSizeZero;

  if (size.width)
    if (maxWidth)
      maxWidth = MIN( maxWidth, size.width );
    else
      maxWidth = size.width;
  if (!maxWidth)
    maxWidth = self.bounds.size.width;

  if (maxWidth) {
    CGFloat newWidth = MIN( imageSize.width, maxWidth );
    imageSize.height = imageSize.height * newWidth / imageSize.width;
    imageSize.width = newWidth;
  }

  return imageSize;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
  _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [self invalidateIntrinsicContentSize];
}

@end

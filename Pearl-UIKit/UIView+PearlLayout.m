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

CGRect CGRectInCGSizeWithSizeAndMargins(const CGSize container, CGSize size, UIEdgeInsets margins) {

  if (size.width == CGFLOAT_MAX) {
    if (margins.left == CGFLOAT_MAX && margins.right == CGFLOAT_MAX)
      margins.left = margins.right = size.width = container.width / 3;
    else if (margins.left == CGFLOAT_MAX)
      margins.left = size.width = (container.width - margins.right) / 2;
    else if (margins.right == CGFLOAT_MAX)
      margins.right = size.width = (container.width - margins.left) / 2;
    else
      size.width = container.width - margins.left - margins.right;
  }
  if (size.height == CGFLOAT_MAX) {
    if (margins.top == CGFLOAT_MAX && margins.bottom == CGFLOAT_MAX)
      margins.top = margins.bottom = size.height = container.height / 3;
    else if (margins.top == CGFLOAT_MAX)
      margins.top = size.height = (container.height - margins.bottom) / 2;
    else if (margins.bottom == CGFLOAT_MAX)
      margins.bottom = size.height = (container.height - margins.top) / 2;
    else
      size.height = container.height - margins.top - margins.bottom;
  }
  if (margins.top == CGFLOAT_MAX) {
    if (margins.bottom == CGFLOAT_MAX)
      margins.top = (container.height - size.height) / 2;
    else
      margins.top = container.height - size.height - margins.bottom;
  }
  if (margins.left == CGFLOAT_MAX) {
    if (margins.right == CGFLOAT_MAX)
      margins.left = (container.width - size.width) / 2;
    else
      margins.left = container.width - size.width - margins.right;
  }

  return CGRectFromOriginWithSize( CGPointMake( margins.left, margins.top ), size );
}

UIEdgeInsets UIEdgeInsetsFromCGRectInCGSize(const CGRect rect, const CGSize container) {
  return UIEdgeInsetsMake(
      CGRectGetMinY( rect ), CGRectGetMinX( rect ),
      container.height - CGRectGetMaxY( rect ), container.width - CGRectGetMaxX( rect ) );
}

CGSize CGSizeUnion(const CGSize size1, const CGSize size2) {
  return CGSizeMake( MAX( size1.width, size2.width ), MAX( size1.height, size2.height ) );
}

inline NSString *PearlDescribeF(const CGFloat fl) {
  return fl == CGFLOAT_MIN? @"MIN": fl == CGFLOAT_MAX? @"MAX": isnan( fl )? @"NAN": isinf( fl )? @"INF": strf( @"%.4g", fl );
}

inline NSString *PearlDescribeP(const CGPoint pt) {
  return strf( @"(%@, %@)", PearlDescribeF( pt.x ), PearlDescribeF( pt.y ) );
}

inline NSString *PearlDescribeS(const CGSize sz) {
  return strf( @"(%@x%@)", PearlDescribeF( sz.width ), PearlDescribeF( sz.height ) );
}

inline NSString *PearlDescribeR(const CGRect rct) {
  return strf( @"(%@|%@)", PearlDescribeP( rct.origin ), PearlDescribeS( rct.size ) );
}

inline NSString *PearlDescribeI(const UIEdgeInsets ins) {
  return strf( @"%@|%@[]%@|%@", PearlDescribeF( ins.left ), PearlDescribeF( ins.top ),
      PearlDescribeF( ins.bottom ), PearlDescribeF( ins.right ) );
}

inline NSString *PearlDescribeIS(const UIEdgeInsets ins, const CGSize sz) {
  return strf( @"%@|%@[%@]%@|%@", PearlDescribeF( ins.left ), PearlDescribeF( ins.top ), PearlDescribeS( sz ),
      PearlDescribeF( ins.bottom ), PearlDescribeF( ins.right ) );
}

inline NSString *PearlDescribeO(const UIOffset ofs) {
  return strf( @"(%@|%@)", PearlDescribeF( ofs.horizontal ), PearlDescribeF( ofs.vertical ) );
}


@implementation UIView(PearlLayout)

- (void)setFrameFromCurrentSizeAndAlignmentMargins:(UIEdgeInsets)alignmentMargins {

  [self setFrameFromSize:self.frame.size andAlignmentMargins:alignmentMargins];
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
  trc( @"%@:   setFrameFrom:%@", [self infoPathName], layoutString );

  static NSRegularExpression *layoutRE;
  PearlOnce( ^{
    layoutRE = [[NSRegularExpression alloc] initWithPattern:
            @" *([^\\[| ]*)(?: *\\| *([^\\] ]*))? *\\[ *([\\|]*) *([^\\]\\|/ ]*)(?: */ *([^\\]\\|/ ]*))? *(?:[\\|]*) *\\] *(?:([^|]*) *\\| *)?([^,]*) *"
                                                    options:0 error:nil];
  } );

  // Parse
  NSTextCheckingResult *layoutComponents =
          [layoutRE firstMatchInString:layoutString options:0 range:NSMakeRange( 0, layoutString.length )];
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
  if (layoutOverrides.left != 0)
    leftLayoutValue = layoutOverrides.left;
  if (layoutOverrides.top != 0)
    topLayoutValue = layoutOverrides.top;
  if (layoutOverrides.width != 0)
    widthLayoutValue = layoutOverrides.width;
  if (layoutOverrides.height != 0)
    heightLayoutValue = layoutOverrides.height;
  if (layoutOverrides.bottom != 0)
    bottomLayoutValue = layoutOverrides.bottom;
  if (layoutOverrides.right != 0)
    rightLayoutValue = layoutOverrides.right;

  // Options
  if ([sizeLayoutString rangeOfString:@"|"].location != NSNotFound)
    options |= PearlLayoutOptionConstrained;

  // Left
  if ([leftLayoutString containsString:@"x"])
    leftLayoutValue += x;
  if ([leftLayoutString containsString:@"y"])
    leftLayoutValue += y;
  if ([leftLayoutString containsString:@"z"])
    leftLayoutValue += z;
  if ([leftLayoutString containsString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    leftLayoutValue += self.superview.layoutMargins.left;
  if ([leftLayoutString containsString:@"S"]) {
    if (@available( iOS 11.0, * ))
      leftLayoutValue += UIApp.delegate.window.rootViewController.view.safeAreaInsets.left;
    else
      leftLayoutValue += 0;
  }
  if ([leftLayoutString isEqualToString:@">"])
    leftLayoutValue = CGFLOAT_MAX;
  if ([leftLayoutString isEqualToString:@"="])
    leftLayoutValue = alignmentMargins.left;

    // Right
  if ([rightLayoutString containsString:@"x"])
    rightLayoutValue += x;
  if ([rightLayoutString containsString:@"y"])
    rightLayoutValue += y;
  if ([rightLayoutString containsString:@"z"])
    rightLayoutValue += z;
  if ([rightLayoutString containsString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    rightLayoutValue += self.superview.layoutMargins.right;
  if ([rightLayoutString containsString:@"S"]) {
    if (@available( iOS 11.0, * ))
      rightLayoutValue += UIApp.delegate.window.rootViewController.view.safeAreaInsets.right;
    else
      rightLayoutValue += 0;
  }
  if ([rightLayoutString isEqualToString:@"<"])
    rightLayoutValue = CGFLOAT_MAX;
  if ([rightLayoutString isEqualToString:@"="])
    rightLayoutValue = alignmentMargins.right;

  // Top
  if ([topLayoutString containsString:@"x"])
    topLayoutValue += x;
  if ([topLayoutString containsString:@"y"])
    topLayoutValue += y;
  if ([topLayoutString containsString:@"z"])
    topLayoutValue += z;
  if ([topLayoutString containsString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    topLayoutValue += self.superview.layoutMargins.top;
  if ([topLayoutString containsString:@"S"]) {
    if (@available( iOS 11.0, * ))
      topLayoutValue += UIApp.delegate.window.rootViewController.view.safeAreaInsets.top;
    else
      topLayoutValue += UIApp.statusBarFrame.size.height;
  }
  if ([topLayoutString isEqualToString:@">"])
    topLayoutValue = CGFLOAT_MAX;
  if ([topLayoutString isEqualToString:@"="])
    topLayoutValue = alignmentMargins.top;

  // Bottom
  if ([bottomLayoutString containsString:@"x"])
    bottomLayoutValue += x;
  if ([bottomLayoutString containsString:@"y"])
    bottomLayoutValue += y;
  if ([bottomLayoutString containsString:@"z"])
    bottomLayoutValue += z;
  if ([bottomLayoutString containsString:@"-"] && [self.superview respondsToSelector:@selector( layoutMargins )])
    bottomLayoutValue += self.superview.layoutMargins.bottom;
  if ([bottomLayoutString containsString:@"S"]) {
    if (@available( iOS 11.0, * ))
      bottomLayoutValue += UIApp.delegate.window.rootViewController.view.safeAreaInsets.bottom;
    else
      bottomLayoutValue += 0;
  }
  if ([bottomLayoutString isEqualToString:@"<"])
    bottomLayoutValue = CGFLOAT_MAX;
  if ([bottomLayoutString isEqualToString:@"="])
    bottomLayoutValue = alignmentMargins.bottom;

  // Width
  if ([widthLayoutString containsString:@"x"])
    widthLayoutValue += x;
  if ([widthLayoutString containsString:@"y"])
    widthLayoutValue += y;
  if ([widthLayoutString containsString:@"z"])
    widthLayoutValue += z;
  if ([widthLayoutString containsString:@"-"])
    widthLayoutValue += 44;
  if ([widthLayoutString isEqualToString:@"="])
    widthLayoutValue = alignmentRect.size.width;
  if (!widthLayoutString.length)
    widthLayoutValue = CGFLOAT_MIN;
  if (leftLayoutValue < CGFLOAT_MAX && rightLayoutValue < CGFLOAT_MAX && widthLayoutValue == CGFLOAT_MIN)
    widthLayoutValue = CGFLOAT_MAX;

  // Height
  if ([heightLayoutString containsString:@"x"])
    heightLayoutValue += x;
  if ([heightLayoutString containsString:@"y"])
    heightLayoutValue += y;
  if ([heightLayoutString containsString:@"z"])
    heightLayoutValue += z;
  if ([heightLayoutString containsString:@"-"])
    heightLayoutValue += 44;
  if ([heightLayoutString isEqualToString:@"="])
    heightLayoutValue = alignmentRect.size.height;
  if (!heightLayoutString.length)
    heightLayoutValue = CGFLOAT_MIN;
  if (topLayoutValue < CGFLOAT_MAX && bottomLayoutValue < CGFLOAT_MAX && heightLayoutValue == CGFLOAT_MIN)
    heightLayoutValue = CGFLOAT_MAX;

  // Apply layout
  [self setFrameFromSize:CGSizeMake( widthLayoutValue, heightLayoutValue )
     andAlignmentMargins:UIEdgeInsetsMake( topLayoutValue, leftLayoutValue, bottomLayoutValue, rightLayoutValue ) options:options];
}

- (void)setFrameFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins {

  [self setFrameFromSize:size andAlignmentMargins:alignmentMargins options:PearlLayoutOptionNone];
}

- (void)setFrameFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  trc( @"%@:   setFrameFrom:alignment %@", [self infoPathName], PearlDescribeIS( alignmentMargins, size ) );

  // Save the layout configuration in the autoresizing mask.
  if (0 == (options & PearlLayoutOptionUpdate))
    [self setAutoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options];

  // Determine the size available in the superview for our alignment rect.
  /// fittingSize = The measured size of the alignment rect based on the available space and given margins.
  UIEdgeInsets marginSpace = [self spaceForMargins:alignmentMargins];
  NSValue *savedFittingSize = objc_getAssociatedObject( self, @selector(fittingAlignmentSizeIn:marginSpace:) );
  CGSize fittingSize = savedFittingSize? [savedFittingSize CGSizeValue]:
                       [self fittingAlignmentSizeIn:self.superview.bounds.size marginSpace:marginSpace];

  /// requestedSize = The size we want for this view's alignment rect.  ie. The given size, but no less than the fitting size.
  CGSize requestedSize = CGSizeMake(
      size.width == CGFLOAT_MIN? fittingSize.width: size.width,
      size.height == CGFLOAT_MIN? fittingSize.height: size.height );

  /// requiredSize = The minimum space needed for this view's alignment rect. ie. The requested size, w/MAX minimized to fitting size.
  CGSize requiredSize = CGSizeMake(
      requestedSize.width == CGFLOAT_MAX? fittingSize.width: requestedSize.width,
      requestedSize.height == CGFLOAT_MAX? fittingSize.height: requestedSize.height );

  // Grow the superview if needed to fit the alignment rect and margin.
  CGSize requiredSpace = (CGSize){
      requiredSize.width + marginSpace.left + marginSpace.right,
      requiredSize.height + marginSpace.top + marginSpace.bottom
  };
  CGSize container = CGSizeUnion( self.superview.frame.size, requiredSpace );
  if (self.superview && self.autoresizingMask && !CGSizeEqualToSize( self.superview.frame.size, container )) {
    if (0 == (options & PearlLayoutOptionConstrained)) {
      trc( @"%@:  refitting container %@ => %@", [self infoPathName],
              PearlDescribeS( self.superview.frame.size ), PearlDescribeS( container ) );
//      CGRectSetSize( self.superview.frame, container );
      objc_setAssociatedObject( self.superview, @selector( fittingAlignmentSizeIn:marginSpace: ),
          [NSValue valueWithCGSize:container], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
      CGRect containerRect = [self.superview alignmentRectForFrame:CGRectWithSize( self.superview.frame, container )];
      [self.superview fitInAlignmentRect:containerRect margins:self.superview.alignmentMargins options:PearlLayoutOptionShallow];
      objc_setAssociatedObject( self.superview, @selector( fittingAlignmentSizeIn:marginSpace: ),
          nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }
    else {
      // This warning should never occur.  If it does, the superview was not correctly fitted for this subview: find out why!
      // FIXME: Known causes:
      // FIXME: 1.
      // FIXME: There is an issue when updating a UIStackView inside a UITableViewCellContentView using something like:
      // FIXME: [[UITableView findAsSuperviewOf:self] beginUpdates];
      // FIXME: [self.stackViewChild setNeedsUpdateConstraints];
      // FIXME: [[UITableView findAsSuperviewOf:self] endUpdates];
      // FIXME:
      // FIXME: In this case, iOS correctly requests the new cell size to fit the updated UIStackView from the cell,
      // FIXME: however, it does not resize the cell, and thus the UIStackView, BEFORE running UIStackView's autolayout.
      // FIXME: This causes UIStackView to size its updated children (which depend on the new size) based on its old size.
      // FIXME:
      // FIXME: This can trigger this wrn() when the stackViewChild is squeezed.  After the faulty pass, UITableView
      // FIXME: updates its cell according to the new size and the UIStackView is correctly resized and the error corrected.
      // FIXME:
      // FIXME: To avoid this hiccup, resize the UITableViewCell frame to match as soon as its new content size is determined in
      // FIXME: @selector(systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:)
      // FIXME:
      // FIXME: 2.
      // FIXME: When a non-wrapping (1 line) UILabel inside a UIStackView's AutoresizingContainerView becomes too long to fit the
      // FIXME: container, the intrinsicSize (fittingSize) is cut short by UIStackView.
      // FIXME: This then causes a hard cut-off for the contentView (this view).  This is actually a good thing, but
      // FIXME: ideally we should be able to detect this situation in -fittingSizeIn: and avoid the bad intrinsicSize.
      wrn( @"Container: %@, is not large enough for constrained fit of: %@ (need %@, has %@), layout issues may ensue.",
          [self.superview infoName], [self infoName], NSStringFromCGSize( container ), NSStringFromCGSize( self.superview.frame.size ) );
    }

    container = self.superview.frame.size;
  }

  // Resolve the alignment rect from the requested size and margin, and the frame from the alignment rect.
  CGRect frame = [self frameForAlignmentRect:
      CGRectInCGSizeWithSizeAndMargins( container, requestedSize, alignmentMargins )];
  trc( @"%@:  alignment %@ in container %@ => frame %@", [self infoPathName],
      PearlDescribeIS( alignmentMargins, requestedSize ), PearlDescribeS( container ), PearlDescribeR( frame ) );
  CGRectSet( self.frame, frame );
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

- (UIEdgeInsets)spaceForMargins:(UIEdgeInsets)alignmentMargins {
  // Collapse alignment margins into their fitting space.
  return UIEdgeInsetsMake(
      alignmentMargins.top == CGFLOAT_MAX || alignmentMargins.top == CGFLOAT_MIN? 0: alignmentMargins.top,
      alignmentMargins.left == CGFLOAT_MAX || alignmentMargins.left == CGFLOAT_MIN? 0: alignmentMargins.left,
      alignmentMargins.bottom == CGFLOAT_MAX || alignmentMargins.bottom == CGFLOAT_MIN? 0: alignmentMargins.bottom,
      alignmentMargins.right == CGFLOAT_MAX || alignmentMargins.right == CGFLOAT_MIN? 0: alignmentMargins.right );
}

- (CGSize)fittingAlignmentSizeIn:(CGSize)availableSize marginSpace:(UIEdgeInsets)marginSpace {
  // Convert alignment margins to frame margins.
  CGRect alignmentRect = self.alignmentRect;
  UIEdgeInsets frameMargins = UIEdgeInsetsMake(
      marginSpace.top - (alignmentRect.origin.y - self.frame.origin.y),
      marginSpace.left - (alignmentRect.origin.x - self.frame.origin.x),
      marginSpace.bottom - ((self.frame.origin.y + self.frame.size.height) - (alignmentRect.origin.y + alignmentRect.size.height)),
      marginSpace.right - ((self.frame.origin.x + self.frame.size.width) - (alignmentRect.origin.x + alignmentRect.size.width)) );

  // Find alignment rect fitting the available space and margins.
  availableSize.width -= frameMargins.left + frameMargins.right;
  availableSize.height -= frameMargins.top + frameMargins.bottom;
  CGSize fittingSize = [self fittingSizeIn:availableSize];
  return [self alignmentRectForFrame:(CGRect){ { frameMargins.left, frameMargins.top }, fittingSize }].size;
}

- (CGSize)fittingSizeIn:(CGSize)availableSize {
  // TODO: This method repeats Tn times for a hierarchy n deep.  Can we avoid this or cache results?
//  static NSMutableArray *stack;
//  if (!stack)
//    stack = [NSMutableArray new];
//  [stack addObject:[self infoName]];
//  NSMutableString *string = [NSMutableString new];
//  for (id item in stack)
//    [string appendFormat:@"%@ | ", item];
//  trc( @"fittingSizeIn: %@", string );

  // Determine how the view wants to fit in the available space.
  CGSize fittingSize = [self ownFittingSizeIn:availableSize];
  trc( @"%@:   own fitting size: %@", [self infoPathName], PearlDescribeS( fittingSize ) );

  // Grow to fit our autoresizing subviews.  Other subviews were handled by -systemLayoutSizeFittingSize.
  if (self.autoresizesSubviews)
    for (UIView *subview in self.subviews)
      if (subview.autoresizingMask) {
        UIEdgeInsets marginSpace = subview.autoresizingMargins, alignmentSpace = subview.alignmentMargins;
        if ([subview hasAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | PearlAutoresizingMinimalLeftMargin])
          marginSpace.left -= alignmentSpace.left;
        if ([subview hasAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | PearlAutoresizingMinimalRightMargin])
          marginSpace.right -= alignmentSpace.right;
        if ([subview hasAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | PearlAutoresizingMinimalTopMargin])
          marginSpace.top -= alignmentSpace.top;
        if ([subview hasAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | PearlAutoresizingMinimalBottomMargin])
          marginSpace.bottom -= alignmentSpace.bottom;

        CGSize availableSubviewSize = availableSize;
        availableSubviewSize.width -= marginSpace.left + marginSpace.right;
        availableSubviewSize.height -= marginSpace.top + marginSpace.bottom;

        CGSize subviewSize = [subview fittingSizeIn:availableSubviewSize];
        CGSize subviewSpace = CGSizeMake(
            subviewSize.width + marginSpace.left + marginSpace.right,
            subviewSize.height + marginSpace.top + marginSpace.bottom );
        trc( @"%@:     %@ space: %@ => %@", [self infoPathName], [subview infoShortName],
            PearlDescribeIS( marginSpace, subviewSize ), PearlDescribeS( subviewSpace ) );

        fittingSize = CGSizeUnion( fittingSize, subviewSpace );
      }

  trc( @"%@:   final fitting size: %@", [self infoPathName], PearlDescribeS( fittingSize ) );
//  [stack removeLastObject];
  return fittingSize;
}

- (CGSize)ownFittingSizeIn:(CGSize)availableSize {
  // Not entirely sure why; some long UILabels do not limit on fittingSize properly without assigning its width to preferredMaxLayoutWidth.
  [self assignPreferredMaxLayoutWidth:availableSize];

  // Some objects need to know the availableSize when determining intrinsicContentSize in response to this call.
  // I would prefer it if they could determine this size by looking at the available constraints, but unfortunately
  // systemLayoutSizeFittingSize: doesn't expose its fitting size this or any other way that I could find.
  NSValue *superAvailableSize = objc_getAssociatedObject( [UIView class], @selector( ownFittingSizeIn: ) );
  objc_setAssociatedObject( [UIView class], @selector( ownFittingSizeIn: ),
      [NSValue valueWithCGSize:availableSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC );

  // Measure our fitting size within availableSize.
  // We bias/favour width fitting to height fitting to size multi-line UILabels right.
  CGSize fittingSize = [self systemLayoutSizeFittingSize:availableSize
                           withHorizontalFittingPriority:[self hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]?
                                                         UILayoutPriorityDefaultHigh + 1: UILayoutPriorityFittingSizeLevel
                                 verticalFittingPriority:[self hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]?
                                                         UILayoutPriorityDefaultLow: UILayoutPriorityFittingSizeLevel];

  // Fix float errors that cause a mismatch with availableSize bounds, because UIKit's sizers are terrible.
  if (ABS(fittingSize.width - availableSize.width) <= FLT_EPSILON)
    fittingSize.width = availableSize.width;
  if (ABS(fittingSize.height - availableSize.height) <= FLT_EPSILON)
    fittingSize.height = availableSize.height;

  // Clear availableSize records.
  objc_setAssociatedObject( [UIView class], @selector( ownFittingSizeIn: ),
      superAvailableSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
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
  return [self fitInAlignmentRect:self.alignmentRect margins:self.alignmentMargins options:PearlLayoutOptionConstrained];
}

- (BOOL)fitInAlignmentRect:(CGRect)alignmentRect margins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  CGRect oldBounds = self.bounds;

  // Recalculate the view's fitting size based on its autoresizing configuration.
  [self setFrameFromSize:CGSizeMake(
          [self hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]? CGFLOAT_MAX:
          [self hasAutoresizingMask:PearlAutoresizingMinimalWidth] || !self.autoresizingMask? CGFLOAT_MIN: alignmentRect.size.width,
          [self hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]? CGFLOAT_MAX:
          [self hasAutoresizingMask:PearlAutoresizingMinimalHeight] || !self.autoresizingMask? CGFLOAT_MIN: alignmentRect.size.height )
     andAlignmentMargins:UIEdgeInsetsMake(
         [self hasAutoresizingMask:UIViewAutoresizingFlexibleTopMargin]? CGFLOAT_MAX:
         [self hasAutoresizingMask:PearlAutoresizingMinimalTopMargin]? CGFLOAT_MIN: alignmentMargins.top,
         [self hasAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin]? CGFLOAT_MAX:
         [self hasAutoresizingMask:PearlAutoresizingMinimalLeftMargin]? CGFLOAT_MIN: alignmentMargins.left,
         [self hasAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin]? CGFLOAT_MAX:
         [self hasAutoresizingMask:PearlAutoresizingMinimalBottomMargin]? CGFLOAT_MIN: alignmentMargins.bottom,
         [self hasAutoresizingMask:UIViewAutoresizingFlexibleRightMargin]? CGFLOAT_MAX:
         [self hasAutoresizingMask:PearlAutoresizingMinimalRightMargin]? CGFLOAT_MIN: alignmentMargins.right )
                 options:options | PearlLayoutOptionUpdate];

  // Update fitting size for the subviews that are positioned by autoresizing.  Other subviews are handled by -layoutSubviews.
  if (0 == (options & PearlLayoutOptionShallow))
    for (UIView *subview in self.subviews) {
      if (self.autoresizesSubviews && subview.autoresizingMask)
        [subview fitSubviews];
      else
        [subview setNeedsLayout];
    }

  BOOL changed = !CGRectEqualToRect( self.bounds, oldBounds );
//  if (changed)
//    // FIXME: Breaks UITableView scrolling, unsure of why yet.
//    [self setNeedsUpdateConstraints];
//  if (changed) {
//    // FIXME: Does not coalesce multiple changes to a cell properly, only do -endUpdates after all updates have been performed.
//    [[UITableView findAsSuperviewOf:self] beginUpdates];
//    [self setNeedsUpdateConstraints];
//    [[UITableView findAsSuperviewOf:self] endUpdates];
//  }
  return changed;
}

- (void)assignPreferredMaxLayoutWidth:(CGSize)availableSize {
  if ([self respondsToSelector:@selector( preferredMaxLayoutWidth )] &&
      [self respondsToSelector:@selector( setPreferredMaxLayoutWidth: )]) {
    int assignDepth = [objc_getAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ) ) intValue];

    if (!assignDepth) {
      CGFloat currentValue = [(UILabel *)self preferredMaxLayoutWidth];
      if (currentValue == 0) {
        [(UILabel *)self setPreferredMaxLayoutWidth:availableSize.width];
        objc_setAssociatedObject( self, @selector( resetPreferredMaxLayoutWidth ), @(currentValue), OBJC_ASSOCIATION_RETAIN );
      }
    }

    objc_setAssociatedObject( self, @selector( assignPreferredMaxLayoutWidth: ), @(++assignDepth), OBJC_ASSOCIATION_RETAIN );
  }
}

- (void)resetPreferredMaxLayoutWidth {
  if ([self respondsToSelector:@selector( preferredMaxLayoutWidth )] &&
      [self respondsToSelector:@selector( setPreferredMaxLayoutWidth: )]) {
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
}

- (void)setAutoresizingMaskFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  UIViewAutoresizing mask = (UIViewAutoresizing)(
      (alignmentMargins.top == CGFLOAT_MAX? UIViewAutoresizingFlexibleTopMargin:
       alignmentMargins.top == CGFLOAT_MIN? PearlAutoresizingMinimalTopMargin: 0) |
      (alignmentMargins.right == CGFLOAT_MAX? UIViewAutoresizingFlexibleRightMargin:
       alignmentMargins.right == CGFLOAT_MIN? PearlAutoresizingMinimalRightMargin: 0) |
      (alignmentMargins.bottom == CGFLOAT_MAX? UIViewAutoresizingFlexibleBottomMargin:
       alignmentMargins.bottom == CGFLOAT_MIN? PearlAutoresizingMinimalBottomMargin: 0) |
      (alignmentMargins.left == CGFLOAT_MAX? UIViewAutoresizingFlexibleLeftMargin:
       alignmentMargins.left == CGFLOAT_MIN? PearlAutoresizingMinimalLeftMargin: 0) |
      (size.width == CGFLOAT_MAX? UIViewAutoresizingFlexibleWidth:
       size.width == CGFLOAT_MIN? PearlAutoresizingMinimalWidth: 0) |
      (size.height == CGFLOAT_MAX? UIViewAutoresizingFlexibleHeight:
       size.height == CGFLOAT_MIN? PearlAutoresizingMinimalHeight: 0));

  [self setContentHuggingPriority:size.width == CGFLOAT_MAX? UILayoutPriorityDefaultLow: UILayoutPriorityDefaultHigh
                          forAxis:UILayoutConstraintAxisHorizontal];
  [self setContentHuggingPriority:size.height == CGFLOAT_MAX? UILayoutPriorityDefaultLow: UILayoutPriorityDefaultHigh
                          forAxis:UILayoutConstraintAxisVertical];

  objc_setAssociatedObject( self, @selector( setAutoresizingMaskFromSize:andAlignmentMargins:options: ),
      @(mask), OBJC_ASSOCIATION_RETAIN );
  self.autoresizingMask = mask;

  [self.superview didSetSubview:self autoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options];
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
  andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
}

- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask {
  return 0 != (mask & [objc_getAssociatedObject( self, @selector( setAutoresizingMaskFromSize:andAlignmentMargins:options: ) )
                       ?: @(self.autoresizingMask) unsignedLongValue]);
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

+ (instancetype)viewWithContent:(UIView *)view {
  return [[self alloc] initWithContent:view];
}

- (instancetype)initWithContent:(UIView *)contentView {
  if (!(self = [self initWithFrame:(CGRect){
      CGPointZero, [contentView alignmentRectForFrame:
          CGRectWithSize( contentView.frame, [contentView fittingSizeIn:CGSizeZero] )].size
  }]))
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
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalWidth]? UILayoutPriorityDefaultHigh:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleWidth]? UILayoutPriorityDefaultLow: UILayoutPriorityRequired
                            forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:
            [self.contentView hasAutoresizingMask:PearlAutoresizingMinimalHeight]? UILayoutPriorityDefaultHigh:
            [self.contentView hasAutoresizingMask:UIViewAutoresizingFlexibleHeight]? UILayoutPriorityDefaultLow: UILayoutPriorityRequired
                            forAxis:UILayoutConstraintAxisVertical];
  }];

  return self;
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
  andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  if (subview == self.contentView)
    self.contentAlignmentMargins = alignmentMargins;
}

- (BOOL)fitSubviews {
  // Don't blindly trust `bounds` in case autolayout tries to squash our view; use fittingAlignmentSize instead (via intrinsicContentSize)
  return [self.contentView fitInAlignmentRect:(CGRect){ CGPointZero, self.intrinsicContentSize } margins:self.contentAlignmentMargins
                                      options:PearlLayoutOptionConstrained];
}

- (CGSize)intrinsicContentSize {

  UIEdgeInsets marginSpace = [self spaceForMargins:self.contentAlignmentMargins];
  NSValue *availableSizeValue = objc_getAssociatedObject( [UIView class], @selector( ownFittingSizeIn: ) );
  CGSize availableSize = availableSizeValue? [availableSizeValue CGSizeValue]: self.superview.bounds.size;
  CGSize contentSize = [self.contentView fittingAlignmentSizeIn:availableSize marginSpace:marginSpace];

  return CGSizeMake( contentSize.width + marginSpace.left + marginSpace.right, contentSize.height + marginSpace.top + marginSpace.bottom );
}

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];

  if (![self isHidden])
    [self fitSubviews];
}

- (void)updateConstraints {
  [self invalidateIntrinsicContentSize];
  [super updateConstraints];
}

- (UIView *)contentView {
  return self.subviews.firstObject;
}

- (NSString *)infoName {
  return strf( @"%@ for %@", PearlDescribeC( [self class] ), [self.contentView infoShortName] );
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

  if (size.width != 0) {
    if (maxWidth != 0)
      maxWidth = MIN( maxWidth, size.width );
    else
      maxWidth = size.width;
  }
  if (maxWidth == 0)
    maxWidth = self.bounds.size.width;

  if (maxWidth != 0) {
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

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
}

@end

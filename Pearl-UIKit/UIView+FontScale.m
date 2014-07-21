//
// Created by Maarten Billemont on 2014-07-18.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+FontScale.h"
#import "CMHRStore.h"


@implementation UIView(FontScale)

- (void)scaleFonts:(float)fontScale {
  // Scale fonts in this view.
  if (![self _scaleMyFonts:fontScale])
    return;

  for (UIView *view in self.subviews)
    [view scaleFonts:fontScale];
}

/** Override me on custom controls that need to scale their text, return NO if subviews shouldn't be scaled. */
- (BOOL)_scaleMyFonts:(float)scale {
  return YES;
}

@end

@implementation UILabel(FontScale)

- (BOOL)_scaleMyFonts:(float)scale {
  self.font = [self.font fontWithSize:self.font.pointSize * scale];
  return [super _scaleMyFonts:scale];
}

@end

@implementation UITextField(FontScale)

- (BOOL)_scaleMyFonts:(float)scale {
  self.font = [self.font fontWithSize:self.font.pointSize * scale];
  return [super _scaleMyFonts:scale];
}

@end

@implementation UITextView(FontScale)

- (BOOL)_scaleMyFonts:(float)scale {
  self.font = [self.font fontWithSize:self.font.pointSize * scale];
  return [super _scaleMyFonts:scale];
}

@end

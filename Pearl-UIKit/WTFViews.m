//
// Created by Maarten Billemont on 2017-12-11.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "WTFViews.h"

@implementation WTFView

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
}

- (BOOL)needsUpdateConstraints {
  return [super needsUpdateConstraints];
}

- (void)setNeedsUpdateConstraints {
  [super setNeedsUpdateConstraints];
}

@end

@implementation WTFStackView

- (BOOL)needsUpdateConstraints {
  return [super needsUpdateConstraints];
}

- (void)setNeedsUpdateConstraints {
  [super setNeedsUpdateConstraints];
}

@end


//
// Created by Maarten Billemont on 2017-12-11.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "WTFViews.h"

@interface UIView (PearlLayout_Private)

- (UIEdgeInsets)spaceForMargins:(UIEdgeInsets)alignmentMargins;

- (CGSize)fittingAlignmentSizeIn:(CGSize)availableSize marginSpace:(UIEdgeInsets)marginSpace;

- (CGSize)ownFittingSizeIn:(CGSize)availableSize;

- (BOOL)fitInAlignmentRect:(CGRect)alignmentRect margins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options;

- (void)assignPreferredMaxLayoutWidth:(CGSize)availableSize;

- (void)resetPreferredMaxLayoutWidth;

- (void)setAutoresizingMaskFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options;

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
  andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options;

@end

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

@implementation WTFLabel

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

- (CGSize)sizeThatFits:(CGSize)targetSize {
  CGSize size = [super sizeThatFits:targetSize];
  return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
  CGSize size = [super systemLayoutSizeFittingSize:targetSize];
  return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
  CGSize size = [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
  return size;
}

- (CGSize)minimumAutoresizingSize {
  CGSize size = [super minimumAutoresizingSize];
  return size;
}

- (UIEdgeInsets)spaceForMargins:(UIEdgeInsets)alignmentMargins {
  UIEdgeInsets insets = [super spaceForMargins:alignmentMargins];
  return insets;
}

- (CGSize)fittingAlignmentSizeIn:(CGSize)availableSize marginSpace:(UIEdgeInsets)marginSpace {
  CGSize size = [super fittingAlignmentSizeIn:availableSize marginSpace:marginSpace];
  return size;
}

- (CGSize)fittingSizeIn:(CGSize)availableSize {
  CGSize size = [super fittingSizeIn:availableSize];
  return size;
}

- (CGSize)ownFittingSizeIn:(CGSize)availableSize {
  CGSize size = [super ownFittingSizeIn:availableSize];
  return size;
}

- (BOOL)fitSubviews {
  return [super fitSubviews];
}

- (BOOL)fitInAlignmentRect:(CGRect)alignmentRect margins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  return [super fitInAlignmentRect:alignmentRect margins:alignmentMargins options:options];
}

- (void)assignPreferredMaxLayoutWidth:(CGSize)availableSize {
  [super assignPreferredMaxLayoutWidth:availableSize];
}

- (void)resetPreferredMaxLayoutWidth {
  [super resetPreferredMaxLayoutWidth];
}

- (void)setAutoresizingMaskFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  [super setAutoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options];
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
  andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  [super didSetSubview:subview autoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options]; 
}

- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask {
  return [super hasAutoresizingMask:mask];
}

@end

@implementation WTFAutoresizingContainerView

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
  [super willMoveToWindow:newWindow];
}

- (void)didMoveToWindow {
  [super didMoveToWindow];
}

- (void)layoutMarginsDidChange {
  [super layoutMarginsDidChange];
}

- (void)safeAreaInsetsDidChange {
  [super safeAreaInsetsDidChange];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
}

- (void)tintColorDidChange {
  [super tintColorDidChange];
}

- (void)setNeedsLayout {
  [super setNeedsLayout];
}

- (void)layoutIfNeeded {
  [super layoutIfNeeded];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

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

- (void)updateConstraintsIfNeeded {
  [super updateConstraintsIfNeeded];
}

- (void)updateConstraints {
  [super updateConstraints];
}

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  return size;
}

- (CGSize)sizeThatFits:(CGSize)targetSize {
  CGSize size = [super sizeThatFits:targetSize];
  return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
  CGSize size = [super systemLayoutSizeFittingSize:targetSize];
  return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
  CGSize size = [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
  return size;
}

- (CGSize)minimumAutoresizingSize {
  CGSize size = [super minimumAutoresizingSize];
  return size;
}

- (UIEdgeInsets)spaceForMargins:(UIEdgeInsets)alignmentMargins {
  UIEdgeInsets insets = [super spaceForMargins:alignmentMargins];
  return insets;
}

- (CGSize)fittingAlignmentSizeIn:(CGSize)availableSize marginSpace:(UIEdgeInsets)marginSpace {
  CGSize size = [super fittingAlignmentSizeIn:availableSize marginSpace:marginSpace];
  return size;
}

- (CGSize)fittingSizeIn:(CGSize)availableSize {
  CGSize size = [super fittingSizeIn:availableSize];
  return size;
}

- (CGSize)ownFittingSizeIn:(CGSize)availableSize {
  CGSize size = [super ownFittingSizeIn:availableSize];
  return size;
}

- (BOOL)fitSubviews {
  return [super fitSubviews];
}

- (BOOL)fitInAlignmentRect:(CGRect)alignmentRect margins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  return [super fitInAlignmentRect:alignmentRect margins:alignmentMargins options:options];
}

- (void)assignPreferredMaxLayoutWidth:(CGSize)availableSize {
  [super assignPreferredMaxLayoutWidth:availableSize];
}

- (void)resetPreferredMaxLayoutWidth {
  [super resetPreferredMaxLayoutWidth];
}

- (void)setAutoresizingMaskFromSize:(CGSize)size andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  [super setAutoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options];
}

- (void)didSetSubview:(UIView *)subview autoresizingMaskFromSize:(CGSize)size
  andAlignmentMargins:(UIEdgeInsets)alignmentMargins options:(PearlLayoutOption)options {
  [super didSetSubview:subview autoresizingMaskFromSize:size andAlignmentMargins:alignmentMargins options:options];
}

- (BOOL)hasAutoresizingMask:(UIViewAutoresizing)mask {
  return [super hasAutoresizingMask:mask];
}

@end

@implementation WTFStackView

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

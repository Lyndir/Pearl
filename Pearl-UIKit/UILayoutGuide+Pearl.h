//
// Created by Maarten Billemont on 2018-03-11.
// Copyright (c) 2018 Lyndir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILayoutGuide(Pearl)

+ (__nullable instancetype)installKeyboardLayoutGuideInView:(UIView *__nonnull)view constraints:
        (NSArray <NSLayoutConstraint *> *__nonnull ( ^ __nonnull )(UILayoutGuide *__nonnull keyboardLayoutGuide))block;

- (void)uninstallKeyboardLayoutGuide;

@end

//
// Created by Maarten Billemont on 2018-03-11.
// Copyright (c) 2018 Lyndir. All rights reserved.
//

#import "UILayoutGuide+Pearl.h"

@implementation UILayoutGuide(Pearl)

+ (instancetype)installKeyboardLayoutGuideInView:(UIView *)view
                                     constraints:(NSArray <NSLayoutConstraint *> *( ^ )(UILayoutGuide *keyboardLayoutGuide))block {

    UILayoutGuide *layoutGuide = [self new];
    layoutGuide.identifier = @"PearlKeyboardLayoutGuide";
    [view addLayoutGuide:layoutGuide];

    NSLayoutConstraint *keyboardTopConstraint = [[layoutGuide.topAnchor constraintEqualToAnchor:view.topAnchor] activate];
    NSLayoutConstraint *keyboardLeftConstraint = [[layoutGuide.leftAnchor constraintEqualToAnchor:view.leftAnchor] activate];
    NSLayoutConstraint *keyboardRightConstraint = [[layoutGuide.rightAnchor constraintEqualToAnchor:view.rightAnchor] activate];
    NSLayoutConstraint *keyboardBottomConstraint = [[layoutGuide.bottomAnchor constraintEqualToAnchor:view.bottomAnchor] activate];
    NSArray *layoutConstraints = block( layoutGuide );

    PearlAddNotificationObserverTo( layoutGuide, UIKeyboardWillChangeFrameNotification, nil, NSOperationQueue.mainQueue,
            ^(UILayoutGuide *layoutGuide, NSNotification *notification) {
                CGRect keyboardScreenFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                CGRect keyboardFrame = [view convertRect:keyboardScreenFrame fromCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
                keyboardTopConstraint.constant = CGRectGetMinY( keyboardFrame );
                keyboardLeftConstraint.constant = CGRectGetMinX( keyboardFrame );
                keyboardRightConstraint.constant = CGRectGetMaxX( keyboardFrame ) - CGRectGetMaxX( view.bounds );
                keyboardBottomConstraint.constant = CGRectGetMaxY( keyboardFrame ) - CGRectGetMaxY( view.bounds );
            } );
    PearlAddNotificationObserverTo( layoutGuide, UIKeyboardWillShowNotification, nil, NSOperationQueue.mainQueue,
            ^(UILayoutGuide *layoutGuide, NSNotification *notification) {
                NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]?: @0.3 doubleValue];
                [view layoutIfNeeded];
                [UIView animateWithDuration:duration animations:^{
                    for (NSLayoutConstraint *constraint in layoutConstraints)
                        [constraint activate];
                    [view layoutIfNeeded];
                }];
            } );
    PearlAddNotificationObserverTo( layoutGuide, UIKeyboardWillHideNotification, nil, NSOperationQueue.mainQueue,
            ^(UILayoutGuide *layoutGuide, NSNotification *notification) {
                NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]?: @0.3 doubleValue];
                [view layoutIfNeeded];
                [UIView animateWithDuration:duration animations:^{
                    for (NSLayoutConstraint *constraint in layoutConstraints)
                        [constraint deactivate];
                    [view layoutIfNeeded];
                }];
            } );

    return layoutGuide;
}

- (void)uninstallKeyboardLayoutGuide {
    PearlRemoveNotificationObserversFrom( self );
}

@end

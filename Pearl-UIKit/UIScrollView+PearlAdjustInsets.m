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
//  UIScrollView(PearlAdjustInsets).h
//  UIScrollView(PearlAdjustInsets)
//
//  Created by lhunath on 2014-03-22.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "UIScrollView+PearlAdjustInsets.h"

@implementation UIScrollView(PearlAdjustInsets)

- (void)automaticallyAdjustInsetsForKeyboard {

    Weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:
            ^(NSNotification *note) {
                Strongify(self);

                CGRect frameFromScreen = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                CGRect frameToScreen = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                CGRect frameFrom = [self convertRect:[self.window convertRect:frameFromScreen fromWindow:nil] fromView:self.window];
                CGRect frameTo = [self convertRect:[self.window convertRect:frameToScreen fromWindow:nil] fromView:self.window];
                UIEdgeInsets insetsFrom = UIEdgeInsetsForRectSubtractingRect( self.bounds, frameFrom );
                UIEdgeInsets insetsTo = UIEdgeInsetsForRectSubtractingRect( self.bounds, frameTo );

                self.contentInset = insetsFrom;
                [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0
                                    options:UIViewAnimationCurveToOptions( [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] )
                                 animations:^{ self.contentInset = insetsTo; } completion:nil];
            }];
}

@end

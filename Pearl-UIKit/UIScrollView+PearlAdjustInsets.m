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

#import <UIKit/UIKit.h>

@implementation UIScrollView(PearlAdjustInsets)

- (id)automaticallyAdjustInsetsForKeyboard {

    Weakify( self );
    UIEdgeInsets originalInsets = self.contentInset;
    return [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:
            ^(NSNotification *note) {
        Strongify( self );

        CGRect frameFromScreen = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect frameToScreen = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect frameFrom = [self convertRect:[self.window convertRect:frameFromScreen fromWindow:nil] fromView:self.window];
        CGRect frameTo = [self convertRect:[self.window convertRect:frameToScreen fromWindow:nil] fromView:self.window];
        UIEdgeInsets insetsFrom = UIEdgeInsetsUnionEdgeInsets( originalInsets,
                UIEdgeInsetsForRectSubtractingRect( self.bounds, frameFrom ) );
        UIEdgeInsets insetsTo = UIEdgeInsetsUnionEdgeInsets( originalInsets,
                UIEdgeInsetsForRectSubtractingRect( self.bounds, frameTo ) );



        self.contentInset = insetsFrom;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0
                            options:UIViewAnimationCurveToOptions( [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] )
                         animations:^{ self.contentInset = insetsTo; } completion:nil];
    }];
}

- (void)insetOcclusion {

    self.contentInset = UIEdgeInsetsUnionEdgeInsets( self.contentInset, [self occludedInsets] );
}

- (UIEdgeInsets)occludedInsets {

    UIEdgeInsets insets = UIEdgeInsetsZero;
    for (UIView *view = self, *superview = [view superview]; superview; view = superview, superview = [view superview])
        for (NSUInteger c = [[superview subviews] indexOfObject:view] + 1; c < [[superview subviews] count]; ++c) {
            UIView *occludingView = [superview subviews][c];
            if (occludingView.hidden || !occludingView.alpha)
                continue;

            CGRect occludingRect = [self convertRect:occludingView.frame fromView:superview];
            UIEdgeInsets occludingInsets = UIEdgeInsetsForRectSubtractingRect( self.bounds, occludingRect );
            insets = UIEdgeInsetsUnionEdgeInsets( insets, occludingInsets );
        }

    return insets;
}

@end

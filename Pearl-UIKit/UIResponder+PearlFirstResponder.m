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
//  UIResponder(PearlFirstResponder).h
//  UIResponder(PearlFirstResponder)
//
//  Created by lhunath on 2014-04-10.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "UIResponder+PearlFirstResponder.h"

static __weak UIResponder *_currentFirstResponder;

@implementation UIResponder(PearlFirstResponder)

+ (UIResponder *)findFirstResponder {

    @synchronized ([UIResponder class]) {
        _currentFirstResponder = nil;
        // Sending an action to nil causes the first responder to handle it, if there is one.
        [[UIApplication sharedApplication] sendAction:@selector(updateCurrentFirstResponder:) to:nil from:nil forEvent:nil];

        return _currentFirstResponder;
    }
}

- (void)updateCurrentFirstResponder:(id)sender {

    _currentFirstResponder = self;
}

@end

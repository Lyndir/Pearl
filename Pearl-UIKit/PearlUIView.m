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
//  PearlUIView.h
//  PearlUIView
//
//  Created by lhunath on 2014-03-17.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "PearlUIView.h"

@implementation PearlUIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *hitView = [super hitTest:point withEvent:event];
    if (self.ignoreTouches && hitView == self)
        return nil;

    return hitView;
}

/** Unblocks animations for all CALayer properties (eg. shadowOpacity) */
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {

    return NSNullToNil([super actionForLayer:layer forKey:event]);
}

@end

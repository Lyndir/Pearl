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
//  UIView+Touches.h
//  UIView+Touches
//
//  Created by lhunath on 2014-03-17.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "UIView+Touches.h"

@implementation UIView(Touches)

- (BOOL)ignoreTouches {
    return [objc_getAssociatedObject( self, @selector( ignoreTouches ) ) boolValue];
}

- (void)setIgnoreTouches:(BOOL)ignoreTouches {

    objc_setAssociatedObject( self, @selector( ignoreTouches ), @(ignoreTouches), OBJC_ASSOCIATION_RETAIN );
    PearlSwizzle( UIView, @selector( hitTest:withEvent: ), UIView *, {
        UIView *hitView = orig( self, sel, point, event );
        if (self.ignoreTouches && hitView == self)
            return nil;
        return hitView;
    }, CGPoint point, UIEvent *event );
}

- (BOOL)alignmentTouches {
    return [objc_getAssociatedObject( self, @selector( alignmentTouches ) ) boolValue];
}

- (void)setAlignmentTouches:(BOOL)alignmentTouches {
    objc_setAssociatedObject( self, @selector( alignmentTouches ), @(alignmentTouches), OBJC_ASSOCIATION_RETAIN );
    PearlSwizzle( UIView, @selector( pointInside:withEvent: ), BOOL, {
        if (self.alignmentTouches)
            return CGRectContainsPoint( [self alignmentRectForFrame:self.bounds], point );

        return orig( self, sel, point, event );
    }, CGPoint point, UIEvent *event );
}

@end

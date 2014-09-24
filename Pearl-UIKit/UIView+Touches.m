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
#import "JRSwizzle.h"

@interface NSObject(Touches_JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;

@end

#pragma clang diagnostic push
#pragma ide diagnostic ignored "InfiniteRecursion"

@implementation UIView(Touches)

static char *PearlIgnoreTouches;

- (void)setIgnoreTouches:(BOOL)ignoreTouches {

    objc_setAssociatedObject( self, &PearlIgnoreTouches, @(ignoreTouches), OBJC_ASSOCIATION_RETAIN );

    static dispatch_once_t once = 0;
    dispatch_once( &once, ^{
        NSError *error;
        if (![UIView jr_swizzleMethod:@selector( hitTest:withEvent: ) withMethod:@selector( pearl_hitTest:withEvent: ) error:&error])
            err( @"Failed to swizzle hitTest:withEvent:.  ignoreTouches will have no effect.  Cause: %@", [error fullDescription] );
    } );
}

- (BOOL)ignoreTouches {

    return [objc_getAssociatedObject( self, &PearlIgnoreTouches ) boolValue];
}

- (UIView *)pearl_hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *hitView = [self pearl_hitTest:point withEvent:event];
    if (self.ignoreTouches && hitView == self)
        return nil;

    return hitView;
}

@end

#pragma clang diagnostic pop

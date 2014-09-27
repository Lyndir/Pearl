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
//  NSNotificationCenter(PearlEasyCleanup).h
//  NSNotificationCenter(PearlEasyCleanup)
//
//  Created by lhunath on 2014-09-26.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

static char NotificationObserversKey;

#define PearlAddNotificationObserver(_name, _object, _queue, _block) \
    ( { \
        __weak typeof(self) wSelf = self; \
        void (^__noteblock)(id self, NSNotification *note) = _block; \
        NSMutableArray *notificationObservers = objc_getAssociatedObject( self, &NotificationObserversKey ); \
        if (!notificationObservers) \
            objc_setAssociatedObject( self, &NotificationObserversKey, \
                    notificationObservers = [NSMutableArray array], OBJC_ASSOCIATION_RETAIN ); \
        [notificationObservers addObject:[[NSNotificationCenter defaultCenter] \
                addObserverForName:(_name) object:(_object) queue:(_queue) usingBlock:^(NSNotification *note) { \
            __noteblock(note, wSelf); \
        }] ]; \
    } )

#define PearlRemoveNotificationObservers() \
    ( { \
        NSMutableArray *notificationObservers = objc_getAssociatedObject( self, &NotificationObserversKey ); \
        for (id notificationObserver in notificationObservers) \
            [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver]; \
        objc_setAssociatedObject( self, &NotificationObserversKey, nil, OBJC_ASSOCIATION_RETAIN ); \
    } )

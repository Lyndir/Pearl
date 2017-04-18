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

/** Observe the given notification on the given object using the given block, optionally scheduled on the given queue.
 *  By default, 'self' retains the notification observer and is passed in as the first argument to the block
 *  to help you avoid a cyclic reference to it.
 * @param _block A block of type `^(id host, NSNotification *note)` invoked when the notification is fired.
 * @return The opaque observer instance needed for manually unregistering it or nil if the notification is not supported on the current OS. */
#define PearlAddNotificationObserver(_name, _object, _queue, _block) \
    PearlAddNotificationObserverTo( self, _name, _object, _queue, _block )
#define PearlAddNotificationObserverTo(_host, _name, _object, _queue, _block) \
    ( { \
        id observer = nil; \
        if (&_name) { \
            __weak typeof(_host) wHost = _host; \
            void (^__noteblock)(id _self, NSNotification *note) = _block; \
            NSMutableArray *notificationObservers = objc_getAssociatedObject( _host, &NotificationObserversKey ); \
            if (!notificationObservers) \
                objc_setAssociatedObject( _host, &NotificationObserversKey, \
                        notificationObservers = [NSMutableArray array], OBJC_ASSOCIATION_RETAIN ); \
            observer = [[NSNotificationCenter defaultCenter] \
                    addObserverForName:(_name) object:(_object) queue:(_queue) usingBlock:^(NSNotification *note) { \
                        __noteblock(wHost, note); \
                    }]; \
            [notificationObservers addObject:observer]; \
        } \
        observer; \
    } )

/** Remove all notifications registered using the method above with 'self' as the host. */
#define PearlRemoveNotificationObservers() PearlRemoveNotificationObserversFrom( self );
#define PearlRemoveNotificationObserversFrom(_host) \
    ( { \
        NSMutableArray *notificationObservers = objc_getAssociatedObject( _host, &NotificationObserversKey ); \
        for (id notificationObserver in notificationObservers) \
            [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver]; \
        objc_setAssociatedObject( _host, &NotificationObserversKey, nil, OBJC_ASSOCIATION_RETAIN ); \
    } )

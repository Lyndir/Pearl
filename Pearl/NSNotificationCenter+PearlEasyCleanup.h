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
 *  You can safely repeat this method, it will remove the old observer for the name before adding the new one.
 * @param _block A block of type `^(id host, NSNotification *note)` invoked when the notification is fired.
 * @return The opaque observer instance needed for manually unregistering it or nil if the notification is not supported on the current OS. */
#define PearlAddNotificationObserver(_name, _object, _queue, _block) \
    PearlAddNotificationObserverTo( self, _name, _object, _queue, _block )
#define PearlAddNotificationObserverTo(_host, _name, _object, _queue, _block) \
    ( { \
        id observer = nil; \
        if (&_name) { \
            __weak __typeof(_host) wHost = _host; \
            void (^__noteblock)(id _self, NSNotification *note) = (_block); \
            NSMutableDictionary *notificationObservers = objc_getAssociatedObject( _host, &NotificationObserversKey ); \
            if (!notificationObservers) \
                objc_setAssociatedObject( _host, &NotificationObserversKey, \
                        notificationObservers = [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN ); \
            observer = notificationObservers[(_name)]; \
            if (observer) \
                [[NSNotificationCenter defaultCenter] removeObserver:observer name:(_name) object:nil]; \
            observer = [[NSNotificationCenter defaultCenter] \
                    addObserverForName:(_name) object:(_object) queue:(_queue) usingBlock:^(NSNotification *note) { \
                        if (wHost) \
                            __noteblock(wHost, note); \
                        else \
                            [[NSNotificationCenter defaultCenter] removeObserver:observer]; \
                    }]; \
            notificationObservers[(_name)] = observer; \
        } \
        (observer); \
    } )

/** Remove the observer for the given notification registered using the method above with 'self' as the host. */
#define PearlRemoveNotificationObserver(_name) PearlRemoveNotificationObserverFrom( self, _name );
#define PearlRemoveNotificationObserverFrom(_host, _name) \
    ( { \
        NSMutableDictionary *notificationObservers = objc_getAssociatedObject( _host, &NotificationObserversKey ); \
        [[NSNotificationCenter defaultCenter] removeObserver:notificationObservers[(_name)] name:(_name) object:nil]; \
        [notificationObservers removeObjectForKey:(_name)]; \
    } )

/** Remove all notifications registered using the method above with 'self' as the host. */
#define PearlRemoveNotificationObservers() PearlRemoveNotificationObserversFrom( self );
#define PearlRemoveNotificationObserversFrom(_host) \
    ( { \
        NSMutableDictionary *notificationObservers = objc_getAssociatedObject( _host, &NotificationObserversKey ); \
        for (id notificationObserver in [notificationObservers allValues]) \
            [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver]; \
        objc_setAssociatedObject( _host, &NotificationObserversKey, nil, OBJC_ASSOCIATION_RETAIN ); \
    } )

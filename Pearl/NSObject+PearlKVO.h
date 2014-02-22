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
//  NSObject(PearlKVO)
//
//  Created by Maarten Billemont on 02/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PearlKVO)

/**
 * Add an observer block to the receiver that observes changes to value at the receiver's keyPath.
 *
 * @param observerBlock The block that gets invoked whenever a change to the receiver's value at the keyPath is detected.
 *                      The keyPath passed to the block is the keyPath where the change happened, the object is the receiver,
 *                      change is a dictionary that describes the change and context is the context given to this method.
 *
 * @return The observer that will delegate notifications to the block.  Remove this observer in -dealloc.
*/
- (id)addObserverBlock:(void (^)(NSString *keyPath, id object, NSDictionary *change, void *context))observerBlock
            forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

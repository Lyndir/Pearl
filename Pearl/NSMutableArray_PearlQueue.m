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
//  NSArray_PearlQueue.m
//  Pearl
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "NSMutableArray_PearlQueue.h"

@interface NSMutableArray () {
    
    NSUInteger                          _maximumCapacity;
    NSMutableArrayPearlQueueOverflow    _overflowStrategy;
}

@end

@implementation NSMutableArray (PearlQueue)

- (void)unsetMaximumCapacity {
    
    [self setMaximumCapacity:0 usingOverflowStrategy:NSMutableArrayPearlQueueOverflowFails];
}

- (void)setMaximumCapacity:(NSUInteger)maximumCapacity usingOverflowStrategy:(NSMutableArrayPearlQueueOverflow)overflowStrategy {
    
    _maximumCapacity = maximumCapacity;
    _overflowStrategy = overflowStrategy;
}

- (BOOL)pushObject:(id)object {
    
    if (_maximumCapacity)
        while ([self count] >= _maximumCapacity)
            switch (_overflowStrategy) {
                case NSMutableArrayPearlQueueOverflowFails: {
                    return NO;
                }
                case NSMutableArrayPearlQueueOverflowBlocks: {
                    // TODO: Lame.  Ideally, we wake up exactly when a thread pops an object.
                    [NSThread sleepForTimeInterval:0.1];
                    break;
                }
                case NSMutableArrayPearlQueueOverflowPopsFirst: {
                    [self removeObjectAtIndex:0];
                    break;
                }
            }
    
    [self addObject:object];
    return YES;
}

- (id)popObject {
    
    id object = [self peekObject];
    [self removeObjectAtIndex:0];
    
    return object;
}

- (id)peekObject {
    
    return [self objectAtIndex:0];
}

@end

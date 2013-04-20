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

@implementation PearlQueue

@synthesize array = _array, maximumCapacity = _maximumCapacity, overflowStrategy = _overflowStrategy;

- (id)initWithMaximumCapacity:(NSUInteger)maximumCapacity
        usingOverflowStrategy:(PearlQueueOverflow)overflowStrategy {

    if (!(self = [super init]))
        return nil;

    _maximumCapacity = maximumCapacity;
    _overflowStrategy = overflowStrategy;
    _array = [[NSMutableArray alloc] initWithCapacity:maximumCapacity];

    return self;
}

- (BOOL)pushObject:(id)object {

    if (_maximumCapacity)
        while ([self.array count] >= _maximumCapacity)
            switch (_overflowStrategy) {
                case PearlQueueOverflowFails: {
                    return NO;
                }
                case PearlQueueOverflowBlocks: {
                    // TODO: Lame.  Ideally, we wake up exactly when a thread pops an object.
                    [NSThread sleepForTimeInterval:0.1];
                    break;
                }
                case PearlQueueOverflowPopsFirst: {
                    @synchronized (self.array) {
                        [self.array removeObjectAtIndex:0];
                    }
                    break;
                }
            }

    @synchronized (self.array) {
        [self.array addObject:object];
    }

    return YES;
}

- (id)popObject {

    @synchronized (self.array) {
        id object = [self.array objectAtIndex:0];
        [self.array removeObjectAtIndex:0];

        return object;
    }
}

- (BOOL)popObject:(id)object {

    @synchronized (self.array) {
        NSUInteger index = [self.array indexOfObject:object];
        if (index == NSNotFound)
            return NO;

        [self.array removeObjectAtIndex:index];
    }

    return YES;
}

- (id)peekObject {

    @synchronized (self.array) {
        return [self.array objectAtIndex:0];
    }
}

- (void)clear {

    @synchronized (self) {
        [self.array removeAllObjects];
    }
}

@end

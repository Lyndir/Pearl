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
//  NSArray_PearlQueue.h
//  Pearl
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

__BEGIN_DECLS
typedef enum {
    PearlQueueOverflowFails,
    PearlQueueOverflowBlocks,
    PearlQueueOverflowPopsFirst
} PearlQueueOverflow;
__END_DECLS

@interface PearlQueue : NSObject

@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, assign) NSUInteger maximumCapacity;
@property(nonatomic, assign) PearlQueueOverflow overflowStrategy;

- (id)initWithMaximumCapacity:(NSUInteger)maximumCapacity
        usingOverflowStrategy:(PearlQueueOverflow)overflowStrategy;

- (BOOL)pushObject:(id)object;

- (id)popObject;
- (BOOL)popObject:(id)object;
- (id)peekObject;

- (void)clear;

@end

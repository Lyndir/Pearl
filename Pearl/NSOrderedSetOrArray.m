/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

#import "NSOrderedSetOrArray.h"

@implementation NSSet (NSOrderedSetOrArray)

- (NSSet *)set {

    return self;
}

- (NSOrderedSet *)orderedSet {

    return [NSOrderedSet orderedSetWithSet:self];
}

- (NSArray *)array {

    return [self allObjects];
}

@end

@implementation NSArray (NSOrderedSetOrArray)

- (NSSet *)set {

    return [NSSet setWithArray:self];
}

- (NSOrderedSet *)orderedSet {

    return [NSOrderedSet orderedSetWithArray:self];
}

- (NSArray *)array {

    return self;
}

- (id)anyObject {

    return [self firstObject];
}

@end

@implementation NSOrderedSet (NSOrderedSetOrArray)

- (NSOrderedSet *)orderedSet {

    return self;
}

- (id)anyObject {

    return [self firstObject];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector {

    [[self array] makeObjectsPerformSelector:aSelector];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(nullable id)argument {

    [[self array] makeObjectsPerformSelector:aSelector withObject:argument];
}

@end

@implementation NSMutableArray (NSMutableOrderedSetOrArray)

- (NSMutableOrderedSet *)mutableOrderedSet {

    return [[NSMutableOrderedSet alloc] initWithArray:self];
}

- (NSMutableArray *)mutableArray {

    return self;
}

@end

@implementation NSMutableOrderedSet (NSMutableOrderedSetOrArray)

- (NSMutableOrderedSet *)mutableOrderedSet {

    return self;
}

- (NSMutableArray *)mutableArray {

    return [[self array] mutableCopy];
}

@end

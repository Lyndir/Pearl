//
// Created by Maarten Billemont on 2017-04-14.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSSetOrArrayType id<NSObject, NSSetOrArray>
#define NSSetOrArrayFrom( o ) ({ \
    NSAssert([o isKindOfClass:[NSArray class]] || [o isKindOfClass:[NSSet class]], @"Object must be an array or set."); \
    (NSSetOrArrayType) o; \
})
#define NSOrderedSetOrArrayType id<NSObject, NSOrderedSetOrArray>
#define NSOrderedSetOrArrayFrom( o ) ({ \
    NSAssert([o isKindOfClass:[NSArray class]] || [o isKindOfClass:[NSOrderedSet class]], @"Object must be an array or ordered set."); \
    (NSOrderedSetOrArrayType) o; \
})
#define NSMutableOrderedSetOrArrayType id<NSObject, NSMutableOrderedSetOrArray>
#define NSMutableOrderedSetOrArrayFrom( o ) ({ \
    NSAssert([o isKindOfClass:[NSMutableArray class]] || [o isKindOfClass:[NSMutableOrderedSet class]], @"Object must be a mutable array or ordered set."); \
    (NSMutableOrderedSetOrArrayType) o; \
})

/**
 * This describes all the API that NSArray, NSSet and NSOrderedSet have in common.
 */
@protocol NSSetOrArray<NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

@property(readonly, strong) NSArray *array;
@property(readonly, strong) NSOrderedSet *orderedSet;
@property(readonly, strong) NSSet *set;

@property(readonly) NSUInteger count;
- (id)copy;
- (id)mutableCopy;
- (BOOL)containsObject:(id)anObject;
- (NSEnumerator *)objectEnumerator;
- (void)makeObjectsPerformSelector:(SEL)aSelector NS_SWIFT_UNAVAILABLE( "Use a for loop instead" );
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument NS_SWIFT_UNAVAILABLE("Use a for loop instead" );

@end

/**
 * This describes all the API that NSArray and NSOrderedSet have in common.
 */
@protocol NSOrderedSetOrArray<NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration, NSSetOrArray>

@property(readonly, strong) NSArray *array;
@property(readonly, strong) NSOrderedSet *orderedSet;
@property(readonly, strong) NSSet *set;

@property (readonly) NSUInteger count;
- (id)copy;
- (id)mutableCopy;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;
- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range NS_SWIFT_UNAVAILABLE("Use 'subarrayWithRange()'/'array' instead");
- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes;
@property (nonatomic, readonly) id firstObject NS_AVAILABLE(10_6, 4_0);
@property (nonatomic, readonly) id lastObject;
- (BOOL)containsObject:(id)anObject;
- (id)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
- (NSEnumerator<id> *)objectEnumerator;
- (NSEnumerator<id> *)reverseObjectEnumerator;
- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (NSUInteger)indexOfObjectPassingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSUInteger)indexOfObjectAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSIndexSet *)indexesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSIndexSet *)indexesOfObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmp NS_AVAILABLE(10_6, 4_0); // binary search
- (NSArray<id> *)sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0);
- (NSArray<id> *)sortedArrayWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0);

@end

/**
 * This describes all the API that NSMutableArray and NSMutableOrderedSet have in common.
 */
@protocol NSMutableOrderedSetOrArray<NSOrderedSetOrArray>

@property(readonly, strong) NSMutableArray *mutableArray;
@property(readonly, strong) NSMutableOrderedSet *mutableOrderedSet;

- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;
- (void)removeObjectsInRange:(NSRange)range;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)removeObject:(id)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE( 10_8, 6_0 );
- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE( 10_6, 4_0 );
- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE( 10_6, 4_0 );

@end

@interface NSSet (NSOrderedSetOrArray) <NSSetOrArray>
@end

@interface NSArray (NSOrderedSetOrArray) <NSOrderedSetOrArray>
@end

@interface NSOrderedSet (NSOrderedSetOrArray) <NSOrderedSetOrArray>
@end

@interface NSMutableArray (NSMutableOrderedSetOrArray) <NSMutableOrderedSetOrArray>
@end

@interface NSMutableOrderedSet (NSMutableOrderedSetOrArray) <NSMutableOrderedSetOrArray>
@end

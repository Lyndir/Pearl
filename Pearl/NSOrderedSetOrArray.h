//
// Created by Maarten Billemont on 2017-04-14.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSOrderedSetOrArrayType id<NSObject, NSOrderedSetOrArray>
#define NSOrderedSetOrArrayFrom( o ) ({ \
    NSAssert([o isKindOfClass:[NSArray class]] || [o isKindOfClass:[NSOrderedSet class]], @"Object must be an array or ordered set."); \
    (NSOrderedSetOrArrayType) o; \
})

/**
 * This describes all the API that NSArray and NSOrderedSet have in common.
 *
 * TODO: Make an equivalent NSMutableOrderedSetOrArray
 */
@protocol NSOrderedSetOrArray<NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

@property(readonly, strong) NSArray * array;
@property(readonly, strong) NSOrderedSet * orderedSet;
@property(readonly, strong) NSSet * set;

@property (readonly) NSUInteger count;
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

@interface NSArray (NSOrderedSetOrArray) <NSOrderedSetOrArray>

@end


@interface NSOrderedSet (NSOrderedSetOrArray) <NSOrderedSetOrArray>

@end

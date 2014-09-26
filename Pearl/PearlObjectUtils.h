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
//  ObjectUtils.h
//  RedButton
//
//  Created by Maarten Billemont on 08/11/10.
//  Copyright 2010 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define va_list_array(__list)                                                                   \
            ({                                                                                  \
                NSMutableArray *__array = [NSMutableArray array];                               \
                for (id __object; (__object = va_arg(__list, id));)                             \
                    [__array addObject:__object];                                               \
                va_end(__list);                                                                 \
                __array;                                                                        \
            })

#define va_array(__firstParameter)                                                              \
            ({                                                                                  \
                NSMutableArray *__array = [NSMutableArray array];                               \
                va_list __list;                                                                 \
                va_start(__list, __firstParameter);                                             \
                for (id __object = __firstParameter; __object; __object = va_arg(__list, id))   \
                    [__array addObject:__object];                                               \
                va_end(__list);                                                                 \
                __array;                                                                        \
            })

#define NilToNSNull(__O)                                                                        \
            ({ __typeof__(__O) __o = __O; __o == nil? (id)[NSNull null]: __o; })
#define NSNullToNil(__O)                                                                        \
            ({ __typeof__(__O) __o = __O; __o == (id)[NSNull null]? nil: __o; })
#define NilToNSNulls(...)                                                                        \
            MAP_LIST(NilToNSNull, __VA_ARGS__)
#define NSNullToNils(...)                                                                        \
            MAP_LIST(NSNullToNil, __VA_ARGS__)
#define PearlNil (id)(__bridge void *)nil
#define NSSetUnion(__s1, __s2) (__s1? [__s1 setByAddingObjectsFromSet:__s2]: [__s2 setByAddingObjectsFromSet:__s1])

#define ThrowInfo(__userInfo, __reason, ...)                                                    \
            @throw [NSException                                                                 \
                    exceptionWithName:NSInternalInconsistencyException                          \
                    reason:PearlString(__reason , ##__VA_ARGS__)                                \
                    userInfo:__userInfo]
#define Throw(__reason, ...)                                                                    \
            ThrowInfo(nil, __reason , ##__VA_ARGS__)
#define Weakify(__target) __weak typeof(__target) _weak_ ## __target = __target
#define Strongify(__target) __strong typeof(__target) __target = _weak_ ## __target

#define PearlInteger(__number) \
            [NSNumber numberWithInteger:__number]
#define PearlUnsignedInteger(__number) \
            [NSNumber numberWithUnsignedInteger:__number]
#define PearlFloat(__number) \
            [NSNumber numberWithFloat:__number]
#define PearlBool(__number) \
            [NSNumber numberWithBool:__number]
#define PearlIntegerOp(__number, __operation) \
            PearlInteger([__number integerValue] __operation)
#define PearlUnsignedIntegerOp(__number, __operation) \
            PearlUnsignedInteger([__number unsignedIntegerValue] __operation)
#define PearlFloatOp(__number, __operation) \
            PearlFloat([__number floatValue] __operation)
#define PearlBoolNot(__number) \
            PearlBool(![__number boolValue])

#define PearlMainThreadStart                                                                 \
            ({                                                                                  \
                dispatch_block_t __pearl_main_thread_block = ^
#define PearlMainThreadEnd                                                                   \
                ;                                                                              \
                if ([NSThread isMainThread])                                                    \
                    __pearl_main_thread_block();                                                \
                else                                                                            \
                    dispatch_async(dispatch_get_main_queue(), __pearl_main_thread_block);       \
            });

#define PearlAssociatedObjectProperty(__type, __uppercased, __lowercased)                                 \
            PearlAssociatedObjectPropertyAssociation(__type, __uppercased, __lowercased, OBJC_ASSOCIATION_RETAIN)
#define PearlAssociatedObjectPropertyAssociation(__type, __uppercased, __lowercased, __association)       \
            static char __uppercased ## Key;                                                          \
            - (void)set ## __uppercased :( __type ) __lowercased {                                          \
                objc_setAssociatedObject( self, & __uppercased ## Key, __lowercased, __association );       \
            }                                                                                   \
            - ( __type ) __lowercased {                                                             \
                return objc_getAssociatedObject( self, & __uppercased ## Key );                       \
            }
#define PearlObjCall(arg, call) [arg call]
/** Simplify PearlHashCode usage with objects.  Eg.
 *  PearlHashCode( self.age, MAP_LIST( PearlHashCall, self.firstName, self.lastName ), -1 );
 */
#define PearlHashCall(arg) [arg hash]
#define PearlHashFloat(arg) ((NSUInteger)((uint32_t*)&arg)[0])
#define PearlHashFloats(...) MAP_LIST(PearlHashFloat, __VA_ARGS__)
#define PearlStringify(arg) @#arg
#define PearlEnum(_enumname, _enumvalues...)                        \
    typedef NS_ENUM(NSUInteger, _enumname) {                        \
        _enumvalues                                                 \
    };                                                              \
                                                                    \
    static const NSArray *_enumname ## Names;                       \
    static NSUInteger _enumname ## Count;                           \
    __attribute__ ((constructor)) static void                       \
     _init_ ## _enumname () {                                       \
        _enumname ## Names = @[                                     \
            MAP_LIST(PearlStringify, _enumvalues)                   \
        ];                                                          \
        _enumname ## Count = [_enumname ## Names count];            \
    }                                                               \
    __attribute__((unused)) static _enumname                        \
    _enumname ## FromNSString(NSString *name) {                     \
        return (_enumname)[_enumname ## Names indexOfObject:name];  \
    }                                                               \
    __attribute__((unused)) static NSString*                        \
    NSStringFrom ## _enumname(_enumname value) {                    \
        return [_enumname ## Names objectAtIndex:value]?:           \
                   strf(@"[Unknown %@: %ld]",                       \
                       PearlStringify(_enumname), (long)value);     \
    }

__BEGIN_DECLS
/* Run a block on the main queue.  If already on the main queue, run it synchronously. */
extern void PearlMainQueue(void (^block)());
/* Run a block on a background queue.  If already on a background queue, run it synchronously. */
extern void PearlNotMainQueue(void (^block)());

/* Schedule a block to run on the main queue. */
extern NSBlockOperation *PearlMainQueueOperation(void (^block)());
/* Schedule a block to run on a background queue.  Use the current queue if currently on one, otherwise schedule it on a new queue. */
extern NSBlockOperation *PearlNotMainQueueOperation(void (^block)());

/* Run a block on the main queue and block until the operation has finished.  If already on the main queue, run it synchronously. */
extern void PearlMainQueueWait(void (^block)());
/* Run a block on a background queue and block until the operation has finished.  If already on a background queue, run it synchronously. */
extern void PearlNotMainQueueWait(void (^block)());

/* Schedule a block to run on the main queue after x seconds from now. */
extern void PearlMainQueueAfter(NSTimeInterval seconds, void (^block)(void));
/* Schedule a block to run on the global queue after x seconds from now. */
extern void PearlGlobalQueueAfter(NSTimeInterval seconds, void (^block)(void));
/* Schedule a block to run on the given queue after x seconds from now. */
extern void PearlQueueAfter(NSTimeInterval seconds, dispatch_queue_t queue, void (^block)(void));

/* Schedule a block to run on the main queue.  If this block was previously scheduled but not yet completed, cancel it first. */
#define PearlMainQueueSingularOperation(block) ({ \
        static __weak NSOperation *operation = nil; \
        [operation cancel]; \
        operation = PearlMainQueueOperation(block); \
    })
/* Schedule a block to run on a background queue.  If this block was previously scheduled but not yet completed, cancel it first. */
#define PearlNotMainQueueSingularOperation(block) ({ \
        static __weak NSOperation *operation = nil; \
        [operation cancel]; \
        operation = PearlNotMainQueueOperation(block); \
    })

/**
* Recursion detection.  Usage:
* static BOOL recursing = NO;
* PearlIfNotRecursing(&recursing, ^{
*     [stuff]; // Only executed first time, skipped if stuff causes recursion.
* });
*/
extern void PearlIfNotRecursing(BOOL *recursing, void(^notRecursingBlock)());
/** Calculates a hash code from a variable amount of hash codes.  The last argument should be -1. */
extern NSUInteger PearlHashCode(NSUInteger firstHashCode, ...);
__END_DECLS

@interface NSObject (PearlObjectUtils)

- (NSString *)propertyWithValue:(id)value;

@end

@interface PearlObjectUtils : NSObject

+ (id)getNil;

@end

@interface PearlBlockObject : NSObject

+ (id)objectWithBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))aBlock;
+ (id)objectWithBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))aBlock superClass:(Class)superClass;
+ (id)facadeFor:(id)facadedObject usingBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))aBlock;

- (id)initWithBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))facadeBlock
       facadeObject:(id)facade superClass:(Class)superClass;

@end

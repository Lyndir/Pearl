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

/** Macro Helpers */
#define PearlCStringify(arg) #arg
#define PearlStringify(arg) @PearlCStringify(arg)
#define PearlPrefix(_v) PearlToken _v
#define PearlSuffix(_v) _v PearlToken

/** @return an NSMutableArray with all vararg arguments remaining in __list */
#define va_list_array(__list)                                                                   \
            ({                                                                                  \
                NSMutableArray *__array = [NSMutableArray array];                               \
                for (id __object; (__object = va_arg(__list, id));)                             \
                    [__array addObject:__object];                                               \
                va_end(__list);                                                                 \
                __array;                                                                        \
            })

/** @return an NSMutableArray with all vararg arguments beginning at __firstParameter */
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

/** @return __O or NSNull if it is nil */
#define NilToNSNull(__O)                                                                        \
            ({ __typeof__(__O) __o = __O; __o == nil? (id)[NSNull null]: __o; })
/** @return __O or nil if it is NSNull */
#define NSNullToNil(__O)                                                                        \
            ({ __typeof__(__O) __o = __O; __o == (id)[NSNull null]? nil: __o; })
/** @return an inline list of arguments where each nil argument is replaced with NSNull */
#define NilToNSNulls(...)                                                                       \
            MAP_LIST(NilToNSNull, __VA_ARGS__)
/** @return an inline list of arguments where each NSNull argument is replaced with nil */
#define NSNullToNils(...)                                                                       \
            MAP_LIST(NSNullToNil, __VA_ARGS__)
/** @return __N asserted and typed as __nonnull. */
#define PearlNotNull(__N)                                                                       \
            ({ __typeof__(__N) __n = __N; NSAssert(__n, @"expected non-null: " PearlStringify(__N)); (id __nonnull) (__n); })
#define PearlCNotNull(__N)                                                                       \
            ({ __typeof__(__N) __n = __N; NSCAssert(__n, @"expected non-null: " PearlStringify(__N)); (id __nonnull) (__n); })
/** @return __N or __NN if _N is nil, typed as __nonnull. */
#define PearlNotNullOr(__N, __NN)                                                               \
            ({ __typeof__(__N) __n = __N; (id __nonnull) (NSNullToNil(__n)? __n: __NN); })
/** @return a nil object */
#define PearlNil (id)(__bridge void *)nil

typedef void(^VoidBlock)(void);

/** @return the set resulting from setByAddingObjectsFromSet of both arguments, in a nil-safe manner */
#define NSSetUnion(__s1, __s2) (__s1? [__s1 setByAddingObjectsFromSet:__s2]: [__s2 setByAddingObjectsFromSet:__s1])

/** Throw an NSInternalInconsistencyException with given __userInfo and __reason format and arguments */
#define ThrowInfo(__userInfo, __reason, ...)                                                    \
            @throw [NSException                                                                 \
                    exceptionWithName:NSInternalInconsistencyException                          \
                    reason:PearlString(__reason , ##__VA_ARGS__)                                \
                    userInfo:__userInfo]
/** Throw an NSInternalInconsistencyException with given __reason format and arguments */
#define Throw(__reason, ...)                                                                    \
            ThrowInfo(nil, __reason , ##__VA_ARGS__)

/** Internally, declare a weak version of __target for later use by Strongify. */
#define Weakify(__target) __weak typeof(__target) _weak_ ## __target = __target
/** Re-declare __target as strong from an earlier declared weak version of it.
 * Eg. Weakify(self); block = ^{ Strongify(self); [self doSomething]; } */
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

/** Start a block of code that can run synchronously if we are currently on the main thread, otherwise will be asynchonously scheduled on the main thread */
#define PearlMainThreadStart                                                                 \
            ({                                                                                  \
                dispatch_block_t __pearl_main_thread_block = ^
/** End a block of code started by PearlMainThreadStart */
#define PearlMainThreadEnd                                                                   \
                ;                                                                              \
                if ([NSThread isMainThread])                                                    \
                    __pearl_main_thread_block();                                                \
                else                                                                            \
                    dispatch_async(dispatch_get_main_queue(), __pearl_main_thread_block);       \
            });

/** Declare methods that behave like a property for use in a class extension.
 * Eg. PearlAssociatedObjectProperty(NSString*, Name, name) */
#define PearlAssociatedObjectProperty(__type, __uppercased, __lowercased)                                 \
            PearlAssociatedObjectPropertyTR(__type, __uppercased, __lowercased, , self)
/** Like PearlAssociatedObjectProperty but specify a method used to convert the type to an object and a method used to convert the object to the type.
 * Eg. PearlAssociatedObjectPropertyTR(BOOL, Alive, alive, @, boolValue) */
#define PearlAssociatedObjectPropertyTR(__type, __uppercased, __lowercased, __tr_to, __tr_from)                                 \
            PearlAssociatedObjectPropertyAssociationTR(__type, __uppercased, __lowercased, OBJC_ASSOCIATION_RETAIN, __tr_to, __tr_from)
/** Like PearlAssociatedObjectPropertyTR but specify an object storage association that's not OBJC_ASSOCIATION_RETAIN. */
#define PearlAssociatedObjectPropertyAssociationTR(__type, __uppercased, __lowercased, __association, __tr_to, __tr_from)       \
            static char __uppercased ## Key;                                                          \
            - (void)set ## __uppercased :( __type ) __lowercased {                                          \
                objc_setAssociatedObject( self, & __uppercased ## Key, __tr_to(__lowercased), __association );       \
            }                                                                                   \
            - ( __type ) __lowercased {                                                             \
                return [objc_getAssociatedObject( self, & __uppercased ## Key ) __tr_from];                       \
            }
#define PearlObjCall(arg, call) [arg call]
/** Simplify PearlHashCode usage with objects.  Eg.
*  PearlHashCode( self.age, MAP_LIST( PearlHashCall, self.firstName, self.lastName ), -1 );
*/
#define PearlHashCall(arg) [arg hash]
#define PearlHashFloat(arg) ((NSUInteger)((uint32_t*)&arg)[0])
#define PearlHashFloats(...) MAP_LIST(PearlHashFloat, __VA_ARGS__)
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
#define PearlInit(_variable, ...) ({ \
    typeof(_variable) PearlToken = _variable; \
    MAP_LIST( PearlPrefix, __VA_ARGS__ ); \
    PearlToken; \
})

__BEGIN_DECLS
/* Run a block on the main queue.  If already on the main queue, run it synchronously.
 * @return YES if on main queue and the block was executed synchronously.  NO if the block was scheduled on the main queue. */
extern BOOL PearlMainQueue(void (^block)());
/* Run a block on a background queue.  If already on a background queue, run it synchronously.
 * @return YES if not on main queue and the block was executed synchronously.  NO if the block was scheduled on a background queue. */
extern BOOL PearlNotMainQueue(void (^block)());

/* Schedule a block to run on the main queue. */
extern NSBlockOperation *PearlMainQueueOperation(void (^block)());
/* Schedule a block to run on a background queue.  Use the current queue if currently on one, otherwise schedule it on a new queue. */
extern NSBlockOperation *PearlNotMainQueueOperation(void (^block)());

/* Run a block and suspend the current thread until its setResult() is called.
 * @return the object passed to setResult. */
extern id PearlAwait(void (^block)(void (^setResult)(id result)));
/* Run a block on the main queue and suspend the current thread until it returns. If already on the main queue, run it synchronously.
 * @return the object returned from the block. */
extern id PearlMainQueueAwait(id (^block)());

/* Run a block on the main queue and block until the operation has finished.  If already on the main queue, run it synchronously.
 * @return YES if on main queue and the block was executed synchronously.  NO if the block was scheduled and executed on the main queue. */
extern BOOL PearlMainQueueWait(void (^block)());
/* Run a block on a background queue and block until the operation has finished.  If already on a background queue, run it synchronously.
 * @return YES if not on main queue and the block was executed synchronously.  NO if the block was scheduled and executed on a background queue. */
extern BOOL PearlNotMainQueueWait(void (^block)());

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
*
* @return YES if not recursing and the block was executed.
*/
extern BOOL PearlIfNotRecursing(BOOL *recursing, void(^notRecursingBlock)());
/** Calculates a hash code from a variable amount of hash codes.  The last argument should be -1. */
extern NSUInteger PearlHashCode(NSUInteger firstHashCode, ...);

extern void PearlSwizzle(Class type, SEL fromSel, SEL toSel);
__END_DECLS

@interface PearlWeakReference<ObjectType> : NSObject

@property(nonatomic, weak) ObjectType object;

+ (instancetype)referenceWithObject:(ObjectType)object;

@end

@interface NSObject(PearlObjectUtils)

- (NSString *)propertyWithValue:(id)value;
- (void)setStrongAssociatedObject:(id)object forSelector:(SEL)sel;
- (void)setWeakAssociatedObject:(id)object forSelector:(SEL)sel;
- (id)getAssociatedObjectForSelector:(SEL)sel;

@end

@interface PearlObjectUtils : NSObject

+ (id)getNil;

@end

@interface PearlBlockObject : NSObject

+ (id)objectWithBlock:(void ( ^ )(SEL message, id *result, id argument, NSInvocation *invocation))aBlock;
+ (id)objectWithBlock:(void ( ^ )(SEL message, id *result, id argument, NSInvocation *invocation))aBlock superClass:(Class)superClass;
+ (id)facadeFor:(id)facadedObject usingBlock:(void ( ^ )(SEL message, id *result, id argument, NSInvocation *invocation))aBlock;

- (id)initWithBlock:(void ( ^ )(SEL message, id *result, id argument, NSInvocation *invocation))facadeBlock
       facadeObject:(id)facade superClass:(Class)superClass;

@end

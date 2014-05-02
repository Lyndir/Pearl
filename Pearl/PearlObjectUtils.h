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
#import "map-macro.h"

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
#define IfNotNilElse(__NN,__N)                                                                  \
            ({ __typeof__(__NN) __nn = __NN; NSNullToNil(__nn)? __nn: __N; })
#define IfElse(__T, __F)                                                                        \
            ({ __typeof__(__T) __t = __T; __t? __t: __F; })
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

#define PearlAssociatedObjectProperty(__type, __name, __getter)                                 \
            PearlAssociatedObjectPropertyAssociation(__type, __name, __getter, OBJC_ASSOCIATION_RETAIN)
#define PearlAssociatedObjectPropertyAssociation(__type, __name, __getter, __association)       \
            static char __name ## Key;                                                          \
            - (void)set ## __name :( __type ) __name {                                          \
                objc_setAssociatedObject( self, & __name ## Key, __name, __association );       \
            }                                                                                   \
            - ( __type ) __getter {                                                             \
                return objc_getAssociatedObject( self, & __name ## Key );                       \
            }
#define PearlStringify(arg) @#arg
#define PearlStringifyArg(arg) PearlStringify(arg),
#define PearlEnum(_enumname, _enumvalues...)                        \
    typedef NS_ENUM(NSUInteger, _enumname) {                        \
        _enumvalues, _enumname ## Count                             \
    };                                                              \
                                                                    \
    static const NSArray *_enumname ## Names;                       \
    __attribute__ ((constructor)) static void                       \
     _init_ ## _enumname () {                                       \
        _enumname ## Names = @[                                     \
            MAP(PearlStringifyArg, _enumvalues)                     \
            PearlStringify(_enumname ## Count)                      \
        ];                                                          \
    }                                                               \
    __attribute__((unused)) static _enumname                        \
    _enumname ## FromNSString(NSString *name) {                     \
        return (_enumname)[_enumname ## Names indexOfObject:name];  \
    }                                                               \
    __attribute__((unused)) static NSString*                        \
    NSStringFrom ## _enumname(_enumname value) {                    \
        return [_enumname ## Names objectAtIndex:value];            \
    }

extern void PearlMainQueue(void (^block)());
extern void PearlNotMainQueue(void (^block)());
extern void PearlMainQueueAfter(NSTimeInterval seconds, void (^block)(void));
extern void PearlGlobalQueueAfter(NSTimeInterval seconds, void (^block)(void));
extern void PearlQueueAfter(NSTimeInterval seconds, dispatch_queue_t queue, void (^block)(void));

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

//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/** For the given type, trigger the given implementation when `sel` is called.
 *
 * You can call `sel` from the implementation block to invoke the original implementation.
 *
 * @param type The class on which to install the swizzled implementation.
 * @param sel The selector of the method whose implementation should be interjected.
 * @param definition A block-style function definition of the method, ie. \code ^returnType(id self, methodArguments) \endcode
 * @param imp A block-style method implementation, eg. \code { return arg + 5; } \endcode
 *
 * @return NO if type' sel has been previously swizzled by us.  In this case, no change is made.
 */
#define PearlSwizzle(type, sel, definition, imp) \
    PearlSwizzleTR(type, sel, definition, imp, nonretainedObjectValue)

/** PearlSwizzle variant for non-id return value types.
 *
 * @param rv The method used for getting the return type's primitive value out of the object value.
 *
 * @return NO if type' sel has been previously swizzled by us.  In this case, no change is made.
 */
#define PearlSwizzleTR(type, sel, rv, args, imp, tr) ({                   \
    __typeof__(type) _type = (type); __typeof__(sel) _sel = (sel);          \
    PearlSwizzleDo( _type, _sel, imp_implementationWithBlock( rv args {  \
        return [PearlSwizzleIMP( _type, _sel, rv imp ) tr];                  \
    } ) );                                                                  \
})
extern BOOL PearlSwizzleDo(Class type, SEL sel, IMP replacement);
extern NSValue *PearlSwizzleIMP(Class type, SEL sel, id block);

/**
 * Initialize an NSInvocation populated with the current varargs starting after `args`.
 */
#define PearlInvocationMakeWithVargs(target, sel, last) ({                              \
    va_list _args_list;                                                                 \
    va_start( _args_list, last );                                                       \
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];             \
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];  \
    [invocation setTarget:target];                                                      \
    [invocation setSelector:sel];                                                       \
    [invocation setArguments:_args_list];                                               \
    va_end( _args_list );                                                               \
    invocation;                                                                         \
})

@interface NSInvocation(Pearl)

/** Initialize the arguments of the invocation using the given varargs.  The method signature should match the varargs. */
- (void)setArguments:(va_list)args;
/** Invoke the implementation of the invocation that's in the given subclass as opposed to the overridden implementation in the target's type. */
- (void)invokeWithTarget:(id)target superclass:(Class)type;
/** Wrap the invocation's return value in an NSValue. */
- (NSValue *)returnValue;
/** Get the return value directly if it's of type id. */
- (id)nonretainedObjectValue;

@end

@interface NSValue(Pearl)

- (char)charValue;
- (unsigned char)unsignedCharValue;
- (short)shortValue;
- (unsigned short)unsignedShortValue;
- (int)intValue;
- (unsigned int)unsignedIntValue;
- (long)longValue;
- (unsigned long)unsignedLongValue;
- (long long)longLongValue;
- (unsigned long long)unsignedLongLongValue;
- (float)floatValue;
- (double)doubleValue;
- (BOOL)boolValue;
- (NSInteger)integerValue;
- (NSUInteger)unsignedIntegerValue;
- (NSString *)stringValue;

@end

//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

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
#define return_invocation(invocation, type) \
    type _returnValue; \
    [invocation getReturnValue:&_returnValue]; \
    return _returnValue;

/** A helper for setting sequences of arguments. */
#define PearlInvocationSetArg(_arg) [_invocation setArgument:&_arg atIndex:_a++];

@interface NSInvocation(Pearl)

/** Initialize the arguments of the invocation using the given varargs.  The method signature should match the varargs. */
- (void)setArguments:(va_list)args;
/** Invoke the implementation of the invocation that's in the given subclass as opposed to the overridden implementation in the target's type. */
- (void)invokeWithTarget:(id)target superclass:(Class)type;
/** Wrap the invocation's return value in an NSValue. */
- (NSValue *)returnValue;

- (id)idValue;
- (SEL)selectorValue;
- (Class)classValue;
- (char)charValue;
- (unsigned char)unsignedCharValue;
- (int)intValue;
- (BOOL)boolValue;
- (short)shortValue;
- (unichar)unicharValue;
- (float)floatValue;
- (double)doubleValue;
- (long)longValue;
- (long long)longLongValue;
- (unsigned int)unsignedIntValue;
- (unsigned long)unsignedLongValue;
- (unsigned long long)unsignedLongLongValue;
- (char *)stringValue;
- (void *)pointerValue;

/** A pointer to a malloc'ed memory space that holds the return value.  You should free it when you're done. */
- (void *)pointerToValue;

@end

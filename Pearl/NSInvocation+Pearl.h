//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/** For the given type, trigger toSel's implementation when invoking fromSel.
 *
 * It is safe to swizzle toSel for multiple types in a class hierarchy:
 * special care is taken to ensure it will only replace the original implementation the first time in the call stack.
 *
 * It is safe to call fromSel to invoke the original implementation, but it's a good idea to use PearlDeswizzleInvoke instead.
 *
 * Details:
 * Calling fromSel triggers toSel's implementation except if called from toSel (in the call stack).
 * Calling toSel behaves as normal and invokes toSel's implementation, too.  It does NOT trigger fromSel's original implementation.
 *
 * @return NO if there is no fromSel on the given type or the swizzle was already applied on the type.
 */
extern BOOL PearlSwizzle(Class type, SEL fromSel, SEL toSel);

/** Invoke the original implementation from a swizzled method.
 *
 * It is safe to invoke fromSel directly, but the advantages of using this method is that fromSel is invoked on the current class level.
 * Without this, fromSel could be invoked on a subclass after that subclass' fromSel already delegated to super.
 *
 * For example, after PearlSwizzle(UIView, alpha, alpha_swizzled)
 *
 * Direct invocation of setAlpha: from setAlpha_swizzled:
 * [UIButton alpha] --[super alpha]--> [UIView alpha_swizzled] --[self alpha]--> [UIButton alpha] --[super alpha]--> [UIView alpha]
 *
 * PearlDeswizzleInvoke of alpha from alpha_swizzled
 * [UIButton alpha] --[super alpha]--> [UIView alpha_swizzled] --PearlDeswizzleInvoke--> [UIView alpha]
 */
#define PearlDeswizzleInvoke(fromSel, ...) ({                                           \
    NSMethodSignature *_signature = [self methodSignatureForSelector:fromSel];          \
    NSInvocation *_invocation = [NSInvocation invocationWithMethodSignature:_signature];\
    [_invocation setTarget:self];                                                       \
    [_invocation setSelector:fromSel];                                                  \
    NSInteger _a = 2;                                                                   \
    MAP( PearlInvocationSetArg, ##__VA_ARGS__ );                                        \
    [_invocation invokeWithTarget:self superclass:objc_getAssociatedObject(self, _cmd)];\
    _invocation;                                                                        \
})

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

/** A helper for setting sequences of arguments. */
#define PearlInvocationSetArg(_arg) [_invocation setArgument:&_arg atIndex:_a++];

/** Create an IMP, implemented by the given block, which extracts and returns the return value from the resulting NSInvocation. */
IMP PearlForwardIMP(Method forMethod, void(^invoke)(__unsafe_unretained id self, NSInvocation *invocation));

@interface NSInvocation(Pearl)

/** Initialize the arguments of the invocation using the given varargs.  The method signature should match the varargs. */
- (void)setArguments:(va_list)args;
/** Invoke the implementation of the invocation that's in the given subclass as opposed to the overridden implementation in the target's type. */
- (void)invokeWithTarget:(id)target superclass:(Class)type;
/** Wrap the invocation's return value in an NSValue. */
- (NSValue *)returnValue;
/** Get the return value directly if it's of type id. */
- (id)idValue;

@end

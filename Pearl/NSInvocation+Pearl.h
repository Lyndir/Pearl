//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

/** For the given type, trigger the given implementation when `sel` is called.
 *
 * To invoke the original implementation at \code sel \endcode, call \code super( self, sel, <args> ) \endcode.
 *
 * @param type The literal class on which to install the swizzled implementation.
 * @param sel The selector of the method whose implementation should be interjected.
 * @param rv A block-style return value representation of the swizzled method, ie. \code ^returnType \endcode
 * @param imp A block-style method implementation, eg. \code { return arg + 5; } \endcode
 * @param args A block-style arguments definition of the swizzled method, eg. \code UIView *v, CGFloat a \endcode
 */
#define PearlSwizzle(type, sel, rv, imp, ...) ({                   \
    rv (__block *orig)( type*, SEL, ##__VA_ARGS__ ) = nil; SEL s##el = (sel);          \
    orig = (__typeof__(orig))PearlSwizzleDo( [type class], sel, imp_implementationWithBlock( ^rv (type *self, ##__VA_ARGS__) imp ) ); \
})
#define PearlSwizzleD(type, sel, rv, imp, ...) ({                   \
    rv (__block *orig)( id, SEL, ##__VA_ARGS__ ) = nil; SEL s##el = (sel);          \
    orig = (__typeof__(orig))PearlSwizzleDo( type, sel, imp_implementationWithBlock( ^rv (id self, ##__VA_ARGS__) imp ) ); \
})
extern IMP PearlSwizzleDo(Class type, SEL sel, IMP replacement);

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

@property(readonly) char charValue;
@property(readonly) unsigned char unsignedCharValue;
@property(readonly) short shortValue;
@property(readonly) unsigned short unsignedShortValue;
@property(readonly) int intValue;
@property(readonly) unsigned int unsignedIntValue;
@property(readonly) long longValue;
@property(readonly) unsigned long unsignedLongValue;
@property(readonly) long long longLongValue;
@property(readonly) unsigned long long unsignedLongLongValue;
@property(readonly) float floatValue;
@property(readonly) double doubleValue;
@property(readonly) BOOL boolValue;
@property(readonly) NSInteger integerValue;
@property(readonly) NSUInteger unsignedIntegerValue;
@property(readonly) NSString *stringValue;

@end

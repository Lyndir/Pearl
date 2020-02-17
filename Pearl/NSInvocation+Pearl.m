//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "NSInvocation+Pearl.h"

@implementation NSInvocation(Pearl)

- (void)setArguments:(va_list)args {

    for (NSUInteger a = 2; a < [self.methodSignature numberOfArguments]; ++a) {
        NSUInteger size, alignment;
        const char *argType = [self.methodSignature getArgumentTypeAtIndex:a];
        NSGetSizeAndAlignment( argType, &size, &alignment );

        if (size <= sizeof( uint32_t )) { // 1 - 4
            uint32_t arg = va_arg( args, uint32_t );
            [self setArgument:&arg atIndex:(NSInteger)a];
        }
        else if (size <= sizeof( uint64_t )) { // 5 - 8
            uint64_t arg = va_arg( args, uint64_t );
            [self setArgument:&arg atIndex:(NSInteger)a];
        }
        else if (size <= sizeof( CGPoint )) { // 9 - 16
            CGPoint arg = va_arg( args, CGPoint );
            [self setArgument:&arg atIndex:(NSInteger)a];
        }
        else if (size <= sizeof( CGRect )) { // 17 - 32
            CGRect arg = va_arg( args, CGRect );
            [self setArgument:&arg atIndex:(NSInteger)a];
        }
        else if (size <= sizeof( CGAffineTransform )) { // 33 - 48
            CGAffineTransform arg = va_arg( args, CGAffineTransform );
            [self setArgument:&arg atIndex:(NSInteger)a];
        }
        else
            abort(/* argument size not yet supported. */);
    }
}

- (void)invokeWithTarget:(id)target superclass:(Class)type {

    if (!type)
        abort(/* `type` missing. */);
    if ([target class] == type) {
        // Short circuit if type is not a superclass.
        [self invokeWithTarget:target];
        return;
    }
    SEL targetSel = self.selector;
    Method targetMethod = class_getInstanceMethod( type, targetSel );
    if (!targetMethod)
        abort(/* `type` does not have a `targetSel` method. */);

    Method proxyMethod = class_getInstanceMethod( [target class], targetSel );
    if (proxyMethod == targetMethod) {
        // Short circuit if target method is already top level.
        [self invokeWithTarget:target];
        return;
    }

    // Make the target method implementation available temporarily at the top level, while we invoke it.
    IMP proxyImp = method_getImplementation( targetMethod );
    IMP targetImp = method_getImplementation( targetMethod );
    method_setImplementation( proxyMethod, targetImp );
    [self invokeWithTarget:target];
    method_setImplementation( proxyMethod, proxyImp );
}

- (NSValue *)returnValue {

    if (!self.methodSignature.methodReturnLength)
        return nil;

    void *arg = malloc( self.methodSignature.methodReturnLength );
    @try {
        [self getReturnValue:arg];
        return [NSValue value:&arg withObjCType:[self.methodSignature methodReturnType]];
    }
    @finally {
        free( arg );
    }
}

- (id)nonretainedObjectValue {

    if (0 != strcmp( @encode( id ), self.methodSignature.methodReturnType ))
        abort(/* Only use -idValue for methods with an id return type */);

    id value;
    [self getReturnValue:&value];
    return value;
}

@end

//static int depth = 0;
//static NSMutableDictionary *imps;

IMP PearlSwizzleDo(Class type, SEL sel, IMP replacement) {

    @synchronized (type) {
        //if (!imps)
        //    imps = [NSMutableDictionary new];

        Method originalMethod = class_getInstanceMethod( type, sel );
        if (!originalMethod)
            abort(/* `type` does not have a `sel` method */);
        const char *methodTypes = method_getTypeEncoding( originalMethod );

        // Create the proxy method on `type` with the `replacement` implementation.
        SEL proxySel = NSSelectorFromString( strf( @"%@_PearlSwizzleProxy_%@", NSStringFromClass( type ), NSStringFromSelector( sel ) ) );
        if (!class_addMethod( type, proxySel, replacement, methodTypes ))
            // This method's swizzle was already installed.
            return NULL;
        Method proxyMethod = class_getInstanceMethod( type, proxySel );

        // Copy the original implementation to `type` if before it existed on a supertype: we don't want to swizzle at the supertype level.
        IMP original = method_getImplementation( originalMethod );
        if (class_addMethod( type, sel, original, methodTypes ))
            originalMethod = class_getInstanceMethod( type, sel );

        //if (!imps[[NSValue valueWithPointer:original]])
        //    imps[[NSValue valueWithPointer:original]] = strf( @"%@:orig", PearlDescribeCShort( type ) );
        //imps[[NSValue valueWithPointer:replacement]] = strf( @"%@:proxy", PearlDescribeCShort( type ) );
        //trc( @"Will swizzle %@ for %@, original state is:", NSStringFromSelector( sel ), type );
        //trc( @"  - method: [base = %@] --> impl: [%@ @%@]",
        //        NSStringFromSelector( method_getName( originalMethod ) ),
        //        imps[[NSValue valueWithPointer:method_getImplementation( originalMethod )]],
        //        @((long)method_getImplementation( originalMethod )) );
        //trc( @"  - method: [prox = %@] --> impl: [%@ @%@]",
        //        NSStringFromSelector( method_getName( proxyMethod ) ),
        //        imps[[NSValue valueWithPointer:method_getImplementation( proxyMethod )]],
        //        @((long)method_getImplementation( proxyMethod )) );

        // Do the swizzle!
        method_exchangeImplementations( originalMethod, proxyMethod );
        return original;
    }
}

@implementation NSValue(Pearl)

- (char)charValue {

    char value;
    [self getValue:&value];
    return value;
}

- (unsigned char)unsignedCharValue {

    unsigned char value;
    [self getValue:&value];
    return value;
}

- (short)shortValue {

    short value;
    [self getValue:&value];
    return value;
}

- (unsigned short)unsignedShortValue {

    unsigned short value;
    [self getValue:&value];
    return value;
}

- (int)intValue {

    int value;
    [self getValue:&value];
    return value;
}

- (unsigned int)unsignedIntValue {

    unsigned int value;
    [self getValue:&value];
    return value;
}

- (long)longValue {

    long value;
    [self getValue:&value];
    return value;
}

- (unsigned long)unsignedLongValue {

    unsigned long value;
    [self getValue:&value];
    return value;
}

- (long long)longLongValue {

    long long value;
    [self getValue:&value];
    return value;
}

- (unsigned long long)unsignedLongLongValue {

    unsigned long long value;
    [self getValue:&value];
    return value;
}

- (float)floatValue {

    float value;
    [self getValue:&value];
    return value;
}

- (double)doubleValue {

    double value;
    [self getValue:&value];
    return value;
}

- (BOOL)boolValue {

    BOOL value;
    [self getValue:&value];
    return value;
}

- (NSInteger)integerValue {

    NSInteger value;
    [self getValue:&value];
    return value;
}

- (NSUInteger)unsignedIntegerValue {

    NSUInteger value;
    [self getValue:&value];
    return value;
}

- (NSString *)stringValue {

    NSString *value;
    [self getValue:&value];
    return value;
}

@end

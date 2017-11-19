//
// Created by Maarten Billemont on 2017-11-18.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import "NSInvocation+Pearl.h"

@implementation NSInvocation(Pearl)

- (void)setArguments:(va_list)args {
    for (NSUInteger a = 2; a < [self.methodSignature numberOfArguments]; ++a) {
        const char *argType = [self.methodSignature getArgumentTypeAtIndex:a];

        if (0 == strcmp( argType, @encode( id ) )) {
            id arg = va_arg( args, id );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( SEL ) )) {
            SEL arg = va_arg( args, SEL );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( Class ) )) {
            Class arg = va_arg( args, Class );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( char ) )) {
            char arg = va_arg( args, char );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( unsigned char ) )) {
            unsigned char arg = va_arg( args, unsigned char );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( int ) )) {
            int arg = va_arg( args, int );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( BOOL ) )) {
            BOOL arg = va_arg( args, BOOL );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( short ) )) {
            short arg = va_arg( args, short );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( unichar ) )) {
            unichar arg = va_arg( args, unichar );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( float ) )) {
            float arg = va_arg( args, float );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( double ) )) {
            double arg = va_arg( args, double );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( long ) )) {
            long arg = va_arg( args, long );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( long long ) )) {
            long long arg = va_arg( args, long long );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( unsigned int ) )) {
            unsigned int arg = va_arg( args, unsigned int );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( unsigned long ) )) {
            unsigned long arg = va_arg( args, unsigned long );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( unsigned long long ) )) {
            unsigned long long arg = va_arg( args, unsigned long long );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( char * ) )) {
            char *arg = va_arg( args, char* );
            [self setArgument:&arg atIndex:a];
        }
        else if (0 == strcmp( argType, @encode( void * ) )) {
            void *arg = va_arg( args, void* );
            [self setArgument:&arg atIndex:a];
        }
        else
            abort();
    }
}

- (void)invokeWithTarget:(id)target subclass:(Class)type {
    if (!type)
        // Error: `type` missing.
        abort();
    if ([target class] == type) {
        // Short circuit if type is not a superclass.
        [self invokeWithTarget:target];
        return;
    }
    SEL targetSel = self.selector;
    Method targetMethod = class_getInstanceMethod( type, targetSel );
    if (!targetMethod)
        // Error: `type` does not have a `targetSel` method.
        abort();
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
    } @finally {
        free( arg );
    }
}

- (id)idValue {

    if (0 != strcmp( @encode( id ), self.methodSignature.methodReturnType))
        return nil;

    id value;
    [self getReturnValue:&value];
    return value;
}

- (SEL)selectorValue {

    if (0 != strcmp( @encode( SEL ), self.methodSignature.methodReturnType))
        return 0;

    SEL value;
    [self getReturnValue:&value];
    return value;
}

- (Class)classValue {

    if (0 != strcmp( @encode( Class ), self.methodSignature.methodReturnType))
        return nil;

    Class value;
    [self getReturnValue:&value];
    return value;
}

- (char)charValue {

    if (0 != strcmp( @encode( char ), self.methodSignature.methodReturnType))
        return 0;

    char value;
    [self getReturnValue:&value];
    return value;
}

- (unsigned char)unsignedCharValue {

    if (0 != strcmp( @encode( unsigned char ), self.methodSignature.methodReturnType))
        return 0;

    unsigned char value;
    [self getReturnValue:&value];
    return value;
}

- (int)intValue {

    if (0 != strcmp( @encode( int ), self.methodSignature.methodReturnType))
        return 0;

    int value;
    [self getReturnValue:&value];
    return value;
}

- (BOOL)boolValue {

    if (0 != strcmp( @encode( BOOL ), self.methodSignature.methodReturnType))
        return 0;

    BOOL value;
    [self getReturnValue:&value];
    return value;
}

- (short)shortValue {

    if (0 != strcmp( @encode( short ), self.methodSignature.methodReturnType))
        return 0;

    short value;
    [self getReturnValue:&value];
    return value;
}

- (unichar)unicharValue {

    if (0 != strcmp( @encode( unichar ), self.methodSignature.methodReturnType))
        return 0;

    unichar value;
    [self getReturnValue:&value];
    return value;
}

- (float)floatValue {

    if (0 != strcmp( @encode( float ), self.methodSignature.methodReturnType))
        return 0;

    float value;
    [self getReturnValue:&value];
    return value;
}

- (double)doubleValue {

    if (0 != strcmp( @encode( double ), self.methodSignature.methodReturnType))
        return 0;

    double value;
    [self getReturnValue:&value];
    return value;
}

- (long)longValue {

    if (0 != strcmp( @encode( long ), self.methodSignature.methodReturnType))
        return 0;

    long value;
    [self getReturnValue:&value];
    return value;
}

- (long long)longLongValue {

    if (0 != strcmp( @encode( long long ), self.methodSignature.methodReturnType))
        return 0;

    long long value;
    [self getReturnValue:&value];
    return value;
}

- (unsigned int)unsignedIntValue {

    if (0 != strcmp( @encode( unsigned int ), self.methodSignature.methodReturnType))
        return 0;

    unsigned int value;
    [self getReturnValue:&value];
    return value;
}

- (unsigned long)unsignedLongValue {

    if (0 != strcmp( @encode( unsigned long ), self.methodSignature.methodReturnType))
        return 0;

    unsigned long value;
    [self getReturnValue:&value];
    return value;
}

- (unsigned long long)unsignedLongLongValue {

    if (0 != strcmp( @encode( unsigned long long ), self.methodSignature.methodReturnType))
        return 0;

    unsigned long long value;
    [self getReturnValue:&value];
    return value;
}

- (char *)stringValue {

    if (0 != strcmp( @encode( char * ), self.methodSignature.methodReturnType))
        return 0;

    char *value;
    [self getReturnValue:&value];
    return value;
}

- (void *)pointerValue {

    void *value;
    [self getReturnValue:&value];
    return value;
}

- (void *)pointerToValue {

    void *value = malloc( self.methodSignature.methodReturnLength );
    [self getReturnValue:value];
    return value;
}

@end

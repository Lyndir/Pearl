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

        if (sizeof(uint8_t) == size) { // 1
            uint8_t arg = va_arg( args, uint8_t );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( uint16_t ) == size) { // 2
            uint16_t arg = va_arg( args, uint16_t );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( uint32_t ) == size) { // 4
            uint32_t arg = va_arg( args, uint32_t );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( uint64_t ) == size) { // 8
            uint64_t arg = va_arg( args, uint64_t );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( CGPoint ) == size) { // 16
            CGPoint arg = va_arg( args, CGPoint );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( CGRect ) == size) { // 32
            CGRect arg = va_arg( args, CGRect );
            [self setArgument:&arg atIndex:a];
        }
        else if (sizeof( CGAffineTransform ) == size) { // 48
            CGAffineTransform arg = va_arg( args, CGAffineTransform );
            [self setArgument:&arg atIndex:a];
        }
        else // argument size not yet supported.
            abort();
    }
}

- (void)invokeWithTarget:(id)target superclass:(Class)type {
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
        abort();

    id value;
    [self getReturnValue:&value];
    return value;
}

@end

BOOL PearlSwizzle(Class type, SEL fromSel, SEL toSel) {
    // If there is no `fromSel` method in `type`'s class hierarchy, abort.
    Method fromMethod = class_getInstanceMethod( type, fromSel );
    if (!fromMethod)
        return NO;

    @synchronized (type) {
        // Make sure `type` defines a local `fromSel` implementation; adding an empty `[super fromSel]` call if needed.
        const char *methodTypes = method_getTypeEncoding( fromMethod );
        class_addMethod( type, fromSel, PearlForwardIMP( fromMethod, ^(__unsafe_unretained id self, NSInvocation *invocation) {
          [invocation invokeWithTarget:self superclass:class_getSuperclass( type )];
        } ), methodTypes );

        // Add the swizzle trampoline which effects the swizzle but only at the highest level in the call stack/class hierarchy.
        SEL proxySel = NSSelectorFromString( strf( @"%@_PearlSwizzleProxy_%@", NSStringFromClass( type ), NSStringFromSelector( toSel ) ) );
        if (!class_addMethod( type, proxySel, PearlForwardIMP( fromMethod, ^(__unsafe_unretained id self, NSInvocation *invocation) {
          @synchronized (type) {
              @try {
                  // Temporarily restore the unswizzled state.
                  method_exchangeImplementations(
                      class_getInstanceMethod( type, proxySel ),
                      class_getInstanceMethod( type, fromSel ) );

                  if (objc_getAssociatedObject( self, toSel ))
                      // This `toSel` has already been handled in the call stack.  Invoke the original implementation at this level.
                      return [invocation invokeWithTarget:self superclass:type];

                  // Invoke `toSel` and record the fact that we've done so to avoid invoking it again as a result of a super-type swizzle.
                  @try {
                      objc_setAssociatedObject( self, toSel, type, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
                      invocation.selector = toSel;
                      return [invocation invokeWithTarget:self superclass:type];
                  }
                  @finally {
                      objc_setAssociatedObject( self, toSel, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
                  }
              }
                  // Restore the swizzled state.
              @finally {
                  method_exchangeImplementations(
                      class_getInstanceMethod( type, fromSel ),
                      class_getInstanceMethod( type, proxySel ) );
              }
          }
        } ), methodTypes ))
            return NO;

        // Do the swizzle!
        method_exchangeImplementations(
            class_getInstanceMethod( type, fromSel ),
            class_getInstanceMethod( type, proxySel ) );
        return YES;
    }
}

IMP PearlForwardIMP(Method forMethod, void(^invoke)(__unsafe_unretained id self, NSInvocation *invocation)) {
    NSUInteger size, alignment;
    SEL sel = method_getName( forMethod );
    NSGetSizeAndAlignment( method_copyReturnType( forMethod ), &size, &alignment );

    if (!size) // void
        return imp_implementationWithBlock( ^void(__unsafe_unretained id self, ...) {
          NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
          invoke( self, invocation );
        } );

    else if (size <= sizeof( id )) // 8
        return imp_implementationWithBlock( ^id(__unsafe_unretained id self, ...) {
          NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
          invoke( self, invocation );
          id returnValue = nil;
          [invocation getReturnValue:&returnValue];
          return returnValue;
        } );

    else if (size <= sizeof( CGSize )) // 16
        return imp_implementationWithBlock( ^CGSize(__unsafe_unretained id self, ...) {
          NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
          invoke( self, invocation );
          CGSize returnValue = CGSizeZero;
          [invocation getReturnValue:&returnValue];
          return returnValue;
        } );

    else if (size <= sizeof( CGRect )) // 32
        return imp_implementationWithBlock( ^CGRect(__unsafe_unretained id self, ...) {
          NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
          invoke( self, invocation );
          CGRect returnValue = CGRectZero;
          [invocation getReturnValue:&returnValue];
          return returnValue;
        } );

    else if (size <= sizeof( CGAffineTransform )) // 48
        return imp_implementationWithBlock( ^CGAffineTransform(__unsafe_unretained id self, ...) {
          NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
          invoke( self, invocation );
          CGAffineTransform returnValue = CGAffineTransformIdentity;
          [invocation getReturnValue:&returnValue];
          return returnValue;
        } );

    else // return value size not yet supported.
        abort();
}

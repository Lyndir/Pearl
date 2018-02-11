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
    } @finally {
        free( arg );
    }
}

- (id)nonretainedObjectValue {

    if (0 != strcmp( @encode( id ), self.methodSignature.methodReturnType))
        abort(/* Only use -idValue for methods with an id return type */);

    id value;
    [self getReturnValue:&value];
    return value;
}

@end

BOOL PearlSwizzleDo(Class type, SEL sel, IMP replacement) {
    Method method = class_getInstanceMethod( type, sel );
    if (!method)
        abort(/* `type` does not have a `fromSel` method */);

    @synchronized (type) {
        const char *methodTypes = method_getTypeEncoding( method );
        SEL proxySel = NSSelectorFromString( strf( @"%@_PearlSwizzleProxy_%@", NSStringFromClass( type ), NSStringFromSelector( sel ) ) );
        if (!class_addMethod( type, proxySel, replacement, methodTypes ))
            return NO;

        // Do the swizzle!
        class_addMethod( type, sel, method_getImplementation( method ), methodTypes );
        method_exchangeImplementations( class_getInstanceMethod( type, sel ), class_getInstanceMethod( type, proxySel ) );
        return YES;
    }
}

NSValue *PearlSwizzleIMP(Class type, SEL sel, id _Nonnull block) {
    char *returnType = method_copyReturnType( class_getInstanceMethod( type, sel ) );
    SEL proxySel = NSSelectorFromString( strf( @"%@_PearlSwizzleProxy_%@", NSStringFromClass( type ), NSStringFromSelector( sel ) ) );
    @try {
        // Temporarily restore the unswizzled state.
        method_exchangeImplementations(
              class_getInstanceMethod( type, proxySel ),
              class_getInstanceMethod( type, sel ) );

        NSValue *returnValue = nil;
        NSUInteger size, alignment;
        NSGetSizeAndAlignment( returnType, &size, &alignment );
          if (!size) // 0, void
              ((void (^)(void))block)();

          else if (size <= sizeof( id )) { // 1 - 8
              id value = ((id (^)(void))block)();
              returnValue = [NSValue value:&value withObjCType:returnType];
          }

          else if (size <= sizeof( CGSize )) { // 9 - 16
              CGSize value = ((CGSize (^)(void))block)();
              returnValue = [NSValue value:&value withObjCType:returnType];
          }

          else if (size <= sizeof( CGRect )) { // 17 - 32
              CGRect value = ((CGRect (^)(void))block)();
              returnValue = [NSValue value:&value withObjCType:returnType];
          }

          else if (size <= sizeof( CGAffineTransform )) { // 33 - 48
              CGAffineTransform value = ((CGAffineTransform (^)(void))block)();
              returnValue = [NSValue value:&value withObjCType:returnType];
          }

          else
              abort(/* return value size not yet supported. */);

          return returnValue;
      }
      @finally {
          free( returnType );
          // Restore the swizzled state.
          method_exchangeImplementations(
              class_getInstanceMethod( type, sel ),
              class_getInstanceMethod( type, proxySel ) );
      }
}

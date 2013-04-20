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
//  ObjectUtils.m
//  RedButton
//
//  Created by Maarten Billemont on 08/11/10.
//  Copyright 2010 Lyndir. All rights reserved.
//

#import "objc/runtime.h"

@implementation PearlObjectUtils

+ (id)getNil {

    return nil;
}

@end

@implementation PearlBlockObject

static char facadeBlockKey, facadedObjectKey;

+ (id)objectWithBlock:(void (^)(SEL, id *, id, NSInvocation *))facadeBlock {

    return [self objectWithBlock:facadeBlock superClass:[self superclass]];
}

+ (id)objectWithBlock:(void (^)(SEL, id *, id, NSInvocation *))facadeBlock superClass:(Class)superClass {

    return [[self alloc] initWithBlock:facadeBlock facadeObject:nil superClass:superClass];
}

+ (id)facadeFor:(id)facadedObject usingBlock:(void (^)(SEL, id *, id, NSInvocation *))facadeBlock {

    return [[self alloc] initWithBlock:facadeBlock facadeObject:facadedObject superClass:[self superclass]];
}

- (id)initWithBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))facadeBlock
       facadeObject:(id)facadedObject superClass:(Class)superClass {

    // Create a clone of this class that uses the given superClass.
    static NSUInteger classCloneCounter = 0;
    NSString *classCloneName = [NSStringFromClass( superClass ) stringByAppendingFormat:@"_PearlBlock%lu", (long)classCloneCounter++];
    Class classClone = objc_allocateClassPair( superClass, classCloneName.UTF8String, 0 );

    unsigned int outCount = 0;
    Method *methods = class_copyMethodList( [self class], &outCount );
    for (NSUInteger m = 0; m < outCount; ++m) {
        SEL methodName = method_getName( methods[m] );
        if (!class_addMethod( classClone, methodName, method_getImplementation( methods[m] ), method_getTypeEncoding( methods[m] ) )) {
            err(@"Failed to add method to proxy class.");
            return nil;
        }
    }
    free( methods );

    objc_registerClassPair( classClone );
    if (!(self = [classClone alloc]))
        return nil;

    objc_setAssociatedObject( self, &facadeBlockKey, facadeBlock, OBJC_ASSOCIATION_COPY );
    objc_setAssociatedObject( self, &facadedObjectKey, facadedObject, OBJC_ASSOCIATION_RETAIN );

    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    id facadedObject = objc_getAssociatedObject( self, &facadedObjectKey );

    // If we have a facade object and it knows this selector, use its signature.
    NSMethodSignature *facadeObjectSignature = [facadedObject methodSignatureForSelector:aSelector];
    if (facadeObjectSignature)
        return facadeObjectSignature;

    // Method doesn't exist.  If the selector looks like a setter, create a signature that takes an object and returns void.
    if ([NSStringFromSelector( aSelector ) isSetter])
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];

    // Default method signature, just create a signature that returns an object and takes no arguments.
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    id facadedObject = objc_getAssociatedObject( self, &facadedObjectKey );
    void (^facadeBlock)(SEL message, id *result, id argument, NSInvocation *invocation) = objc_getAssociatedObject( self, &facadeBlockKey );

    __autoreleasing id result = nil, argument = nil;
    if ([[anInvocation methodSignature] numberOfArguments] > 2)
        [anInvocation getArgument:&argument atIndex:2];

    facadeBlock( anInvocation.selector, &result, argument, anInvocation );

    if ([[anInvocation methodSignature] methodReturnLength])
        [anInvocation setReturnValue:&result];

    if (!result) if ([facadedObject methodSignatureForSelector:anInvocation.selector])
        [anInvocation invokeWithTarget:facadedObject];
}

- (id)valueForKey:(NSString *)key {

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"@@:@"]];
    [invocation setSelector:_cmd];
    [invocation setArgument:&key atIndex:2];

    [self forwardInvocation:invocation];

    __autoreleasing id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (id)valueForKeyPath:(NSString *)key {

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"@@:@"]];
    [invocation setSelector:_cmd];
    [invocation setArgument:&key atIndex:2];

    [self forwardInvocation:invocation];

    __autoreleasing id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

@end

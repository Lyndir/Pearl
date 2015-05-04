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


#import <AVFoundation/AVFoundation.h>

BOOL PearlMainQueue(void (^block)()) {

    if ([NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_async(dispatch_get_main_queue(), block);
    return NO;
}

BOOL PearlMainQueueWait(void (^block)()) {

    if ([NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_group_enter( waitGroup );
    dispatch_async( dispatch_get_main_queue(), ^{
        @try {
            block();
        }
        @finally {
            dispatch_group_leave( waitGroup );
        }
    } );
    dispatch_group_wait( waitGroup, DISPATCH_TIME_FOREVER );
    return NO;
}

NSBlockOperation *PearlMainQueueOperation(void (^block)()) {

  NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:block];
  [[NSOperationQueue mainQueue] addOperation:blockOperation];
  return blockOperation;
}

NSBlockOperation *PearlNotMainQueueOperation(void (^block)()) {

  NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:block];
  NSOperationQueue *queue = [NSOperationQueue currentQueue];
  if (!queue || queue == [NSOperationQueue mainQueue])
    queue = [NSOperationQueue new];
  [queue addOperation:blockOperation];
  return blockOperation;
}

BOOL PearlNotMainQueue(void (^block)()) {

    if (![NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    return NO;
}

BOOL PearlNotMainQueueWait(void (^block)()) {

    if (![NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_group_enter( waitGroup );
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
        @try {
            block();
        }
        @finally {
            dispatch_group_leave( waitGroup );
        }
    } );
    dispatch_group_wait( waitGroup, DISPATCH_TIME_FOREVER );
    return NO;
}

void PearlMainQueueAfter(NSTimeInterval seconds, void (^block)()) {

    return PearlQueueAfter( seconds, dispatch_get_main_queue(), block );
}

void PearlGlobalQueueAfter(NSTimeInterval seconds, void (^block)()) {

    PearlQueueAfter( seconds, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block );
}

void PearlQueueAfter(NSTimeInterval seconds, dispatch_queue_t queue, void (^block)()) {

    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC) ), queue, block );
}

BOOL PearlIfNotRecursing(BOOL *recursing, void(^notRecursingBlock)()) {
    if (*recursing)
        return NO;

    *recursing = YES;
    notRecursingBlock();
    *recursing = NO;
    return YES;
}

NSUInteger PearlHashCode(NSUInteger firstHashCode, ...) {

    va_list objs;
    va_start(objs, firstHashCode);
    NSUInteger hashCode = 0;
    for (NSUInteger nextHashCode = firstHashCode; nextHashCode != (NSUInteger)-1; nextHashCode = va_arg(objs, NSUInteger))
        hashCode = hashCode * 31 + nextHashCode;
    return hashCode;
}

@implementation PearlWeakReference

+ (instancetype)referenceWithObject:(id)object {

    PearlWeakReference *holder = [self new];
    holder.object = object;
    return holder;
}

- (BOOL)isEqual:(id)other {

  return [self.object isEqual:other];
}

- (NSUInteger)hash {

  return [self.object hash];
}

@end

@implementation NSObject(PearlObjectUtils)

- (NSString *)propertyWithValue:(id)value {

    NSString *propertyName = nil;
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList( [self class], &count );
    for (unsigned int p = 0; p < count; ++p) {
        NSString *currentPropertyName = strf(@"%s", property_getName( properties[p] ));
        if ([self valueForKey:currentPropertyName] == value) {
            propertyName = currentPropertyName;
            break;
        }
    }
    free( properties );

    return propertyName;
}

- (void)setStrongAssociatedObject:(id)object forSelector:(SEL)sel {

    objc_setAssociatedObject( self, sel, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)setWeakAssociatedObject:(id)object forSelector:(SEL)sel {

    [self setStrongAssociatedObject:[PearlWeakReference referenceWithObject:object] forSelector:sel];
}

- (id)getAssociatedObjectForSelector:(SEL)sel {

  id object = objc_getAssociatedObject( self, sel );
  return [object isKindOfClass:[PearlWeakReference class]]? ((PearlWeakReference *)object).object: object;
}

@end

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

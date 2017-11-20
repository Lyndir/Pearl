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
#import <objc/message.h>
#import <NSInvocation+CreationHelper.h>

BOOL PearlMainQueue(void (^block)()) {

    if ([NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_async(dispatch_get_main_queue(), block);
    return NO;
}

BOOL PearlNotMainQueue(void (^block)()) {

    if (![NSThread isMainThread]) {
        block();
        return YES;
    }

    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block );
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

id PearlAwait(void (^block)(void (^setResult)(id result))) {

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter( group );
    __block id result = nil;
    block( ^(id result_) {
        @try {
            result = result_;
        } @finally {
            dispatch_group_leave( group );
        }
    } );
    dispatch_group_wait( group, DISPATCH_TIME_FOREVER );

    return result;
}

id PearlMainQueueAwait(id (^block)()) {

    if ([NSThread isMainThread])
        return block();

    __block id result = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter( group );
    dispatch_async( dispatch_get_main_queue(), ^{
        @try {
            result = block();
        } @finally {
            dispatch_group_leave( group );
        }
    } );
    dispatch_group_wait( group, DISPATCH_TIME_FOREVER );

    return result;
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
        SEL proxySel = NSSelectorFromString( strf(@"%@_PearlSwizzleProxy_%@", NSStringFromClass( type ), NSStringFromSelector( toSel ) ) );
        if (!class_addMethod( type, proxySel, PearlForwardIMP(fromMethod, ^(__unsafe_unretained id self, NSInvocation *invocation) {
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
        }), methodTypes ))
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
  
    if (size <= sizeof(id))
        return imp_implementationWithBlock( ^(__unsafe_unretained id self, ...) {
            NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
            invoke( self, invocation );
            return [invocation pointerValue];
      } );
      
    else if (size <= sizeof(CGSize))
        return imp_implementationWithBlock( ^CGSize(__unsafe_unretained id self, ...) {
            NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
            invoke( self, invocation );
            CGSize returnValue = CGSizeZero;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        } );
      
    else if (size <= sizeof(CGRect))
        return imp_implementationWithBlock( ^CGRect(__unsafe_unretained id self, ...) {
            NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
            invoke( self, invocation );
            CGRect returnValue = CGRectZero;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        } );
      
    else if (size <= sizeof(CGAffineTransform))
        return imp_implementationWithBlock( ^CGAffineTransform(__unsafe_unretained id self, ...) {
            NSInvocation *invocation = PearlInvocationMakeWithVargs( self, sel, self );
            invoke( self, invocation );
            CGAffineTransform returnValue = CGAffineTransformIdentity;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        } );
    
    else
        abort();
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

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:PearlNotNull([NSMethodSignature signatureWithObjCTypes:"@@:@"])];
    [invocation setSelector:_cmd];
    [invocation setArgument:&key atIndex:2];

    [self forwardInvocation:invocation];

    __autoreleasing id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (id)valueForKeyPath:(NSString *)key {

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:PearlNotNull([NSMethodSignature signatureWithObjCTypes:"@@:@"])];
    [invocation setSelector:_cmd];
    [invocation setArgument:&key atIndex:2];

    [self forwardInvocation:invocation];

    __autoreleasing id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

@end

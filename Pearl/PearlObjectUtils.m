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

#import "PearlObjectUtils.h"


@interface PearlBlockObject ()

@property (copy) void (^block)(SEL message, id *result, id argument, NSInvocation *invocation);
@property (strong) id facadeObject;

@end

@implementation PearlBlockObject
@synthesize block = _block, facadeObject = _facadeObject;

+ (id)objectWithBlock:(void (^)(SEL, id *, id, NSInvocation *))aBlock {

    return [[self alloc] initWithBlock:aBlock facadeObject:nil];
}

+ (id)facadeFor:(id)facadeObject usingBlock:(void (^)(SEL, id *, id, NSInvocation *))aBlock {

    return [[self alloc] initWithBlock:aBlock facadeObject:facadeObject];
}

- (id)initWithBlock:(void (^)(SEL message, id *result, id argument, NSInvocation *invocation))aBlock
       facadeObject:(id)facade {

    if (!(self = [super init]))
        return nil;

    self.block = aBlock;
    self.facadeObject = facade;

    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    // If we have a facade object and it knows this selector, use its signature.
    NSMethodSignature *facadeObjectSignature = [self.facadeObject methodSignatureForSelector:aSelector];
    if (facadeObjectSignature)
        return facadeObjectSignature;

    // Method doesn't exist.  If the selector looks like a setter, create a signature that takes an object and returns void.
    if ([NSStringFromSelector(aSelector) isSetter])
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];

    // Default method signature, just create a signature that returns an object and takes no arguments.
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    id result = nil, argument = nil;
    if ([[anInvocation methodSignature] numberOfArguments] > 2)
        [anInvocation getArgument:&argument atIndex:2];

    self.block(anInvocation.selector, &result, argument, anInvocation);

    if ([[anInvocation methodSignature] methodReturnLength])
        [anInvocation setReturnValue:&result];

    if (!result)
        if ([self.facadeObject methodSignatureForSelector:anInvocation.selector])
            [anInvocation invokeWithTarget:self.facadeObject];
}

@end

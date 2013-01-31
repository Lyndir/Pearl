//
//  PearlLazy.m
//  MasterPassword-iOS
//
//  Created by Maarten Billemont on 27/05/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearlLazy.h"
#import "PearlLogger.h"
#import <objc/runtime.h>


@interface PearlLazy () {

    BOOL _trace;
    id _object;
    id (^_loadObject)(void);
}

@end

@implementation PearlLazy

+ (id)lazyObjectLoadedFrom:(id(^)(void))loadObject {

    return [self lazyObjectLoadedFrom:loadObject trace:NO];
}

+ (id)lazyObjectLoadedFrom:(id(^)(void))loadObject trace:(BOOL)trace {
    
    return [[PearlLazy alloc] initLoadedFrom:loadObject trace:trace];
}

- (id)initLoadedFrom:(id(^)(void))loadObject trace:(BOOL)trace {

    if (!(self = [super init]))
        return nil;

    _trace = trace;
    _loadObject = [loadObject copy];

    return self;
}

- (id)loadedObject_PearlLazy {

    if (!_object)
        _object = _loadObject();

    return _object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    return [[self loadedObject_PearlLazy] methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    id loadedObject = [self loadedObject_PearlLazy];
    [anInvocation invokeWithTarget:loadedObject];

    if (_trace) {
        NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:anInvocation.methodSignature.numberOfArguments];
        for (NSUInteger a = 2; a < anInvocation.methodSignature.numberOfArguments; a++) {
            // FIXME: Handle non-object argument values.
            id argument = nil;
            [anInvocation getArgument:&argument atIndex:(signed)a];
            [arguments addObject:argument];
        }
        
        // FIXME: Handle non-object return values.
        id returnValue = nil;
        [anInvocation getReturnValue:&returnValue];

        inf(@"-[%@ %@] with %@ returns: %@", [loadedObject class], NSStringFromSelector([anInvocation selector]), arguments, returnValue);
    }
}

@end

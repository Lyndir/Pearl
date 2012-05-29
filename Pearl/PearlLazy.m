//
//  PearlLazy.m
//  MasterPassword-iOS
//
//  Created by Maarten Billemont on 27/05/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearlLazy.h"

@interface PearlLazy () {

    id _object;
    id (^_loadObject)(void);
}

@end

@implementation PearlLazy

+ (id)lazyObjectLoadedFrom:(id(^)(void))loadObject {
    
    return [[PearlLazy alloc] initLoadedFrom:loadObject];
}

- (id)initLoadedFrom:(id(^)(void))loadObject {
    
    if (!(self = [super init]))
        return nil;

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
    
    [anInvocation invokeWithTarget:[self loadedObject_PearlLazy]];
}

@end

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
//  NSObject(PearlKVO)
//
//  Created by Maarten Billemont on 02/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+PearlKVO.h"


@interface PearlBlockObserver_NSObject : NSObject

- (id)initWithBlock:(void(^)(NSString *keyPath, id object, NSDictionary *change, void *context))aBlock;

@end

@implementation PearlBlockObserver_NSObject {

    void(^block)(NSString *keyPath, id object, NSDictionary *change, void *context);
}

- (id)initWithBlock:(void(^)(NSString *keyPath, id object, NSDictionary *change, void *context))aBlock  {

    if (!(self = [super init]))
        return nil;

    block = [aBlock copy];

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (block)
        block(keyPath, object, change, context);
}

@end

@implementation NSObject (PearlKVO)
static char actionBlocksKey;

- (void)addObserverBlock:(void(^)(NSString *keyPath, id object, NSDictionary *change, void *context))observerBlock forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

    NSMutableArray *blockObservers = objc_getAssociatedObject(self, &actionBlocksKey);
        if (!blockObservers)
            objc_setAssociatedObject(self, &actionBlocksKey, blockObservers = [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    PearlBlockObserver_NSObject *handler = [[PearlBlockObserver_NSObject alloc] initWithBlock:observerBlock];
    [self addObserver:handler forKeyPath:keyPath options:options context:context];
    [blockObservers addObject:handler];
}

@end

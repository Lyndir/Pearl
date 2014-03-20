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

@interface PearlBlockObserver_NSObject : NSObject

@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) void (^block)(NSString *, id, NSDictionary *, void *);

@end

@implementation PearlBlockObserver_NSObject

- (id)initWithKeyPath:(NSString *)keyPath block:(void (^)(NSString *keyPath, id object, NSDictionary *change, void *context))block {

    if (!(self = [super init]))
        return nil;

    self.keyPath = keyPath;
    self.block = block;

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (self.block && [keyPath isEqualToString:self.keyPath])
        self.block( keyPath, object, change, context );
}

@end

@implementation NSObject(PearlKVO)

static char actionBlocksKey;

- (id)addObserverBlock:(void (^)(NSString *keyPath, id object, NSDictionary *change, void *context))observerBlock
            forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

    NSMutableArray *blockObservers = objc_getAssociatedObject( self, &actionBlocksKey );
    if (!blockObservers)
        objc_setAssociatedObject( self, &actionBlocksKey, blockObservers = [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    PearlBlockObserver_NSObject *handler = [[PearlBlockObserver_NSObject alloc] initWithKeyPath:keyPath block:observerBlock];
    [self addObserver:handler forKeyPath:keyPath options:options context:context];
    [blockObservers addObject:handler];

    return handler;
}

- (id)observeKeyPath:(NSString *)keyPath withBlock:(void (^)(id from, id to, NSKeyValueChange cause, id _self))block {

    __weak id weakSelf = self;
    return [self addObserverBlock:^(NSString *aKeyPath, id object, NSDictionary *change, void *context) {
        __strong id strongWeakSelf = weakSelf;
        block( change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey], [change[NSKeyValueChangeKindKey] unsignedIntegerValue],
                strongWeakSelf );
    } forKeyPath:keyPath options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)removeKeyPathObservers {

    NSMutableArray *blockObservers = objc_getAssociatedObject( self, &actionBlocksKey );
    if (blockObservers)
        for (PearlBlockObserver_NSObject *handler in blockObservers)
            [self removeObserver:handler forKeyPath:handler.keyPath];
    objc_setAssociatedObject( self, &actionBlocksKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end

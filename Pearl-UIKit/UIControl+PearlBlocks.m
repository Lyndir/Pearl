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
//  UIControl_PearlBlocks
//
//  Created by Maarten Billemont on 02/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import "UIControl+PearlBlocks.h"

@interface PearlActionBlock_UIControl : NSObject

- (id)initWithBlock:(void (^)(id sender, UIControlEvents event, id weakSelf))block weakSelf:(id)weakSelf;

@end

@implementation PearlActionBlock_UIControl {

    void (^_block)(id sender, UIControlEvents event, id weakSelf);
    __weak id _weakSelf;
}

- (id)initWithBlock:(void (^)(id sender, UIControlEvents event, id weakSelf))aBlock weakSelf:(id)weakSelf {

    if (!(self = [super init]))
        return nil;

    _block = [aBlock copy];
    _weakSelf = weakSelf;

    return self;
}

- (void)actionFromSender:(id)sender event:(UIControlEvents)event {

    _block( sender, event, _weakSelf );
}

@end

@implementation UIControl(PearlBlocks)

static char actionBlocksKey;

- (void)addTargetBlock:(void (^)(id sender, UIControlEvents event, id weakSelf))block
      forControlEvents:(UIControlEvents)controlEvents {
  [self addTargetBlock:block forControlEvents:controlEvents forSelf:nil];
}

- (void)addTargetBlock:(void (^)(id sender, UIControlEvents event, id weakSelf))block
      forControlEvents:(UIControlEvents)controlEvents forSelf:(id)weakSelf {

    NSMutableArray *actionBlocks = objc_getAssociatedObject( self, &actionBlocksKey );
    if (!actionBlocks)
        objc_setAssociatedObject( self, &actionBlocksKey, actionBlocks = [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    PearlActionBlock_UIControl *actionBlock = [[PearlActionBlock_UIControl alloc] initWithBlock:block weakSelf:weakSelf];
    [self addTarget:actionBlock action:@selector(actionFromSender:event:) forControlEvents:controlEvents];
    [actionBlocks addObject:actionBlock];
}

@end

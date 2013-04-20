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
//  NSTimer(PearlBlock)
//
//  Created by Maarten Billemont on 2012-09-24.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

@interface PearlBlock_NSTimer : NSObject

- (id)initWithBlock:(void (^)(id userInfo))block;

@end

@implementation PearlBlock_NSTimer {

    void (^block)(id userInfo);
}

- (id)initWithBlock:(void (^)(id userInfo))aBlock {

    if (!(self = [super init]))
        return nil;

    block = [aBlock copy];

    return self;
}

- (void)triggerWithUserInfo:(id)userInfo {

    block( userInfo );
}

@end

@implementation NSTimer(PearlBlock)

static char blockTriggersKey;

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(id))block userInfo:(id)userInfo repeats:(BOOL)yesOrNo {

    PearlBlock_NSTimer *blockTrigger = [[PearlBlock_NSTimer alloc] initWithBlock:block];
    NSTimer *timer = [self timerWithTimeInterval:ti target:blockTrigger selector:@selector(triggerWithUserInfo:)
                                        userInfo:userInfo repeats:yesOrNo];
    objc_setAssociatedObject( timer, &blockTriggersKey, blockTrigger, OBJC_ASSOCIATION_RETAIN );

    return timer;
}

@end

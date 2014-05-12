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

@implementation NSTimer(PearlBlock)

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(NSTimer *))block repeats:(BOOL)yesOrNo {

    return [self timerWithTimeInterval:ti target:self selector:@selector( PearlBlock_firedTimer: )
                              userInfo:@{ @"block" : [block copy] } repeats:yesOrNo];

}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(NSTimer *))block repeats:(BOOL)yesOrNo {

    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector( PearlBlock_firedTimer: )
                                       userInfo:@{ @"block" : [block copy] } repeats:yesOrNo];
}

+ (void)PearlBlock_firedTimer:(NSTimer *)timer {

    void (^block)(NSTimer *) = timer.userInfo[@"block"];
    block( timer );
}

@end

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
//  Created by lhunath on 17/07/11.
//
//  To change this template use File | Settings | File Templates.
//

#import "cocos2d.h"


typedef struct {
    BOOL active;
    char       *keyPath;
    ccTime     elapsed;
    ccTime     duration;
    float      ai;
    float      a;
    float      vi;
    float      v;
    float      from;
    float      current;
    float      to;
    size_t     valueSize;
    NSUInteger valueOffset;
} PropertyTween;

@interface PearlCCAutoTween : CCAction {

    ccTime _duration;
    PropertyTween *_tweens;
    NSUInteger tweenCount;
}

+ (instancetype)actionWithDuration:(ccTime)duration;

- (id)initWithDuration:(ccTime)duration;

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to;
- (void)tweenKeyPath:(NSString *)keyPath
                  to:(float)to valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset;
- (void)tweenKeyPath:(NSString *)keyPath
                  to:(float)to valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset
            duration:(ccTime)t;

@end

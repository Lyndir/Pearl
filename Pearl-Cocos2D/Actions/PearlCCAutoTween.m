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

#import "PearlCCAutoTween.h"

@interface PearlCCAutoTween ()

- (float)valueForKeyPath:(NSString *)keyPath
               valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset;
- (void)setValue:(float)value forKeyPath:(NSString *)keyPath
       valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset;

@end

@implementation PearlCCAutoTween

+ (instancetype)actionWithDuration:(ccTime)duration {

    return [[self alloc] initWithDuration:(ccTime)duration];
}

- (id)initWithDuration:(ccTime)duration {

    if (!(self = [super init]))
        return nil;

    _duration = duration;

    return self;
}

- (void)dealloc {

    free(_tweens);
}

- (void)startWithTarget:(id)aTarget {

    _originalTarget = _target = aTarget;
}

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to {

    [self tweenKeyPath:keyPath to:to valueSize:0 valueOffset:0
              duration:_duration];
}

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to
           valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset {

    [self tweenKeyPath:keyPath to:to valueSize:valueSize valueOffset:valueOffset
              duration:_duration];
}

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to
           valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset
            duration:(ccTime)t {
    
    size_t keyPathStringLength = keyPath.length + 1;
    char *keyPathString = malloc(sizeof(char) * keyPathStringLength);
    [keyPath getCString:keyPathString maxLength:keyPathStringLength encoding:NSUTF8StringEncoding];
    
    float from = [self valueForKeyPath:keyPath
                             valueSize:valueSize valueOffset:valueOffset];
    NSUInteger tw;
    BOOL       reuseTween = NO, resetTween = YES;
    for (tw = 0; tw < tweenCount; ++tw) {
        PropertyTween tween = _tweens[tw];

        if (!tween.active) {
            // Inactive tween, reactivate it.
            reuseTween = YES;
            break;
        } else if (strcmp(tween.keyPath, keyPathString) == 0 && tween.valueSize == valueSize && tween.valueOffset == valueOffset) {
            // Active tween for the key, update it.
            reuseTween = YES;
            resetTween = NO;
            break;
        }
    }
    if (to == from) {
        // Already at target.
        if (!resetTween)
            _tweens[tw].active = NO;

        return;
    }
    if (reuseTween) {
        free(_tweens[tw].keyPath);
    } else {
        // Not updating or reactivating any tweens, make a new tween.
        tw      = tweenCount;
        _tweens = realloc(_tweens, sizeof(PropertyTween) * (++tweenCount));
    }

    PropertyTween tween = _tweens[tw];
    float         vi    = resetTween? 0: tween.v;
    //ai = Sign(to - from) * 2000;
    float         ai    = 2 * ((to - from) - vi * t) / powf(t, 2);
    //ai = resetTween || ai != tween.ai ? ai : tween.a;

    // The acceleration needed to keep up can be too high.
    // The animation gets choppy with high acceleration, but lower acceleration means we can't keep up with our target in the timeframe.
    if (fabsf(ai) > 4000)
        ai = Sign(ai) * 4000;
    float a = ai;
    /*if (!resetTween && fabsf(a - tween.a) > 2000)
        a = tween.a + Sign(a - tween.a) * 2000;*/

//    dbg(@"%f -> %f, v: %f, ai: %f, a: %f", to, from, vi, ai, a);

    _tweens[tw] = (PropertyTween){
//        BOOL active;
     YES,
//        char *keyPath;
     keyPathString,
//        ccTime elapsed;
     0,
//        ccTime duration;
     sqrtf(2 * (to - from) / a),
//        float ai;
     ai,
//        float a;
     a,
//        float vi;
     vi,
//        float v;
     vi,
//        id from;
     from,
//        id current;
     from,
//        id to;
     to,
//        NSUInteger valueSize,
     valueSize,
//        NSUInteger valueOffset,
     valueOffset,
    };
}

- (void)step:(ccTime)dt {

    for (NSUInteger tw = 0; tw < tweenCount; ++tw) {
        PropertyTween tween = _tweens[tw];

        // Skip inactive tweens.
        if (!tween.active)
            continue;

        // Apply dt
        float new = tween.current + tween.v * dt + tween.a * dt * dt / 2.0f;
        tween.elapsed += dt;
        tween.v += tween.a * dt;

        // Current to final.
//        float sLeft     = tween.to - tween.current;         // displacement left.
//        float tLeft     = tween.duration - tween.elapsed;   // time left.

        // Adjust acceleration for arrival.
//        ccTime etaTime           = sLeft / tween.v; //2.0f * ( sLeft - tween.v ) / ( tween.v - tween.vi );
//        float  breakAcceleration = -tween.v / tLeft;        // a needed to get to v=0 after t
//        float  accelTime         = 0.01f;                   // amount of t desired for breaking.

        /*if (tLeft < accelTime)
            tween.a = breakAcceleration;
        else if (etaTime < tLeft)
            tween.a = 0;*/

        // Determine new value.
//        dbg(@"%@[+%d, %f -> %f @ %f]: dt: %f, sLeft: %f, tLeft: %f, etaTime: %f, breakAccel: %f, tween.a: %f, tween.v: %f",
//            tween.keyPath, tween.valueOffset, tween.from, tween.to, new, dt, sLeft, tLeft, etaTime, breakAcceleration, tween.a, tween.v);
        if ((tween.current <= tween.to && new >= tween.to) || (tween.current >= tween.to && new <= tween.to)) {
            // Target is inbetween current and new, or on new, arrive and deactivate.
            new = tween.to;
            tween.active = NO;
        }

        [self setValue:tween.current = new forKeyPath:[NSString stringWithCString:tween.keyPath encoding:NSUTF8StringEncoding]
                                           valueSize:tween.valueSize valueOffset:tween.valueOffset];
        _tweens[tw] = tween;
    }
}

- (float)valueForKeyPath:(NSString *)keyPath
               valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset {

    float fromFloat = 0;

    id target = self.target;
    id from   = [target valueForKeyPath:keyPath];
    if ([from respondsToSelector:@selector(floatValue)])
        fromFloat = [from floatValue];
    else
        if ([from isKindOfClass:[NSValue class]]) {
            void *buf = malloc(valueSize);
            [from getValue:buf];
            memcpy(&fromFloat, buf + valueOffset, sizeof(float));
            free(buf);
        }

    return fromFloat;
}

- (void)setValue:(float)value forKeyPath:(NSString *)keyPath
       valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset {

    id oldValue = [[self target] valueForKeyPath:keyPath], newValue = nil;

    if ([oldValue isKindOfClass:[NSNumber class]])
        newValue = [NSNumber numberWithFloat:value];
    else
        if ([oldValue isKindOfClass:[NSString class]])
            newValue = [NSString stringWithFormat:@"%f", value];
        else
            if ([oldValue isKindOfClass:[NSValue class]]) {
                void *buf = malloc(valueSize);
                [oldValue getValue:buf];
                memcpy(buf + valueOffset, &value, sizeof(float));
                newValue = [NSValue valueWithBytes:buf objCType:[oldValue objCType]];
            }
            else
             err(@"Don't know how to handle: %@, type: %@", oldValue, [oldValue class]);

    [[self target] setValue:newValue forKeyPath:keyPath];
}

- (BOOL)isDone {

    return NO;
}

- (void)stop {

    for (NSUInteger tw = 0; tw < tweenCount; ++tw)
        free(_tweens[tw].keyPath);
    tweenCount = 0;
    _tweens    = realloc(_tweens, 0);

    [super stop];
}

@end

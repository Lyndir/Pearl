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

#import "PearlTween.h"


typedef struct {
    BOOL active;
    char *keyPath;
    NSTimeInterval elapsed;
    NSTimeInterval duration;
    float ai;
    float a;
    float vi;
    float v;
    float from;
    float current;
    float to;
    size_t valueSize;
    NSUInteger valueOffset;
    __unsafe_unretained id target;
} PearlTween;

@implementation NSObject(PearlTween)

static const char PearlTween_timer;
static PearlTween *_tweens = NULL;
static NSUInteger _tweenCount = 0;
static CFAbsoluteTime _lastFiredTime = 0;

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to duration:(NSTimeInterval)duration {

    [self tweenKeyPath:keyPath to:to duration:duration offsetInValue:0 ofSize:0];
}

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to duration:(NSTimeInterval)duration offsetInValue:(NSUInteger)valueOffset
              ofSize:(size_t)valueSize {

    // Get the keyPath as a C string.
    size_t keyPathStringLength = keyPath.length + 1;
    char *keyPathString = malloc( keyPathStringLength );
    [keyPath getCString:keyPathString maxLength:keyPathStringLength encoding:NSUTF8StringEncoding];

    // Get the current value at the keyPath.
    float from = [self valueForKeyPath:keyPath valueSize:valueSize valueOffset:valueOffset];

    // Find a PearlTween to use.
    NSUInteger tw = 0;
    BOOL reuseTween = NO, resetTween = YES;
    for (; tw < _tweenCount; ++tw) {
        PearlTween tween = _tweens[tw];

        if (!tween.active) {
            // Inactive tween, reactivate it.
            reuseTween = YES;
            break;
        }
        else if (strcmp( tween.keyPath, keyPathString ) == 0 && tween.valueSize == valueSize && tween.valueOffset == valueOffset) {
            // Active tween for the key, update it.
            reuseTween = YES;
            resetTween = NO;
            break;
        }
    }
    if (to == from) {
        // Already at target.
        if (reuseTween)
            _tweens[tw].active = NO;
        free( keyPathString );
        return;
    }
    if (reuseTween)
        // Prepare tween for reuse.
        free( _tweens[tw].keyPath );
    else {
        // Make a new tween.
        tw = _tweenCount;
        _tweens = realloc( _tweens, sizeof( PearlTween ) * (++_tweenCount) );
    }

    // Set up our tween.
    PearlTween tween = _tweens[tw];
    float t = (float)duration;
    float vi = resetTween? 0: tween.v;
    //ai = Sign(to - from) * 2000;
    float ai = 2 * ((to - from) - vi * t) / powf( t, 2 );
    //ai = resetTween || ai != tween.ai ? ai : tween.a;

    // The animation gets choppy at excessive acceleration.  Cap the acceleration: this causes the tween to exceed the given duration.
    if (fabsf( ai ) > 4000)
        ai = Sign( ai ) * 4000;
    //float a = ai;
    /*if (!resetTween && fabsf(a - tween.a) > 2000)
        a = tween.a + Sign(a - tween.a) * 2000;*/

//    dbg(@"%f -> %f, v: %f, ai: %f, a: %f", to, from, vi, ai, a);
    _tweens[tw] = (PearlTween){
        YES,                            // BOOL active
        keyPathString,                  // char *keyPath
        0,                              // NSTimeInterval elapsed
        sqrtf( 2 * (to - from) / ai ),  // NSTimeInterval duration
        ai,                             // float ai
        ai,                             // float a
        vi,                             // float vi
        vi,                             // float v
        from,                           // float from
        from,                           // float current
        to,                             // float to
        valueSize,                      // NSUInteger valueSize
        valueOffset,                    // NSUInteger valueOffset
        self,                           // id target
    };

    @synchronized ([NSObject class]) {
        if (![(NSTimer *)objc_getAssociatedObject( [NSObject class], &PearlTween_timer ) isValid]) {
            _lastFiredTime = CFAbsoluteTimeGetCurrent();
            objc_setAssociatedObject( [NSObject class], &PearlTween_timer,
                [NSTimer scheduledTimerWithTimeInterval:1.0 / 60 /* 60 FPS */
                                                 target:[NSObject class] selector:@selector( PearlTween_firedTimer: )
                                               userInfo:nil repeats:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
        }
    }
}

+ (void)PearlTween_firedTimer:(NSTimer *)timer {

    CFAbsoluteTime firedTime = CFAbsoluteTimeGetCurrent();
    float dt = (float)(firedTime - _lastFiredTime);
    _lastFiredTime = firedTime;

    BOOL deactivate = YES;
    for (NSUInteger tw = 0; tw < _tweenCount; ++tw) {
        PearlTween tween = _tweens[tw];

        // Skip inactive tweens.
        if (!tween.active)
            continue;
        deactivate = NO;

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

        [tween.target setValue:tween.current = new forKeyPath:[NSString stringWithCString:tween.keyPath encoding:NSUTF8StringEncoding]
                     valueSize:tween.valueSize valueOffset:tween.valueOffset];
        _tweens[tw] = tween;
    }

    if (deactivate)
        [timer invalidate];
}

- (float)valueForKeyPath:(NSString *)keyPath
               valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset {

    float fromFloat = 0;

    id from = [self valueForKeyPath:keyPath];
    if ([from respondsToSelector:@selector( floatValue )])
        fromFloat = [from floatValue];
    else if ([from isKindOfClass:[NSValue class]]) {
        void *buf = malloc( valueSize );
        [from getValue:buf];
        memcpy( &fromFloat, buf + valueOffset, sizeof( float ) );
        free( buf );
    }

    return fromFloat;
}

- (void)setValue:(float)value forKeyPath:(NSString *)keyPath
       valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset {

    id oldValue = [self valueForKeyPath:keyPath], newValue = nil;

    if ([oldValue isKindOfClass:[NSNumber class]])
        newValue = [NSNumber numberWithFloat:value];
    else if ([oldValue isKindOfClass:[NSString class]])
        newValue = [NSString stringWithFormat:@"%f", value];
    else if ([oldValue isKindOfClass:[NSValue class]]) {
        void *buf = malloc( valueSize );
        [oldValue getValue:buf];
        memcpy( buf + valueOffset, &value, sizeof( float ) );
        newValue = [NSValue valueWithBytes:buf objCType:[oldValue objCType]];
        // FIXME: Leaks buf.
    }
    else
        err( @"Don't know how to handle: %@, type: %@", oldValue, [oldValue class] );

    [self setValue:newValue forKeyPath:keyPath];
    if ([self respondsToSelector:@selector( didTweenKeyPath: )])
        [(id<PearlTweenDelegate>)self didTweenKeyPath:keyPath];
}

@end

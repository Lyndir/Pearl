//
//  Created by lhunath on 17/07/11.
//
//  To change this template use File | Settings | File Templates.
//

#import "cocos2d.h"


typedef struct {
    BOOL active;
    NSString *keyPath;
    ccTime elapsed;
    ccTime duration;
    float ai;
    float a;
    float vi;
    float v;
    float from;
    float current;
    float to;
    size_t valueSize;
    NSUInteger valueOffset;
} PropertyTween;

@interface PearlCCAutoTween : CCAction {

    ccTime _duration;
    PropertyTween *_tweens;
    NSUInteger tweenCount;
}

+ (PearlCCAutoTween *)actionWithDuration:(ccTime )duration;

- (id)initWithDuration:(ccTime )duration;

- (void)tweenKeyPath:(NSString *)keyPath to:(float)to;
- (void)tweenKeyPath:(NSString *)keyPath
                  to:(float)to valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset;
- (void)tweenKeyPath:(NSString *)keyPath
                  to:(float)to valueSize:(size_t)valueSize valueOffset:(NSUInteger)valueOffset
            duration:(ccTime)t;

@end

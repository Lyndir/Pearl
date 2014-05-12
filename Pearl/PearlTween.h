/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

@protocol PearlTweenDelegate

@optional
- (void)didTweenKeyPath:(NSString *)keyPath;

@end

@interface NSObject(PearlTween)

/** Tween the float value at the given keyPath of the receiver to the given value over the given duration. */
- (void)tweenKeyPath:(NSString *)keyPath to:(float)to duration:(NSTimeInterval)duration;
/** Tween the float value at the offset in the value at given keyPath of the receiver to the given value over the given duration. */
- (void)tweenKeyPath:(NSString *)keyPath to:(float)to duration:(NSTimeInterval)duration
       offsetInValue:(NSUInteger)valueOffset ofSize:(size_t)valueSize;

@end

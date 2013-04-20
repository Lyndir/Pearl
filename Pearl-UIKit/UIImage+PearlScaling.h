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
//  UIImage+PearlScaling.h
//  Pearl
//
//  Created by Maarten Billemont on 30/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(PearlScaling)

+ (UIImage *)imageNamed:(NSString *)imageName inSquareScalingHeight:(CGFloat)height;
+ (UIImage *)imageNamed:(NSString *)imageName inSquareScalingWidth:(CGFloat)width;
+ (UIImage *)imageNamed:(NSString *)imageName inSizeScalingHeight:(CGSize)size;
+ (UIImage *)imageNamed:(NSString *)imageName inSizeScalingWidth:(CGSize)size;
+ (UIImage *)imageNamed:(NSString *)imageName scaleInto:(CGSize)scaleSize cropTo:(CGSize)cropSize;

- (UIImage *)imageInSquareScalingHeight:(CGFloat)height;
- (UIImage *)imageInSquareScalingWidth:(CGFloat)width;
- (UIImage *)imageInSizeScalingHeight:(CGSize)size;
- (UIImage *)imageInSizeScalingWidth:(CGSize)size;
- (UIImage *)imageScaledInto:(CGSize)scaleSize cropTo:(CGSize)cropSize;

/** Scale an image such that its entire content fits in the given size.
 *
 * We scale until either the width or the height fills the image while the other either also fills the image or is smaller. */
- (UIImage *)imageByScalingAndFittingInSize:(CGSize)targetSize;
/** Scale an image such that its entire content fills the given size.
 *
 * We scale until either the width or the height fills the image while the other either also fills the image or is larger and cropping the excess. */
- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)targetSize;

@end

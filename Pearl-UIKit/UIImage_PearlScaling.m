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
//  UIImage_PearlScaling.m
//  Pearl
//
//  Created by Maarten Billemont on 30/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//
//  http://stackoverflow.com/questions/603907/uiimage-resize-then-crop/605385#605385
//


@implementation UIImage (PearlScaling)

- (UIImage *)imageByScalingAndFittingInSize:(CGSize)targetSize {

    CGFloat widthFactor  = targetSize.width / self.size.width;
    CGFloat heightFactor = targetSize.height / self.size.height;

    CGFloat scaleFactor = fminf(widthFactor, heightFactor);
    CGSize  scaledSize  = CGSizeMake(self.size.width * scaleFactor,
                                     self.size.height * scaleFactor);
    UIGraphicsBeginImageContext(scaledSize);

    CGRect thumbnailRect;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size   = scaledSize;

    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (newImage == nil)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Couldn't scale image"];

    return newImage;
}


- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)targetSize {

    if (CGSizeEqualToSize(self.size, targetSize))
        return self;

    CGFloat widthFactor  = targetSize.width / self.size.width;
    CGFloat heightFactor = targetSize.height / self.size.height;

    CGFloat scaleFactor = fmaxf(widthFactor, heightFactor);
    CGSize  scaledSize  = CGSizeMake(self.size.width * scaleFactor,
                                     self.size.height * scaleFactor);

    // center the image
    CGPoint thumbnailPoint = CGPointZero;
    if (widthFactor > heightFactor)
        thumbnailPoint.y = (targetSize.height - scaledSize.height) / 2;
    else
        if (widthFactor < heightFactor)
            thumbnailPoint.x = (targetSize.width - scaledSize.width) / 2;

    UIGraphicsBeginImageContext(targetSize); // this will crop

    CGRect thumbnailRect;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size   = scaledSize;

    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (newImage == nil)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Couldn't scale image"];

    return newImage;
}

@end

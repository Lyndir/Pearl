/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
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

#import "UIImage_PearlScaling.h"


@implementation UIImage (PearlScaling)

- (UIImage*)imageByScalingAndFittingInSize:(CGSize)targetSize {
    
    CGFloat widthFactor     = targetSize.width / self.size.width;
    CGFloat heightFactor    = targetSize.height / self.size.height;

    CGFloat scaleFactor     = fminf(widthFactor, heightFactor);
    CGSize scaledSize       = CGSizeMake(self.size.width * scaleFactor,
                                         self.size.height * scaleFactor);
    UIGraphicsBeginImageContext(scaledSize);
    
    CGRect thumbnailRect;
    thumbnailRect.origin    = CGPointZero;
    thumbnailRect.size      = scaledSize;
    
    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Couldn't scale image"];
    
    return newImage;
}


- (UIImage*)imageByScalingAndCroppingToSize:(CGSize)targetSize {
    
    if (CGSizeEqualToSize(self.size, targetSize))
        return self;
    
    CGFloat widthFactor     = targetSize.width / self.size.width;
    CGFloat heightFactor    = targetSize.height / self.size.height;
        
    CGFloat scaleFactor     = fmaxf(widthFactor, heightFactor);
    CGSize scaledSize       = CGSizeMake(self.size.width * scaleFactor,
                                         self.size.height * scaleFactor);
        
    // center the image
    CGPoint thumbnailPoint  = CGPointZero;
    if (widthFactor > heightFactor)
        thumbnailPoint.y    = (targetSize.height - scaledSize.height) / 2; 
    else if (widthFactor < heightFactor)
        thumbnailPoint.x    = (targetSize.width - scaledSize.width) / 2;
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect;
    thumbnailRect.origin    = thumbnailPoint;
    thumbnailRect.size      = scaledSize;
    
    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if(newImage == nil)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Couldn't scale image"];
    
    return newImage;
}

@end

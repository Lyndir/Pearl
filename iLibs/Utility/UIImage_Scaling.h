//
//  UIImage_Scaling.h
//  iLibs
//
//  Created by Maarten Billemont on 30/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Scaling)

/** Scale an image such that its entire content fits in the given size.
 *
 * We scale until either the width or the height fills the image while the other either also fills the image or is smaller. */
- (UIImage*)imageByScalingAndFittingInSize:(CGSize)targetSize;
/** Scale an image such that its entire content fills the given size.
 *
 * We scale until either the width or the height fills the image while the other either also fills the image or is larger and cropping the excess. */
- (UIImage*)imageByScalingAndCroppingToSize:(CGSize)targetSize;
    
@end

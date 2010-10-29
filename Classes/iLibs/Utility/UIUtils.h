//
//  UIUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIUtils : NSObject {

}

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 */
+ (void)autoSizeContent:(UIScrollView *)scrollView;

/**
 * Create a rectangle that describes the given view's frame in the coordinates of the top-level view that contains it.
 */
+ (CGRect)frameInWindow:(UIView *)view;

@end

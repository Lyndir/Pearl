//
//  UIUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIUtils : NSObject {

}

/**
 * Automatically determines and sets the content size of the given scroll view.
 * The scroll region is padded by using the content frame's top/left offset as padding for the bottom/right.
 *
 * @return The calculated CGRect that frames the scroll view's content.
 */
+ (CGRect)autoSizeContent:(UIScrollView *)scrollView;

@end

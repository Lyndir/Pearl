//
//  UIUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import "UIUtils.h"


@implementation UIUtils

+ (CGRect)autoSizeContent:(UIScrollView *)scrollView {

    // Remove last two subviews; they belong to the scrollView's scroller, I believe.
    // FIXME: This is kind of clumsy and will break when subviews are added programmatically.
    NSMutableArray *subviews = [scrollView.subviews mutableCopy];
    [subviews removeLastObject];
    [subviews removeLastObject];
    
    // Determine content frame.
    CGRect contentRect = ((UIView *)[subviews lastObject]).frame;
    for (UIView *view in subviews)
        contentRect = CGRectUnion(contentRect, view.frame);
    
    // Add right/bottom padding by adding left/top offset to the size.
    CGRect paddedRect = CGRectMake(contentRect.origin.x, contentRect.origin.y,
                                   contentRect.size.width   + fmaxf(0, contentRect.origin.x) * 2,
                                   contentRect.size.height  + fmaxf(0, contentRect.origin.y) * 2);
    
    // Apply rect to scrollView's content definition.
    scrollView.contentOffset = CGPointZero;
    scrollView.contentSize = paddedRect.size;
    
    return contentRect;
}

@end

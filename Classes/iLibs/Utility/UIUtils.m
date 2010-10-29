//
//  UIUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import "UIUtils.h"
#import "Logger.h"


@interface UIUtils ()

+ (void)keyboardWillHide:(NSNotification *)n;
+ (void)keyboardWillShow:(NSNotification *)n;

@end


@implementation UIUtils

static UIScrollView *keyboardScrollView;
static CGPoint      keyboardScrollOriginalOffset;
static CGRect       keyboardScrollOriginalFrame;

+ (void)autoSizeContent:(UIScrollView *)scrollView {

    // === Step 1: Calculate the UIScrollView's contentSize.
    
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

    // === Step 2: Manage the scroll view on keyboard notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:scrollView.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:scrollView.window];
    keyboardScrollView = scrollView;
}

+ (CGRect)frameInWindow:(UIView *)view {
    
    return [view.window convertRect:view.bounds fromView:view];
}

+ (void)keyboardWillHide:(NSNotification *)n {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];

    keyboardScrollView.contentOffset    = keyboardScrollOriginalOffset;
    keyboardScrollView.frame            = keyboardScrollOriginalFrame;
    
    [UIView commitAnimations];
}

+ (void)keyboardWillShow:(NSNotification *)n {
    
    NSDictionary* userInfo = [n userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect scrollRect   = [self frameInWindow:keyboardScrollView];
    CGRect hiddenRect   = CGRectIntersection(scrollRect, keyboardRect);
    
    keyboardScrollOriginalOffset            = keyboardScrollView.contentOffset;
    keyboardScrollOriginalFrame             = keyboardScrollView.frame;
    CGPoint keyboardScrollNewOffset         = keyboardScrollOriginalOffset;
    keyboardScrollNewOffset.y               += keyboardRect.size.height / 2;
    CGRect keyboardScrollNewFrame           = keyboardScrollView.frame;
    keyboardScrollNewFrame.size.height      -= hiddenRect.size.height;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];

    keyboardScrollView.contentOffset    = keyboardScrollNewOffset;
    keyboardScrollView.frame            = keyboardScrollNewFrame;
    
    [UIView commitAnimations];
}

@end

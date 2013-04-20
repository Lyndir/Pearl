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
//  PearlLayout.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlLayout.h"

@interface PearlLayout()

@property(nonatomic, readwrite, retain) UIScrollView *scrollView;
@property(nonatomic, readwrite, retain) UIView *contentView;
@property(nonatomic, readwrite, retain) UIView *lastChild;

@end

@implementation PearlLayout

@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;
@synthesize lastChild = _lastChild;

- (id)init {

    if (!(self = [self initWithView:[[UIScrollView alloc] init]]))
        return nil;

    return self;
}

- (id)initWithView:(UIView *)aView {

    if (!(self = [super init]))
        return self;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect contentFrame = applicationFrame;
    contentFrame.origin = CGPointZero;

    self.scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    self.contentView = aView;
    self.contentView.frame = contentFrame;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.scrollView addSubview:self.contentView];

    return self;
}

- (PearlLayout *)addLogo {

    return [self addLogo:nil];
}

- (PearlLayout *)addLogo:(UIImage *)logoImage {

    UIImageView *logo = [[UIImageView alloc] initWithImage:logoImage];
    [logo setCenter:CGPointMake( self.contentView.frame.size.width / 2, logo.frame.size.height / 2 )];
    [logo setAutoresizingMask:
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin];

    return [self add:logo];
}

- (PearlLayout *)addMax:(UIView *)newView {

    return [self addMax:newView top:-1];
}

- (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top {

    return [self addMax:newView top:top minus:0];
}

- (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus {

    return [self addMax:newView top:top minus:minus usingDefault:-1];
}

- (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus usingDefault:(CGFloat)d {

    CGFloat y = top;
    if (y == d) {
        if (self.lastChild)
            y = [self.lastChild frame].origin.y + [self.lastChild frame].size.height + PearlLayoutPadding;
        else
            y = 20;
    }

    [newView setFrame:CGRectMake( 0,
            y,
            self.contentView.frame.size.width,
            self.scrollView.frame.size.height / 1 - y - PearlLayoutPadding - minus )];

    return [self add:newView usingDefault:-1];
}

- (PearlLayout *)addSpace:(CGFloat)space {

    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 0, space )];
    return [self add:spaceView];
}

- (PearlLayout *)add:(UIView *)newView {

    return [self add:newView usingDefault:0];
}

- (PearlLayout *)add:(UIView *)newView usingDefault:(CGFloat)d {

    // Calculate some defaults for frame values that are set to d.
    CGFloat x = newView.frame.origin.x;
    CGFloat y = newView.frame.origin.y;
    CGFloat w = newView.frame.size.width;
    CGFloat h = newView.frame.size.height;
    if (w == d)
        w = self.contentView.frame.size.width;
    if (h == d)
        h = 30;
    if (x == d)
        x = (self.contentView.bounds.size.width - w) / 2;
    if (y == d) {
        if (self.lastChild)
            y = self.lastChild.frame.origin.y + self.lastChild.frame.size.height + PearlLayoutPadding;
        else
            y = 20;
    }

    newView.frame = CGRectMake( x, y, w, h );
    [self.contentView addSubview:newView];

    self.lastChild = newView;

    return self;
}

@end

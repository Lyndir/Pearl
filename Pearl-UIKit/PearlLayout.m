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
//  PearlLayout.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlLayout.h"

@interface PearlLayout ()

@property (nonatomic, readwrite, retain) UIScrollView   *scrollView;
@property (nonatomic, readwrite, retain) UIView         *contentView;
@property (nonatomic, readwrite, retain) UIView         *lastChild;

@end


@implementation PearlLayout

@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;
@synthesize lastChild = _lastChild;



- (id)init {
    
    if(!(self = [self initWithView:[[[UIScrollView alloc] init] autorelease]]))
        return nil;

    return self;
}


- (id)initWithView:(UIView *)aView {
    
    if(!(self = [super init]))
        return self;

    CGRect applicationFrame     = [[UIScreen mainScreen] applicationFrame];
    CGRect contentFrame         = applicationFrame;
    contentFrame.origin         = CGPointZero;

    self.scrollView                  = [[[UIScrollView alloc] initWithFrame:applicationFrame] autorelease];
    self.contentView                 = aView;
    self.contentView.frame           = contentFrame;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.scrollView addSubview:self.contentView];
    
    return self;
}


- (PearlLayout *)addLogo {
    
    return [self addLogo:nil];
}


- (PearlLayout *)addLogo:(UIImage *)logoImage {

    UIImageView *logo   = [[[UIImageView alloc] initWithImage:logoImage] autorelease];
    [logo setCenter:CGPointMake(self.contentView.frame.size.width / 2, logo.frame.size.height / 2)];
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
    if(y == d) {
        if (self.lastChild)
            y = [self.lastChild frame].origin.y + [self.lastChild frame].size.height + PearlLayoutPadding;
        else
            y = 20;
    }

    [newView setFrame:CGRectMake(0,
                                 y,
                                 self.contentView.frame.size.width,
                                 self.scrollView.frame.size.height / 1 - y - PearlLayoutPadding - minus)];
    
    return [self add:newView usingDefault:-1];
}


- (PearlLayout *)addSpace:(CGFloat)space {
    
    UIView *spaceView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, space)] autorelease];
    return [self add: spaceView];
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
    if(w == d)
        w = self.contentView.frame.size.width;
    if(h == d)
        h = 30;
    if(x == d)
        x = (self.contentView.bounds.size.width - w) / 2;
    if(y == d) {
        if (self.lastChild)
            y = self.lastChild.frame.origin.y + self.lastChild.frame.size.height + PearlLayoutPadding;
        else
            y = 20;
    }
    
    newView.frame = CGRectMake(x, y, w, h);
    [self.contentView addSubview:newView];

    self.lastChild = newView;
    
    return self;
}


- (void)dealloc {
    
    self.scrollView = nil;
    self.contentView = nil;
    self.lastChild = nil;
    
    [super dealloc];
}

@end

//
//  Layout.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "Layout.h"


@interface Layout ()

@property (readwrite, retain) UIScrollView     *scrollView;
@property (readwrite, retain) UIView           *contentView;
@property (readwrite, retain) UIView  *lastChild;

@end


@implementation Layout

@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;
@synthesize lastChild = _lastChild;



- (id)init {
    
    if(!(self = [self initWithView:[[UIScrollView alloc] init]]))
        return self;

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


- (Layout *)addLogo {
    
    return [self addLogo:nil];
}


- (Layout *)addLogo:(UIImage *)logoImage {

    UIImageView *logo   = [[[UIImageView alloc] initWithImage:logoImage] autorelease];
    [logo setCenter:CGPointMake(self.contentView.frame.size.width / 2, logo.frame.size.height / 2)];
    [logo setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin];
    
    return [self add:logo];
}


- (Layout *)addMax:(UIView *)newView {

    return [self addMax:newView top:-1];
}


- (Layout *)addMax:(UIView *)newView top:(CGFloat)top {
    
    return [self addMax:newView top:top minus:0];
}


- (Layout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus {
    
    return [self addMax:newView top:top minus:minus usingDefault:-1];
}


- (Layout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus usingDefault:(CGFloat)d {

    CGFloat y = top;
    if(y == d) {
        if (self.lastChild)
            y = [self.lastChild frame].origin.y + [self.lastChild frame].size.height + kPadding;
        else
            y = 20;
    }

    [newView setFrame:CGRectMake(0,
                                 y,
                                 self.contentView.frame.size.width,
                                 self.scrollView.frame.size.height / 1 - y - kPadding - minus)];
    
    return [self add:newView usingDefault:-1];
}


- (Layout *)addSpace:(CGFloat)space {
    
    UIView *spaceView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, space)] autorelease];
    return [self add: spaceView];
}


- (Layout *)add:(UIView *)newView {
    
    return [self add:newView usingDefault:0];
}


- (Layout *)add:(UIView *)newView usingDefault:(CGFloat)d {
    
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
            y = self.lastChild.frame.origin.y + self.lastChild.frame.size.height + kPadding;
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

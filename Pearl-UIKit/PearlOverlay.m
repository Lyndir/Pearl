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
//  PearlOverlay.h
//  PearlOverlay
//
//  Created by lhunath on 2013-04-03.
//  Copyright, lhunath (Maarten Billemont) 2013. All rights reserved.
//

#import "PearlOverlay.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PearlOverlay()

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) UITextView *titleView;

@end

@implementation PearlOverlay

static __strong PearlOverlay *activeOverlay = nil;

+ (PearlOverlay *)activeOverlay {

    return activeOverlay;
}

- (id)initWithTitle:(NSString *)title {

    if (!(self = [super init]))
        return nil;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    _title = title;
    _overlayView = [[UIView alloc] initWithFrame:CGRectInCGRectWithSizeAndPadding(
            window.bounds, CGSizeMake( CGFLOAT_MAX, 120 ), CGFLOAT_MAX, 20, 20, 20 )];
    _overlayView.backgroundColor = [UIColor colorWithRGBAHex:0x000000AA];
    _overlayView.layer.cornerRadius = 10;

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_overlayView addSubview:_activityIndicator];
    [_activityIndicator setFrameFromCurrentSizeAndParentPaddingTop:20 right:CGFLOAT_MAX bottom:CGFLOAT_MAX left:CGFLOAT_MAX];
    [_activityIndicator startAnimating];

    _titleView = [UITextView new];
    [_overlayView addSubview:_titleView];
    CGPoint activityIndicatorBottom = CGPointFromCGRectBottom( _activityIndicator.frame );
    [_titleView setFrameFromSize:CGSizeMake( CGFLOAT_MAX, CGFLOAT_MAX )
             andParentPaddingTop:activityIndicatorBottom.y + 10 right:20 bottom:20 left:20];
    _titleView.text = title;
    _titleView.textColor = [UIColor whiteColor];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.font = [UIFont boldSystemFontOfSize:16];
    _titleView.backgroundColor = [UIColor clearColor];

    return self;
}

+ (instancetype)showOverlayWithTitle:(NSString *)title {

    return [[[self alloc] initWithTitle:title] showOverlay];
}

- (PearlOverlay *)showOverlay {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.overlayView];

    return self;
}

- (BOOL)isVisible {

    return self.overlayView.superview != nil;
}

- (PearlOverlay *)cancelOverlay {

    [self.overlayView removeFromSuperview];

    return self;
}

@end

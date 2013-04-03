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

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    _title = title;
    _overlayView = [[UIView alloc] initWithFrame:CGRectFromCGPointAndCGSize(
            CGPointFromCGRectCenter( window.bounds ),
            CGSizeMake( window.bounds.size.width - 40, 200 ) )];
    _overlayView.backgroundColor = [UIColor colorWithRGBAHex:0x000000AA];
    _overlayView.layer.cornerRadius = 10;

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.frame = CGRectSetY( _activityIndicator.frame, CGPointFromCGRectTop( _overlayView.bounds ).y + 20 );
    [_activityIndicator startAnimating];
    [_overlayView addSubview:_activityIndicator];

    _titleView = [UITextView new];
    _titleView.text = title;
    _titleView.textColor = [UIColor whiteColor];
    _titleView.frame = CGRectSetWidth( _titleView.frame, _overlayView.bounds.size.width );
    _titleView.frame = CGRectSetY( _titleView.frame, CGPointFromCGRectBottom( _activityIndicator.frame ).y + 20 );
    [_overlayView addSubview:_titleView];

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

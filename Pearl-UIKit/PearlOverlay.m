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

    PearlMainThread(^{
        _title = title;
        _overlayView = [[UIView alloc] initWithFrame:CGRectInCGRectWithSizeAndPadding(
                UIApp.keyWindow.bounds, CGSizeMake( CGFLOAT_MAX, 120 ), CGFLOAT_MAX, 20, 20, 20 )];
        _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66f];
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
    });

    return self;
}

+ (instancetype)showOverlayWithTitle:(NSString *)title {

    return [[[self alloc] initWithTitle:title] showOverlay];
}

- (PearlOverlay *)showOverlay {

    __weak UIView *overlayView = self.overlayView;
    PearlMainThread(^{
        [UIApp.keyWindow addSubview:overlayView];
        overlayView.superview.userInteractionEnabled = NO;

        overlayView.alpha = 0;
        CGRectSetY( overlayView.frame, overlayView.frame.origin.y + 10 );
        [UIView animateWithDuration:0.3f animations:^{
            overlayView.alpha = 1;
            CGRectSetY( overlayView.frame, overlayView.frame.origin.y - 10 );
        }];
    });

    return self;
}

- (BOOL)isVisible {

    return self.overlayView.superview != nil;
}

- (PearlOverlay *)cancelOverlayAnimated:(BOOL)animated {

    __weak UIView *overlayView = self.overlayView;
    PearlMainThread(^{
        overlayView.superview.userInteractionEnabled = YES;

        if (!animated)
            [overlayView removeFromSuperview];
        else {
            [UIView animateWithDuration:0.3f animations:^{
                overlayView.alpha = 0;
                CGRectSetY( overlayView.frame, overlayView.frame.origin.y + 10 );
            }                completion:^(BOOL finished) {
                [overlayView removeFromSuperview];
            }];
        }
    });

    return self;
}

@end

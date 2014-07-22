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

#import "UIView+Touches.h"

@interface PearlOverlay()

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) UITextView *titleView;
@property(nonatomic, copy) BOOL (^cancelOnTouch)(void);

@end

@implementation PearlOverlay

+ (NSMutableArray *)activeOverlays {

    static NSMutableArray *activeOverlays = nil;
    if (!activeOverlays)
        activeOverlays = [[NSMutableArray alloc] initWithCapacity:3];

    return activeOverlays;
}

- (id)initWithTitle:(NSString *)title withActivity:(BOOL)activity cancelOnTouch:(BOOL (^)(void))cancelOnTouch {

    if (!(self = [super init]))
        return nil;

    self.cancelOnTouch = cancelOnTouch;
  
    PearlMainQueue( ^{
        self.title = title;
        self.backgroundView = [[UIView alloc] initWithFrame:[UIApp.windows[0] bounds]];
        self.backgroundView.backgroundColor = self.cancelOnTouch? [UIColor colorWithWhite:0 alpha:0.3f]: [UIColor clearColor];
        self.backgroundView.ignoreTouches = !self.cancelOnTouch;
        if (self.cancelOnTouch)
          [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTap:)]];

        self.overlayView = [UIView new];
        self.overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        self.overlayView.layer.cornerRadius = 8;
        [self.backgroundView addSubview:self.overlayView];

        self.titleView = [UITextView new];
        self.titleView.text = title;
        self.titleView.textColor = [UIColor whiteColor];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        self.titleView.font = [UIFont boldSystemFontOfSize:16];
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.overlayView addSubview:self.titleView];
        [self.titleView sizeToFit];

        if (activity) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self.activityIndicator startAnimating];
            [self.overlayView addSubview:self.activityIndicator];
            [self.activityIndicator sizeToFit];
        }

        [self.overlayView setFrameFromSize:CGSizeMake( CGFLOAT_MAX, 16 + self.titleView.frame.size.height + self.activityIndicator.frame.size.height )
                   andParentPaddingTop:CGFLOAT_MAX right:20 bottom:20 left:20];
        [self.titleView setFrameFromSize:CGSizeMake( CGFLOAT_MAX, CGFLOAT_MIN )
                 andParentPaddingTop:CGFLOAT_MAX right:20 bottom:8 left:20];
        [self.activityIndicator setFrameFromCurrentSizeAndParentPaddingTop:8 right:CGFLOAT_MAX bottom:CGFLOAT_MAX left:CGFLOAT_MAX];
    } );

    return self;
}

- (void)didRecognizeTap:(UITapGestureRecognizer *)didRecognizeTap {
  if (didRecognizeTap.state == UIGestureRecognizerStateEnded && self.cancelOnTouch)
    if (self.cancelOnTouch())
      [self cancelOverlayAnimated:YES];
}

+ (instancetype)showProgressOverlayWithTitle:(NSString *)title {

    return [self showProgressOverlayWithTitle:title cancelOnTouch:^BOOL{ return NO; }];
}

+ (instancetype)showProgressOverlayWithTitle:(NSString *)title cancelOnTouch:(BOOL (^)(void))cancelOnTouch {

    return [[[self alloc] initWithTitle:title withActivity:YES cancelOnTouch:cancelOnTouch] showOverlay];
}

+ (instancetype)showTemporaryOverlayWithTitle:(NSString *)title dismissAfter:(NSTimeInterval)seconds {

    PearlOverlay *overlay = [[[self alloc] initWithTitle:title withActivity:NO cancelOnTouch:nil] showOverlay];
    PearlMainQueueAfter( seconds, ^{
        [overlay cancelOverlayAnimated:YES];
    } );

    return overlay;
}

- (PearlOverlay *)showOverlay {

    PearlMainQueue( ^{
        [UIApp.windows[0] addSubview:self.backgroundView];

        self.backgroundView.alpha = 0;
        CGRectSetY( self.backgroundView.frame, self.backgroundView.frame.origin.y + 10 );
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = 1;
            CGRectSetY( self.backgroundView.frame, self.backgroundView.frame.origin.y - 10 );
        }];

        [(NSMutableArray *)[PearlOverlay activeOverlays] addObject:self];
    } );

    return self;
}

- (BOOL)isVisible {

    return self.backgroundView.superview != nil;
}

- (PearlOverlay *)cancelOverlayAnimated:(BOOL)animated {

    Weakify(self);
    PearlMainQueue( ^{
        Strongify( self );

        if (!animated) {
            [self.backgroundView removeFromSuperview];
            [((NSMutableArray *)[PearlOverlay activeOverlays]) removeObject:self];
        }

        else {
            [UIView animateWithDuration:0.3f animations:^{
                self.backgroundView.alpha = 0;
                CGRectSetY( self.backgroundView.frame, self.backgroundView.frame.origin.y + 10 );
            }                completion:^(BOOL finished) {
                [self.backgroundView removeFromSuperview];
                [((NSMutableArray *)[PearlOverlay activeOverlays]) removeObject:self];
            }];
        }
    } );

    return self;
}

@end

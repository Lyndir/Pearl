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
//  PearlRootViewController.m
//  Gorillas
//
//  Created by Maarten Billemont on 12/11/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlRootViewController.h"
#import "PearlUIUtils.h"
#import "PearlAppDelegate.h"

@interface PearlRootViewController()

@property(nonatomic, retain) NSMutableArray *mySupportedIterfaceOrientations;

@end

@implementation PearlRootViewController

static NSString *NSStringFromUIInterfaceOrientation(UIInterfaceOrientation orientation) {

    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return @"UIInterfaceOrientationPortrait";
        case UIInterfaceOrientationPortraitUpsideDown:
            return @"UIInterfaceOrientationPortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:
            return @"UIInterfaceOrientationLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:
            return @"UIInterfaceOrientationLandscapeRight";
#ifdef __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
            return @"UIInterfaceOrientationUnknown";
#endif
    }

    err(@"Unsupported interface orientation: %ld", (long)orientation);
    return nil;
}

- (id)init {

    if (!(self = [super init]))
        return self;

    if (!self.title)
        self.title = @"Root View Controller";

    self.mySupportedIterfaceOrientations = [NSMutableArray array];
    [self supportInterfaceOrientationString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UIInterfaceOrientation"]];
    for (NSString *interfaceOrientation in [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations"])
        [self supportInterfaceOrientationString:interfaceOrientation];

    return self;
}

- (id)initWithView:(UIView *)aView {

    if (!(self = [self init]))
        return self;

    self.view = aView;

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (!(self = [super initWithCoder:aDecoder]))
        return self;

    if (!self.title)
        self.title = @"Root View Controller";

    self.mySupportedIterfaceOrientations = [NSMutableArray array];
    [self supportInterfaceOrientationString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UIInterfaceOrientation"]];
    for (NSString *interfaceOrientation in [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations"])
        [self supportInterfaceOrientationString:interfaceOrientation];

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return self;

    if (!self.title)
        self.title = @"Root View Controller";

    self.mySupportedIterfaceOrientations = [NSMutableArray array];
    [self supportInterfaceOrientationString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UIInterfaceOrientation"]];
    for (NSString *interfaceOrientation in [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations"])
        [self supportInterfaceOrientationString:interfaceOrientation];

    return self;
}

- (void)loadView {

    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.view.transform = CGAffineTransformIdentity;
    switch (UIApp.statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.view.transform = CGAffineTransformMakeRotation( (CGFloat)M_PI_2 );
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.view.transform = CGAffineTransformMakeRotation( (CGFloat)-M_PI_2 );
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.view.transform = CGAffineTransformMakeRotation( (CGFloat)M_PI );
            break;
        default:
            self.view.transform = CGAffineTransformMakeRotation( 0.0f );
            break;
    }

    self.view.center = CGPointMultiply( CGPointFromCGSize( self.view.frame.size ), 0.5 );
}

- (BOOL)isInterfaceOrientationSupported:(UIInterfaceOrientation)interfaceOrientation {

    for (NSNumber *supportedInterfaceOrientation in self.mySupportedIterfaceOrientations)
        if ([supportedInterfaceOrientation unsignedIntValue] == interfaceOrientation)
            return YES;

    return NO;
}

- (void)supportInterfaceOrientationString:(NSString *)interfaceOrientation {

    if ([@"UIInterfaceOrientationPortrait" isEqualToString:interfaceOrientation])
        [self supportInterfaceOrientation:UIInterfaceOrientationPortrait];
    else if ([@"UIInterfaceOrientationPortraitUpsideDown" isEqualToString:interfaceOrientation])
        [self supportInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown];
    else if ([@"UIInterfaceOrientationLandscapeLeft" isEqualToString:interfaceOrientation])
        [self supportInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    else if ([@"UIInterfaceOrientationLandscapeRight" isEqualToString:interfaceOrientation])
        [self supportInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    if (![self isInterfaceOrientationSupported:interfaceOrientation])
        [self.mySupportedIterfaceOrientations addObject:@(interfaceOrientation)];
}

- (void)rejectInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    for (NSNumber *supportedInterfaceOrientation in self.mySupportedIterfaceOrientations)
        if ([supportedInterfaceOrientation unsignedIntValue] == interfaceOrientation) {
            [self.mySupportedIterfaceOrientations removeObject:supportedInterfaceOrientation];
            return;
        }
}

- (NSUInteger)supportedInterfaceOrientations {

    NSUInteger supportedInterfaceOrientations = 0;
    for (NSNumber *supportedInterfaceOrientation in self.mySupportedIterfaceOrientations)
        supportedInterfaceOrientations |= [supportedInterfaceOrientation unsignedIntegerValue];

    return supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return (UIInterfaceOrientation)[(self.mySupportedIterfaceOrientations)[0] unsignedIntegerValue];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

    dbg(@"didRotateFrom: %@, to: %@", NSStringFromUIInterfaceOrientation( fromInterfaceOrientation ), NSStringFromUIInterfaceOrientation(
            UIApp.statusBarOrientation ));
    [[PearlAppDelegate get] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end

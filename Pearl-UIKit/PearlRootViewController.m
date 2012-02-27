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
//  PearlRootViewController.m
//  Gorillas
//
//  Created by Maarten Billemont on 12/11/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlRootViewController.h"
#import "PearlAppDelegate.h"


@implementation PearlRootViewController
@synthesize supportedIterfaceOrientations = _supportedIterfaceOrientations;

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
    }
    
    err(@"Unsupported interface orientation: %d", orientation);
    return nil;
}

- (id)init {
    
    if (!(self = [super init]))
        return self;
    
    if (!self.title)
        self.title = @"Root View Controller";

    self.supportedIterfaceOrientations = [NSMutableArray array];
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

    self.supportedIterfaceOrientations = [NSMutableArray array];
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

    self.supportedIterfaceOrientations = [NSMutableArray array];
    [self supportInterfaceOrientationString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UIInterfaceOrientation"]];
    for (NSString *interfaceOrientation in [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations"])
        [self supportInterfaceOrientationString:interfaceOrientation];
    
    return self;
}

- (void)loadView {
    
    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    self.view.transform = CGAffineTransformIdentity;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.view.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.view.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.view.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
            break;
        default:
            self.view.transform = CGAffineTransformMakeRotation(0.0f);
            break;
    }
    
    self.view.center = CGPointFromCGSizeCenter(self.view.frame.size);
}

- (BOOL)isInterfaceOrientationSupported:(UIInterfaceOrientation)interfaceOrientation {
    
    for (NSNumber *supportedInterfaceOrientation in self.supportedIterfaceOrientations)
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
        [self.supportedIterfaceOrientations addObject:[NSNumber numberWithUnsignedInt:interfaceOrientation]];
}

- (void)rejectInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    for (NSNumber *supportedInterfaceOrientation in self.supportedIterfaceOrientations)
        if ([supportedInterfaceOrientation unsignedIntValue] == interfaceOrientation) {
            [self.supportedIterfaceOrientations removeObject:supportedInterfaceOrientation];
            return;
        }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL rotate = [self isInterfaceOrientationSupported:interfaceOrientation];
    dbg(@"shouldAutorotateTo: %@ = %@", NSStringFromUIInterfaceOrientation(interfaceOrientation), rotate? @"YES": @"NO");
    
    return rotate;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    dbg(@"didRotateFrom: %@, to: %@", NSStringFromUIInterfaceOrientation(fromInterfaceOrientation), NSStringFromUIInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation));
    [[PearlAppDelegate get] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end

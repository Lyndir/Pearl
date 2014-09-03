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
//  PearlNavigationController.h
//  PearlNavigationController
//
//  Created by lhunath on 2013-04-15.
//  Copyright, lhunath (Maarten Billemont) 2013. All rights reserved.
//

#import "PearlNavigationController.h"

@implementation PearlNavigationController {
    NSNumber *_shouldAutorotate;
    NSNumber *_supportedInterfaceOrientations;
    NSNumber *_preferredInterfaceOrientationForPresentation;
}

- (BOOL)shouldAutorotate {

    if (self.forwardInterfaceRotation && self.topViewController)
        return [self.topViewController shouldAutorotate];

    if (_shouldAutorotate)
        return [_shouldAutorotate boolValue];

    return [super shouldAutorotate];
}

- (void)setShouldAutorotate:(BOOL)shouldAutorotate {

    _shouldAutorotate = @(shouldAutorotate);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    if (self.forwardInterfaceRotation && self.topViewController)
        return [self.topViewController supportedInterfaceOrientations];

    if (_supportedInterfaceOrientations)
        return [_supportedInterfaceOrientations unsignedIntegerValue];

    return [super supportedInterfaceOrientations];
}

- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations {

    _supportedInterfaceOrientations = @(supportedInterfaceOrientations);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    UIInterfaceOrientation preferredInterfaceOrientationForPresentation = 0;
    UIInterfaceOrientationMask supportedInterfaceOrientations = [self supportedInterfaceOrientations];

    if (self.forwardInterfaceRotation && self.topViewController) {
        if (1 << (preferredInterfaceOrientationForPresentation = [self.topViewController preferredInterfaceOrientationForPresentation]) &
            supportedInterfaceOrientations)
            return preferredInterfaceOrientationForPresentation;
    }

    if (_preferredInterfaceOrientationForPresentation) {
        if (1 << (preferredInterfaceOrientationForPresentation = [_preferredInterfaceOrientationForPresentation integerValue]) &
            supportedInterfaceOrientations)
            return preferredInterfaceOrientationForPresentation;
    }

    if (1 << (preferredInterfaceOrientationForPresentation = [super preferredInterfaceOrientationForPresentation]) &
        supportedInterfaceOrientations)
        return preferredInterfaceOrientationForPresentation;

    if (1 << (preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait) &
        supportedInterfaceOrientations)
        return preferredInterfaceOrientationForPresentation;

    if (1 << (preferredInterfaceOrientationForPresentation = UIInterfaceOrientationLandscapeLeft) &
        supportedInterfaceOrientations)
        return preferredInterfaceOrientationForPresentation;

    if (1 << (preferredInterfaceOrientationForPresentation = UIInterfaceOrientationLandscapeRight) &
        supportedInterfaceOrientations)
        return preferredInterfaceOrientationForPresentation;

    if (1 << (preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortraitUpsideDown) &
        supportedInterfaceOrientations)
        return preferredInterfaceOrientationForPresentation;

    Throw( @"No preferred orientation supports the supported orientations: %d", supportedInterfaceOrientations );
}

- (void)setPreferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    _preferredInterfaceOrientationForPresentation = @(preferredInterfaceOrientationForPresentation);
}

@end

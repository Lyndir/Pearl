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
}

- (UINavigationController *)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {

    if (!(self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]))
        return nil;

    [self initDefaults];

    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {

    if (!(self = [super initWithRootViewController:rootViewController]))
        return nil;

    [self initDefaults];

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;

    [self initDefaults];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {

    if (!(self = [super initWithCoder:coder]))
        return nil;

    [self initDefaults];

    return self;
}

- (id)init {

    if (!(self = [super init]))
        return nil;

    [self initDefaults];

    return self;
}

- (void)initDefaults {

    self.shouldAutorotate = [super shouldAutorotate];
    self.supportedInterfaceOrientations = [super supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {

    return self.forwardInterfaceRotation? [self.topViewController shouldAutorotate]: _shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {

    return self.forwardInterfaceRotation? [self.topViewController supportedInterfaceOrientations]: _supportedInterfaceOrientations;
}

@end

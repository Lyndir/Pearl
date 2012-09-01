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
//  PearlAbstractAppDelegate.h
//  Pearl
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PearlAppDelegate : UIResponder<UIApplicationDelegate, PearlConfigDelegate> {

    UIWindow               *_window;
    UINavigationController *_navigationController;
}

@property (nonatomic, readwrite, retain) IBOutlet UIWindow               *window;
@property (nonatomic, readwrite, retain) IBOutlet UINavigationController *navigationController;

- (void)preSetup;

- (void)didUpdateConfigForKey:(SEL)configKey fromValue:(id)value;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (IBAction)restart;
- (void)shutdown:(id)caller;

- (void)showFeedback;
- (void)showReview;

+ (PearlAppDelegate *)get;


@end


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
//  PearlAbstractAppDelegate.m
//  Pearl
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "PearlAppDelegate.h"
#import "PearlLogger.h"
#import "PearlConfig.h"
#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif
#import "PearlResettable.h"
#ifdef PEARL_UIKIT
#import "PearlAlert.h"
#import "PearlRootViewController.h"
#endif
#import "PearlCodeUtils.h"
#ifdef PEARL_WITH_MESSAGEUI
#import "PearlEMail.h"
#endif

#ifndef ITMS_REVIEW_URL
#define ITMS_REVIEW_URL(__id) [NSURL URLWithString:[NSString stringWithFormat:\
@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", __id]]
#endif
#ifndef ITMS_APP_URL
#define ITMS_APP_URL(__app) [NSURL URLWithString:[NSString stringWithFormat:\
@"itms://itunes.com/apps/%@", __app]]
#endif

@implementation PearlAppDelegate
@synthesize window = _window, navigationController = _navigationController;

- (id)init {

    if (!(self = [super init]))
        return nil;

    [PearlConfig get].delegate = self;

    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Log application details.
    NSString *name        = [PearlInfoPlist get].CFBundleName;
    NSString *displayName = [PearlInfoPlist get].CFBundleDisplayName;
    NSString *build       = [PearlInfoPlist get].CFBundleVersion;
    NSString *version     = [PearlInfoPlist get].CFBundleShortVersionString;
    NSString *description = [PearlInfoPlist get].GITDescription;

    if (!name)
        name    = displayName;
    if (displayName && ![displayName isEqualToString:name])
        name    = [NSString stringWithFormat:@"%@ (%@)", displayName, name];
    if (!version)
        version = build;
    if (build && ![build isEqualToString:version])
        version = [NSString stringWithFormat:@"%@ (%@)", version, build];
    if (description)
        version = [NSString stringWithFormat:@"%@ (GIT: %@)", version, description];

    inf(@"%@ %@", name, version);

#ifdef PEARL_WITH_APNS
    if ([[PearlConfig get].supportedNotifications unsignedIntegerValue])
        [application registerForRemoteNotificationTypes:[[PearlConfig get].supportedNotifications unsignedIntegerValue]];
#endif

    // Start the background music.
    [self preSetup];

    return NO;
}


- (void)preSetup {

#ifdef PEARL_MEDIA
    if ([[PearlConfig get].currentTrack isEqualToString:@"sequential"]) {
        // Restart sequentially from the start.
        [PearlConfig get].playingTrack = nil;
        [[PearlAudioController get] playTrack:@"sequential"];
    } else
        [[PearlAudioController get] playTrack:[PearlConfig get].currentTrack];
#endif

    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#ifdef PEARL_UIKIT
        self.window.rootViewController = [PearlRootViewController new];
#endif
    }
    if (!self.navigationController && [self.window.rootViewController isKindOfClass:[UINavigationController class]])
        self.navigationController = (UINavigationController *)self.window.rootViewController;
}

- (void)didUpdateConfigForKey:(SEL)configKey fromValue:(id)value {

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

}

- (void)restart {

    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
#ifdef PEARL_UIKIT
    [[PearlAlert activeAlerts] makeObjectsPerformSelector:@selector(dismissAlert)];
#endif
}

- (void)showFeedback {

#ifdef PEARL_WITH_MESSAGEUI
    [PearlEMail sendEMailTo:nil subject:PearlString(@"Feedback for %@", [PearlInfoPlist get].CFBundleName) body:nil];
#endif
}

- (void)showReview {

    if (NSNullToNil([PearlConfig get].iTunesID))
        [[UIApplication sharedApplication] openURL:ITMS_REVIEW_URL([PearlConfig get].iTunesID)];
    else
        [[UIApplication sharedApplication] openURL:ITMS_APP_URL([PearlInfoPlist get].CFBundleName)];
}

- (void)shutdown:(id)caller {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

#ifdef PEARL_UIKIT
    [PearlConfig get].launchCount = [NSNumber numberWithInt:[[PearlConfig get].launchCount intValue] + 1];
    if ([[PearlConfig get].askForReviews boolValue]) // Review asking enabled?
        if (![[PearlConfig get].reviewedVersion isEqualToString:[PearlInfoPlist get].CFBundleVersion]) // Version reviewed?
            if (!([[PearlConfig get].launchCount intValue] % [[PearlConfig get].reviewAfterLaunches intValue])) // Sufficiently used?
                    [PearlAlert showAlertWithTitle:[PearlStrings get].reviewTitle
                                           message:PearlString([PearlStrings get].reviewMessage, [PearlInfoPlist get].CFBundleDisplayName)
                                         viewStyle:UIAlertViewStyleDefault
                                         initAlert:nil tappedButtonBlock:^(UIAlertView *alert_, NSInteger buttonIndex_) {
                        if (buttonIndex_ == [alert_ firstOtherButtonIndex] + 1) {
                            // Comment
                            [self showFeedback];
                            return;
                        }

                        [PearlConfig get].reviewedVersion = [PearlInfoPlist get].CFBundleVersion;
                        if (buttonIndex_ == [alert_ cancelButtonIndex])
                            // No
                            return;

                        if (buttonIndex_ == [alert_ firstOtherButtonIndex]) {
                            // Yes
                            [self showReview];
                        }
                    }                  cancelTitle:[PearlStrings get].reviewNo
                                       otherTitles:[PearlStrings get].reviewYes, [PearlStrings get].reviewComment, nil];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:"
                                 userInfo:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

#ifdef PEARL_MEDIA
    [[PearlAudioController get] playTrack:nil];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)applicationSignificantTimeChange:(UIApplication *)application {

}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation
           duration:(NSTimeInterval)duration {

}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {

}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {

}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {

}

#ifdef PEARL_WITH_APNS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [PearlConfig get].deviceToken            = deviceToken;
    [PearlConfig get].notificationsSupported = YES;
    [PearlConfig get].notificationsChecked   = YES;

    dbg(@"APN Device Token Hex: %@", [deviceToken encodeHex]);
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

    [PearlConfig get].notificationsSupported = NO;
    [PearlConfig get].notificationsChecked   = YES;

    wrn(@"Couldn't register with the APNs: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}
#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}

- (void)applicationDidEnterBackground:(UIApplication *)application __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_4_0) {

}

- (void)applicationWillEnterForeground:(UIApplication *)application __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_4_0) {

}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {

}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {

}

+ (PearlAppDelegate *)get {

    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate isKindOfClass:[self class]])
        return (PearlAppDelegate *)delegate;

    return nil;
}


@end

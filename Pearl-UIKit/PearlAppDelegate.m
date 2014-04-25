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

#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif
#ifdef PEARL_UIKIT
#import <StoreKit/StoreKit.h>
#import "PearlUIUtils.h"
#ifndef ITMS_REVIEW_URL
#define ITMS_REVIEW_URL(__id) [NSURL URLWithString:[NSString stringWithFormat: \
SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") \
? @"itms-apps://itunes.apple.com/app/id%@" \
: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@", __id]]
#endif
#ifndef ITMS_APP_URL
#define ITMS_APP_URL(__app) [NSURL URLWithString:[NSString stringWithFormat:\
@"itms://itunes.com/apps/%@", __app]]
#endif
#endif
#ifdef PEARL_WITH_MESSAGEUI
#endif

@interface PearlAppDelegate()<SKStoreProductViewControllerDelegate>
@end

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
    NSString *name = [PearlInfoPlist get].CFBundleName;
    NSString *displayName = [PearlInfoPlist get].CFBundleDisplayName;
    NSString *build = [PearlInfoPlist get].CFBundleVersion;
    NSString *version = [PearlInfoPlist get].CFBundleShortVersionString;
    NSString *description = [PearlInfoPlist get].GITDescription;

    if (!name)
        name = displayName;
    if (displayName && ![displayName isEqualToString:name])
        name = [NSString stringWithFormat:@"%@ (%@)", displayName, name];
    if (!version)
        version = build;
    if (build && ![build isEqualToString:version])
        version = [NSString stringWithFormat:@"%@ (%@)", version, build];
    if (description)
        version = [NSString stringWithFormat:@"%@ (GIT: %@)", version, description];

    NSString *profileString;
    NSData *provisioningProfileData = [NSData dataWithContentsOfFile:
            [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"]];
    if (!provisioningProfileData)
        profileString = @"No profile.";
    else {
        NSRange startRange = [provisioningProfileData rangeOfData:[@"<?xml" dataUsingEncoding:NSASCIIStringEncoding] options:0
                                                            range:NSMakeRange( 0, [provisioningProfileData length] )];
        NSRange endRange = [provisioningProfileData rangeOfData:[@"</plist>" dataUsingEncoding:NSASCIIStringEncoding] options:0
                                                          range:NSMakeRange( 0, [provisioningProfileData length] )];
        provisioningProfileData = [provisioningProfileData subdataWithRange:
                NSMakeRange( startRange.location, endRange.location + endRange.length - startRange.location )];

        NSString *profileError = nil;
        NSDictionary *provisioningProfile = [NSPropertyListSerialization propertyListFromData:provisioningProfileData
                                                                             mutabilityOption:NSPropertyListImmutable
                                                                                       format:nil errorDescription:&profileError];
        if (profileError)
            profileString = profileError;
        else
            profileString = PearlString( @"%@ (%@, devices: %ld, UUID: %@)", provisioningProfile[@"Name"],
                    [provisioningProfile[@"Entitlements"][@"get-task-allow"] boolValue]? @"debug": @"release",
                    (long)[provisioningProfile[@"ProvisionedDevices"] count], provisioningProfile[@"UUID"] );
    }
    inf(@"%@ %@ on platform: %@, profile: %@", name, version, [PearlDeviceUtils platform], profileString);

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
    }
    else
        [[PearlAudioController get] playTrack:[PearlConfig get].currentTrack];
#endif

    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#ifdef PEARL_UIKIT
        //self.window.rootViewController = [PearlRootViewController new];
#endif
        [self.window makeKeyAndVisible];
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
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
#ifdef PEARL_UIKIT
    [[PearlAlert activeAlerts] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj cancelAlertAnimated:YES];
    }];
#endif
}

- (void)showFeedback {

#ifdef PEARL_WITH_MESSAGEUI
    [PearlEMail sendEMailTo:nil fromVC:nil subject:PearlString( @"Feedback for %@", [PearlInfoPlist get].CFBundleName ) body:nil];
#endif
}

- (void)showReview {

    [self showReview:[[PearlConfig get].reviewInApp boolValue]];
}

- (void)showReview:(BOOL)allowInApp {

    if (!allowInApp || !NSClassFromString( @"SKStoreProductViewController" )) {
        if (NSNullToNil([PearlConfig get].iTunesID)) {
            inf(@"Opening App Store for review of iTunesID: %@", [PearlConfig get].iTunesID);
            [UIApp openURL:ITMS_REVIEW_URL([PearlConfig get].iTunesID)];
        }
        else {
            inf(@"Opening App Store for app with iTunesID: %@", [PearlConfig get].iTunesID);
            [UIApp openURL:ITMS_APP_URL([PearlInfoPlist get].CFBundleName)];
        }
        return;
    }

    @try {
        inf(@"Opening in-app store page for app with iTunesID: %@", [PearlConfig get].iTunesID);
        SKStoreProductViewController *storeViewController = [SKStoreProductViewController new];
        storeViewController.delegate = self;
        [storeViewController loadProductWithParameters:@{
                SKStoreProductParameterITunesItemIdentifier : [PearlConfig get].iTunesID
        }                              completionBlock:^(BOOL result, NSError *error) {
            if (!result) {
                err(@"Failed to load in-app details for iTunesID: %@, %@", [PearlConfig get].iTunesID, error);
                [self showReview:NO];
                return;
            }
        }];
        [self.window.rootViewController presentViewController:storeViewController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        err(@"Exception while loading in-app details for iTunesID: %@, %@", [PearlConfig get].iTunesID, exception);
        [self showReview:NO];
    }
}

- (void)shutdown:(id)caller {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

#ifdef PEARL_UIKIT
    [PearlConfig get].launchCount = @([[PearlConfig get].launchCount intValue] + 1);
    if ([[PearlConfig get].askForReviews boolValue] && [PearlConfig get].iTunesID) // Review asking enabled?
    if (![[PearlConfig get].reviewedVersion isEqualToString:[PearlInfoPlist get].CFBundleVersion]) // Version reviewed?
    if (!([[PearlConfig get].launchCount intValue] % [[PearlConfig get].reviewAfterLaunches intValue])) // Sufficiently used?
        [PearlAlert showAlertWithTitle:[PearlStrings get].reviewTitle
                               message:PearlString( [PearlStrings get].reviewMessage, [PearlInfoPlist get].CFBundleDisplayName )
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
                           otherTitles:[PearlStrings get].reviewYes, [PearlStrings get].reviewIssue, nil];
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

    return NO;
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

+ (instancetype)get {

    id delegate = UIApp.delegate;
    if ([delegate isKindOfClass:[self class]])
        return delegate;

    return nil;
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {

    dbg(@"Done with in-app product view.");
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

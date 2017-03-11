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

#import <StoreKit/StoreKit.h>

static NSURL *iTunesReviewURL(NSString *__id) {

    return [NSURL URLWithString:
            [NSString stringWithFormat:
                    SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"7.0" )
                    ? @"itms-apps://itunes.apple.com/app/id%@"
                    : @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?"
                            @"onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@", __id]];
}

static NSURL *iTunesAppURL(NSString *__app) {

    return [NSURL URLWithString:[NSString stringWithFormat:@"itms://itunes.com/apps/%@", __app]];
}

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
    NSString *provisioningProfilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    NSData *provisioningProfileData = provisioningProfilePath? [NSData dataWithContentsOfFile:provisioningProfilePath]: nil;
    if (!provisioningProfileData)
        profileString = @"No profile.";
    else {
        NSRange startRange = [provisioningProfileData rangeOfData:PearlNotNull( [@"<?xml" dataUsingEncoding:NSASCIIStringEncoding] )
                                                          options:0 range:NSMakeRange( 0, [provisioningProfileData length] )];
        NSRange endRange = [provisioningProfileData rangeOfData:PearlNotNull( [@"</plist>" dataUsingEncoding:NSASCIIStringEncoding] )
                                                        options:0 range:NSMakeRange( 0, [provisioningProfileData length] )];
        provisioningProfileData = [provisioningProfileData subdataWithRange:
                NSMakeRange( startRange.location, endRange.location + endRange.length - startRange.location )];

        NSError *profileError = nil;
        NSDictionary *provisioningProfile = [NSPropertyListSerialization propertyListWithData:provisioningProfileData
                                                                                      options:NSPropertyListImmutable format:nil
                                                                                        error:&profileError];
        if (profileError)
            profileString = [profileError description];
        else
            profileString = strf( @"%@ (%@, devices: %ld, UUID: %@)", provisioningProfile[@"Name"],
                    [provisioningProfile[@"Entitlements"][@"get-task-allow"] boolValue]? @"debug": @"release",
                    (long)[provisioningProfile[@"ProvisionedDevices"] count], provisioningProfile[@"UUID"] );
    }
    inf( @"%@ %@ on platform: %@, profile: %@", name, version, [PearlDeviceUtils platform], profileString );

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
        //self.window.rootViewController = [PearlRootViewController new];
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
    [[PearlAlert activeAlerts] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj cancelAlertAnimated:YES];
    }];
}

- (void)showFeedback {

#ifdef PEARL_WITH_MESSAGEUI
    [PearlEMail sendEMailTo:nil fromVC:nil subject:strf( @"Feedback for %@", [PearlInfoPlist get].CFBundleName ) body:nil];
#endif
}

- (void)showReview {

#ifdef PEARL_WITH_STOREKIT
    [self showReview:[[PearlConfig get].reviewInApp boolValue]];
}

- (void)showReview:(BOOL)allowInApp {

    if (!allowInApp || !NSClassFromString( @"SKStoreProductViewController" ) || !NSNullToNil( [PearlConfig get].appleID )) {
#endif
        if (NSNullToNil( [PearlConfig get].appleID )) {
            inf( @"Opening App Store for review of Apple ID: %@", [PearlConfig get].appleID );
            [UIApp openURL:PearlNotNull( iTunesReviewURL( [PearlConfig get].appleID ) )];
        }
        else {
            inf( @"Opening App Store for app with name: %@", [PearlInfoPlist get].CFBundleName );
            [UIApp openURL:PearlNotNull( iTunesAppURL( [PearlInfoPlist get].CFBundleName ) )];
        }
        return;
#ifdef PEARL_WITH_STOREKIT
    }

    @try {
        inf( @"Opening in-app store page for app with Apple ID: %@", [PearlConfig get].appleID );
        SKStoreProductViewController *storeViewController = [SKStoreProductViewController new];
        storeViewController.delegate = self;
        [storeViewController loadProductWithParameters:@{
                SKStoreProductParameterITunesItemIdentifier : [PearlConfig get].appleID
        }                              completionBlock:^(BOOL result, NSError *error) {
            if (!result) {
                err( @"Failed to load in-app details for Apple ID: %@, %@", [PearlConfig get].appleID, [error fullDescription] );
                [self showReview:NO];
                return;
            }
        }];
        [self.window.rootViewController presentViewController:storeViewController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        err( @"Exception while loading in-app details for Apple ID: %@, %@", [PearlConfig get].appleID, [exception fullDescription] );
        [self showReview:NO];
    }
#endif
}

- (void)shutdown:(id)caller {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [PearlConfig get].launchCount = @([[PearlConfig get].launchCount intValue] + 1);
    if ([[PearlConfig get].askForReviews boolValue] && [PearlConfig get].appleID) // Review asking enabled?
    if (![[PearlConfig get].reviewedVersion isEqualToString:[PearlInfoPlist get].CFBundleVersion]) // Version reviewed?
    if (!([[PearlConfig get].launchCount intValue] % [[PearlConfig get].reviewAfterLaunches intValue])) // Sufficiently used?
        [PearlAlert showAlertWithTitle:[PearlStrings get].reviewTitle
                               message:strf( [PearlStrings get].reviewMessage, [PearlInfoPlist get].CFBundleDisplayName )
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
                }          cancelTitle:[PearlStrings get].reviewNo
                           otherTitles:[PearlStrings get].reviewYes, [PearlStrings get].reviewIssue, nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:"
                                 userInfo:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return NO;
}

#pragma clang diagnostic pop

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

- (void)applicationDidEnterBackground:(UIApplication *)application __OSX_AVAILABLE_STARTING( __MAC_NA, __IPHONE_4_0 ) {
}

- (void)applicationWillEnterForeground:(UIApplication *)application __OSX_AVAILABLE_STARTING( __MAC_NA, __IPHONE_4_0 ) {
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

    dbg( @"Done with in-app product view." );
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

//
// Created by Maarten Billemont on 2017-05-08.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import "PearlLinks.h"

@implementation PearlLinks

+ (BOOL)openSettings {

    return [self openPrefs:nil];
}

+ (BOOL)openSettingsAbout {

    return [self openPrefs:@"root=General&path=About"];
}

+ (BOOL)openSettingsAccessibility {

    return [self openPrefs:@"root=General&path=ACCESSIBILITY"];
}

+ (BOOL)openSettingsAccountSettings {

    return [self openPrefs:@"root=ACCOUNT_SETTINGS"];
}

+ (BOOL)openSettingsAirplaneMode {

    return [self openPrefs:@"root=AIRPLANE_MODE"];
}

+ (BOOL)openSettingsApplePay {

    return [self openPrefs:@"shoebox://url-scheme"];
}

+ (BOOL)openSettingsBluetooth {

    return [self openPrefs:@"root=Bluetooth"];
}

+ (BOOL)openSettingsGeneral {

    return [self openPrefs:@"root=General"];
}

+ (BOOL)openSettingsMusic {

    return [self openPrefs:@"root=MUSIC"];
}

+ (BOOL)openSettingsKeyboard {

    return [self openPrefs:@"root=General&path=Keyboard"];
}

+ (BOOL)openSettingsLocationServices {

    return [self openPrefs:@"root=LOCATION_SERVICES"];
}

+ (BOOL)openSettingsNetwork {

    return [self openPrefs:@"root=General&path=Network"];
}

+ (BOOL)openSettingsSounds {

    return [self openPrefs:@"root=Sounds"];
}

+ (BOOL)openSettingsSoftwareUpdate {

    return [self openPrefs:@"root=General&path=SOFTWARE_UPDATE_LINK"];
}

+ (BOOL)openSettingsStore {

    return [self openPrefs:@"root=STORE"];
}

+ (BOOL)openSettingsWIFI {

    return [self openPrefs:@"root=WIFI"];
}

+ (BOOL)openPrefs:(NSString *)prefsPath {

    NSURL *url = [NSURL URLWithString:strf( @"prefs:%@", prefsPath?: @"" )];
    if ([self openURL:url])
        return YES;

    url = [NSURL URLWithString:strf( @"App-Prefs:%@", prefsPath?: @"" )];
    if ([self openURL:url])
        return YES;

    return NO;
}

+ (BOOL)openURL:(NSURL *)url {

    if (![UIApp canOpenURL:url])
        return NO;

    if ([UIApp respondsToSelector:@selector( openURL:options:completionHandler: )]) {
        [UIApp openURL:url options:@{} completionHandler:nil];
        return YES;
    }

    if ([UIApp respondsToSelector:@selector( openURL: )])
        return [UIApp openURL:url];

    return NO;
}

@end

//
// Created by Maarten Billemont on 2017-05-08.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PearlLinks : NSObject

+ (BOOL)openSettings;
+ (BOOL)openSettingsAbout;
+ (BOOL)openSettingsAccessibility;
+ (BOOL)openSettingsAccountSettings;
+ (BOOL)openSettingsAirplaneMode;
+ (BOOL)openSettingsApplePay;
+ (BOOL)openSettingsBluetooth;
+ (BOOL)openSettingsGeneral;
+ (BOOL)openSettingsMusic;
+ (BOOL)openSettingsKeyboard;
+ (BOOL)openSettingsLocationServices;
+ (BOOL)openSettingsNetwork;
+ (BOOL)openSettingsSounds;
+ (BOOL)openSettingsSoftwareUpdate;
+ (BOOL)openSettingsStore;
+ (BOOL)openSettingsWIFI;

+ (BOOL)openPrefs:(NSString *)prefsPath;
+ (BOOL)openURL:(NSURL *)url;

@end

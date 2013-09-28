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
//  PearlInfoPlist.m
//  MasterPassword
//
//  Created by Maarten Billemont on 05/02/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

NSComparisonResult PearlCFBundleVersionCompare(NSString *bundleVersion1, NSString *bundleVersion2) {

    NSArray *bundleVersion1Components = [bundleVersion1 componentsSeparatedByString:@"."];
    NSArray *bundleVersion2Components = [bundleVersion2 componentsSeparatedByString:@"."];
    for (NSUInteger i = 0; i < MAX([bundleVersion1Components count], [bundleVersion2Components count]); ++i) {
        if (i >= [bundleVersion1Components count])
                // 1 has too few elements.
            return NSOrderedAscending;
        if (i >= [bundleVersion2Components count])
                // 2 has too few elements.
            return NSOrderedDescending;

        NSString *bundleVersion1Element = bundleVersion1Components[i];
        NSString *bundleVersion2Element = bundleVersion2Components[i];

        NSComparisonResult comparison = [bundleVersion1Element compare:bundleVersion2Element];
        if (comparison != NSOrderedSame)
            return comparison;
    }

    return NSOrderedSame;
}

@implementation PearlInfoPlist

@dynamic GITDescription;
@dynamic CFBundleAllowMixedLocalizations;
@dynamic CFBundleDevelopmentRegion;
@dynamic CFBundleDisplayName;
@dynamic CFBundleDocumentTypes;
@dynamic CFBundleExecutable;
@dynamic CFBundleIconFile;
@dynamic CFBundleIconFiles;
@dynamic CFBundleIcons;
@dynamic CFBundleIdentifier;
@dynamic CFBundleInfoDictionaryVersion;
@dynamic CFBundleLocalizations;
@dynamic CFBundleName;
@dynamic CFBundlePackageType;
@dynamic CFBundleShortVersionString;
@dynamic CFBundleSignature;
@dynamic CFBundleURLTypes;
@dynamic CFBundleVersion;
@dynamic NSMainNibFile;
@dynamic NSUbiquitousDisplaySet;
@dynamic UTExportedTypeDeclarations;
@dynamic UTImportedTypeDeclarations;
@dynamic NSHumanReadableCopyright;
@dynamic LSRequiresIPhoneOS;
@dynamic MinimumOSVersion;
@dynamic UIAppFonts;
@dynamic UIApplicationExitsOnSuspend;
@dynamic UIBackgroundModes;
@dynamic UIDeviceFamily;
@dynamic UIFileSharingEnabled;
@dynamic UIInterfaceOrientation;
@dynamic UILaunchImageFile;
@dynamic UIMainStoryboardFile;
@dynamic UINewsstandApp;
@dynamic UIPrerenderedIcon;
@dynamic UIRequiredDeviceCapabilities;
@dynamic UIRequiresPersistentWiFi;
@dynamic UIStatusBarHidden;
@dynamic UIStatusBarStyle;
@dynamic UISupportedExternalAccessoryProtocols;
@dynamic UISupportedInterfaceOrientations;
@dynamic UIViewEdgeAntialiasing;
@dynamic UIViewGroupOpacity;

+ (instancetype)get {

    static PearlInfoPlist *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
}

- (id)objectForKeyPath:(NSString *)keyPath {

    id value = [[[NSBundle mainBundle] localizedInfoDictionary] valueForKeyPath:keyPath];
    if (!value)
        value = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:keyPath];

    return value;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    __autoreleasing id returnValue = [self objectForKeyPath:NSStringFromSelector( anInvocation.selector )];
    [anInvocation setReturnValue:&returnValue];
}

@end

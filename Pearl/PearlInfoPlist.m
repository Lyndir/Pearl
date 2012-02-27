//
//  PearlInfoPlist.m
//  MasterPassword
//
//  Created by Maarten Billemont on 05/02/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearlInfoPlist.h"

@implementation PearlInfoPlist

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

+ (PearlInfoPlist *)get {
    
    static PearlInfoPlist *instance = nil;
    if (!instance)
        instance = [self new];
    
    return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    NSString *value = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:selector];
    [anInvocation setReturnValue:&value];
}

@end

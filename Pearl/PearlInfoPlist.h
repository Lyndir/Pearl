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
//  PearlInfoPlist.h
//  MasterPassword
//
//  Created by Maarten Billemont on 05/02/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

__BEGIN_DECLS
NSComparisonResult PearlCFBundleVersionCompare(NSString *bundleVersion1, NSString *bundleVersion2);
__END_DECLS

@interface PearlInfoPlist : NSObject

/** A custom key that can be used to record the description of the GIT commit that the application was built from. */
@property (nonatomic, readonly) NSString     *GITDescription;
/** specifies whether the bundle supports the retrieval of localized strings from frameworks. This key is used primarily by Foundation tools that link to other system frameworks and want to retrieve localized resources from those frameworks. */
@property (nonatomic, readonly) NSNumber     *CFBundleAllowMixedLocalizations;
/** specifies the native region for the bundle. This key contains a string value that usually corresponds to the native language of the person who wrote the bundle. The language specified by this value is used as the default language if a resource cannot be located for the user’s preferred region or language. */
@property (nonatomic, readonly) NSString     *CFBundleDevelopmentRegion;
/** specifies the display name of the bundle. If you support localized names for your bundle, include this key in both your information property list file and in the InfoPlist.strings files of your language subdirectories. If you localize this key, you should also include a localized version of the CFBundleName key. */
@property (nonatomic, readonly) NSString     *CFBundleDisplayName;
/** contains an array of dictionaries that associate one or more document types with your application. Each dictionary is called a type-definition dictionary and contains keys used to define the document type. Table 2 lists the keys that are supported in these dictionaries. For additional information about specifying the types your application supports, see “Storing Document Types Information in the Application's Property List”. */
@property (nonatomic, readonly) NSArray      *CFBundleDocumentTypes;
/** identifies the name of the bundle’s main executable file. For an application, this is the application executable. For a loadable bundle, it is the binary that will be loaded dynamically by the bundle. For a framework, it is the shared library for the framework. Xcode automatically adds this key to the information property list file of appropriate projects. */
@property (nonatomic, readonly) NSString     *CFBundleExecutable;
/** identifies the file containing the icon for the bundle. The filename you specify does not need to include the extension, although it may. The system looks for the icon file in the main resources directory of the bundle. */
@property (nonatomic, readonly) NSArray      *CFBundleIconFile;
/** contains an array of strings identifying the icon files for the bundle. (It is recommended that you always create icon files using the PNG format.) When specifying your icon filenames, it is best to omit any filename extensions. Omitting the filename extension lets the system automatically detect high-resolution (@2x) versions of your image files using the standard-resolution image filename. If you include filename extensions, you must specify all image files (including the high-resolution variants) explicitly. The system looks for the icon files in the main resources directory of the bundle. If present, the values in this key take precedence over the value in the “CFBundleIconFile” key. */
@property (nonatomic, readonly) NSArray      *CFBundleIconFiles;
/** contains information about all of the icons used by the application. This key allows you to group icons based on their intended usage and specify multiple icon files together with specific keys for modifying the appearance of those icons. */
@property (nonatomic, readonly) NSDictionary *CFBundleIcons;
/** uniquely identifies the bundle. Each distinct application or bundle on the system must have a unique bundle ID. The system uses this string to identify your application in many ways. For example, the preferences system uses this string to identify the application for which a given preference applies; Launch Services uses the bundle identifier to locate an application capable of opening a particular file, using the first application it finds with the given identifier; in iOS, the bundle identifier is used in validating the application’s signature. */
@property (nonatomic, readonly) NSString     *CFBundleIdentifier;
/** identifies the current version of the property list structure. This key exists to support future versioning of the information property list file format. Xcode generates this key automatically when you build a bundle and you should not change it manually. */
@property (nonatomic, readonly) NSString     *CFBundleInfoDictionaryVersion;
/** identifies the localizations handled manually by your application. If your executable is unbundled or does not use the existing bundle localization mechanism, you can include this key to specify the localizations your application does handle. */
@property (nonatomic, readonly) NSArray      *CFBundleLocalizations;
/** identifies the short name of the bundle. This name should be less than 16 characters long and be suitable for displaying in the menu bar and the application’s Info window. You can include this key in the InfoPlist.strings file of an appropriate .lproj subdirectory to provide localized values for it. If you localize this key, you should also include the key “CFBundleDisplayName.” */
@property (nonatomic, readonly) NSString     *CFBundleName;
/** identifies the type of the bundle and is analogous to the Mac OS 9 file type code. The value for this key consists of a four-letter code. The type code for applications is APPL; for frameworks, it is FMWK; for loadable bundles, it is BNDL. For loadable bundles, you can also choose a type code that is more specific than BNDL if you want. */
@property (nonatomic, readonly) NSString     *CFBundlePackageType;
/** specifies the release version number of the bundle, which identifies a released iteration of the application. The release version number is a string comprised of three period-separated integers. The first integer represents major revisions to the application, such as revisions that implement new features or major changes. The second integer denotes revisions that implement less prominent features. The third integer represents maintenance releases. */
@property (nonatomic, readonly) NSString     *CFBundleShortVersionString;
/** identifies the creator of the bundle and is analogous to the Mac OS 9 file creator code. The value for this key is a string containing a four-letter code that is specific to the bundle. For example, the signature for the TextEdit application is ttxt. */
@property (nonatomic, readonly) NSString     *CFBundleSignature;
/** contains an array of dictionaries, each of which describes the URL schemes (http, ftp, and so on) supported by the application. The purpose of this key is similar to that of “CFBundleDocumentTypes,” but it describes URL schemes instead of document types. Each dictionary entry corresponds to a single URL scheme. Table 6 lists the keys to use in each dictionary entry. */
@property (nonatomic, readonly) NSArray      *CFBundleURLTypes;
/** specifies the build version number of the bundle, which identifies an iteration (released or unreleased) of the bundle. This is a monotonically increased string, comprised of one or more period-separated integers. This key is not localizable. */
@property (nonatomic, readonly) NSString     *CFBundleVersion;
/** This key contains a string with the name of the application’s main nib file (minus the .nib extension). A nib file is an Interface Builder archive containing the description of a user interface along with any connections between the objects of that interface. The main nib file is automatically loaded when an application is launched. */
@property (nonatomic, readonly) NSString     *NSMainNibFile;
/** contains the identifier string that you configured in iTunesConnect for managing your application’s storage. The assigned display set determines from which mobile data folder (in the user’s mobile account) the application retrieves its data files. */
@property (nonatomic, readonly) NSString     *NSUbiquitousDisplaySet;
/** declares the uniform type identifiers (UTIs) owned and exported by the application. You use this key to declare your application’s custom data formats and associate them with UTIs. Exporting a list of UTIs is the preferred way to register your custom file types; however, Launch Services recognizes this key and its contents only in Mac OS X v10.5 and later. This key is ignored on versions of Mac OS X prior to version 10.5. */
@property (nonatomic, readonly) NSArray      *UTExportedTypeDeclarations;
/**  declares the uniform type identifiers (UTIs) inherently supported (but not owned) by the application. You use this key to declare any supported types that your application recognizes and wants to ensure are recognized by Launch Services, regardless of whether the application that owns them is present. For example, you could use this key to specify a file format that is defined by another company but which your program can read and export.*/
@property (nonatomic, readonly) NSArray      *UTImportedTypeDeclarations;
/** This key contains a string with the copyright notice for the bundle; for example, © 2008, My Company. You can load this string and display it in an About dialog box. This key can be localized by including it in your InfoPlist.strings files. This key replaces the obsolete CFBundleGetInfoString key. */
@property (nonatomic, readonly) NSString     *NSHumanReadableCopyright;
/** specifies whether the application can run only on iOS. If this key is set to YES, Launch Services allows the application to launch only when the host platform is iOS. */
@property (nonatomic, readonly) NSNumber     *LSRequiresIPhoneOS;
/** When you build an iOS application, Xcode uses the iOS Deployment Target setting of the project to set the value for the MinimumOSVersion key. Do not specify this key yourself in the Info.plist file; it is a system-written key. When you publish your application to the App Store, the store indicates the iOS releases on which your application can run based on this key. It is equivalent to the LSMinimumSystemVersion key in Mac OS X. */
@property (nonatomic, readonly) NSNumber     *MinimumOSVersion;
/** specifies any application-provided fonts that should be made available through the normal mechanisms. Each item in the array is a string containing the name of a font file (including filename extension) that is located in the application’s bundle. The system loads the specified fonts and makes them available for use by the application when that application is run. */
@property (nonatomic, readonly) NSArray      *UIAppFonts;
/** specifies that the application should be terminated rather than moved to the background when it is quit. Applications linked against iOS SDK 4.0 or later can include this key and set its value to YES to prevent being automatically opted-in to background execution and application suspension. When the value of this key is YES, the application is terminated and purged from memory instead of moved to the background. If this key is not present, or is set to NO, the application moves to the background as usual. */
@property (nonatomic, readonly) NSNumber     *UIApplicationExitsOnSuspend;
/** specifies that the application provides specific background services and must be allowed to continue running while in the background. These keys should be used sparingly and only by applications providing the indicated services. Where alternatives for running in the background exist, those alternatives should be used instead. For example, applications can use the signifiant location change interface to receive location events instead of registering as a background location application. */
@property (nonatomic, readonly) NSArray      *UIBackgroundModes;
/** specifies the underlying hardware type on which this application is designed to run. */
@property (nonatomic, readonly) NSNumber     *UIDeviceFamily;
/** specifies whether the application shares files through iTunes. If this key is YES, the application shares files. If it is not present or is NO, the application does not share files. Applications must put any files they want to share with the user in their <Application_Home>/Documents directory, where <Application_Home> is the path to the application’s home directory. */
@property (nonatomic, readonly) NSNumber     *UIFileSharingEnabled;
/** specifies the initial orientation of the application’s user interface. */
@property (nonatomic, readonly) NSString     *UIInterfaceOrientation;
/** specifies the name of the launch image file for the application. If this key is not specified, the system assumes a name of Default.png. This key is typically used by universal applications when different sets of launch images are needed for iPad versus iPhone or iPod touch devices. */
@property (nonatomic, readonly) NSString     *UILaunchImageFile;
/** contains a string with the name of the application’s main storyboard file (minus the .storyboard extension). A storyboard file is an Interface Builder archive containing the application’s view controllers, the connections between those view controllers and their immediate views, and the segues between view controllers. When this key is present, the main storyboard file is loaded automatically at launch time and its initial view controller installed in the application’s window. */
@property (nonatomic, readonly) NSString     *UIMainStoryboardFile;
/** specifies the whether the application presents its content in Newsstand. Publishers of newspaper and magazine content use the Newsstand Kit framework to handle the downloading of new issues. However, instead of those applications showing up on the user’s Home screen, they are collected and presented through Newsstand. This key identifies the applications that should be presented that way. */
@property (nonatomic, readonly) NSNumber     *UINewsstandApp;
/** specifies whether the application’s icon already contains a shine effect. If the icon already has this effect, you should set this key to YES to prevent the system from adding the same effect again. All icons automatically receive a rounded bezel regardless of the value of this key. */
@property (nonatomic, readonly) NSNumber     *UIPrerenderedIcon;
/** lets iTunes and the App Store know which device-related features an application requires in order to run. iTunes and the mobile App Store use this list to prevent customers from installing applications on a device that does not support the listed capabilities. */
@property (nonatomic, readonly) NSDictionary *UIRequiredDeviceCapabilities;
/** specifies whether the application requires a Wi-Fi connection. iOS maintains the active Wi-Fi connection open while the application is running. */
@property (nonatomic, readonly) NSNumber     *UIRequiresPersistentWiFi;
/** specifies whether the status bar is initially hidden when the application launches. */
@property (nonatomic, readonly) NSNumber     *UIStatusBarHidden;
/** specifies the style of the status bar as the application launches. */
@property (nonatomic, readonly) NSString     *UIStatusBarStyle;
/** specifies the protocols that your application supports and can use to communicate with external accessory hardware. Each item in the array is a string listing the name of a supported communications protocol. Your application can include any number of protocols in this list and the protocols can be in any order. The system does not use this list to determine which protocol your application should choose; it uses it only to determine if your application is capable of communicating with the accessory. It is up to your code to choose an appropriate communications protocol when it begins talking to the accessory. */
@property (nonatomic, readonly) NSArray      *UISupportedExternalAccessoryProtocols;
/** specifies the interface orientations your application supports. The system uses this information (along with the current device orientation) to choose the initial orientation in which to launch your application. The value for this key is an array of strings. Table 5 lists the possible string values you can include in the array. */
@property (nonatomic, readonly) NSArray      *UISupportedInterfaceOrientations;
/** specifies whether Core Animation layers use antialiasing when drawing a layer that is not aligned to pixel boundaries. */
@property (nonatomic, readonly) NSNumber     *UIViewEdgeAntialiasing;
/** specifies whether Core Animation sublayers inherit the opacity of their superlayer. */
@property (nonatomic, readonly) NSNumber     *UIViewGroupOpacity;

+ (PearlInfoPlist *)get;

- (id)objectForKeyPath:(NSString *)keyPath;

@end

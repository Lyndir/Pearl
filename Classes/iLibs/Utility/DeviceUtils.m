//
//  DeviceUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "DeviceUtils.h"

BOOL IsIPod() {

#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[[UIDevice currentDevice] model] hasPrefix:@"iPod touch"];
#endif
}


BOOL IsIPhone() {

#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[[UIDevice currentDevice] model] hasPrefix:@"iPhone"];
#endif
}


BOOL IsSimulator() {
    
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

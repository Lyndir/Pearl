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
//  PearlDeviceUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlDeviceUtils.h"
#import "PearlConfig.h"

#include <sys/types.h>
#include <sys/sysctl.h>


@implementation PearlDeviceUtils

+ (NSString *)platform {

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString *)currentDeviceTokenAsHex {
    
    return [PearlDeviceUtils deviceTokenAsHex:[PearlConfig get].deviceToken];
}


+ (NSString *)deviceTokenAsHex:(NSData *)deviceToken {
    
    NSMutableString *deviceTokenHex = [NSMutableString stringWithCapacity:deviceToken.length * 2];
    
    for (NSUInteger b = 0; b < deviceToken.length; ++b)
        [deviceTokenHex appendFormat:@"%02hhX", ((const char*) deviceToken.bytes)[b]];
    
    return deviceTokenHex;
}


+ (BOOL)isIPod {

    return [[self platform] hasPrefix:@"iPod"];
}


+ (BOOL)isIPad {
    
    return [[self platform] hasPrefix:@"iPad"];
}


+ (BOOL)isIPhone {

    return [[self platform] hasPrefix:@"iPhone"];
}


+ (BOOL)isSimulator {
    
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (float)uiScale {

#if TARGET_OS_IPHONE
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            return 1024.0f / 480.0f;
        case UIUserInterfaceIdiomPhone:
            break;
    }
#endif
    
    return 1;
}

@end

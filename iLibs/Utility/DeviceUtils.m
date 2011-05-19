//
//  DeviceUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "DeviceUtils.h"
#import "Config.h"

#include <sys/types.h>
#include <sys/sysctl.h>


@implementation DeviceUtils

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
    
    return [DeviceUtils deviceTokenAsHex:[Config get].deviceToken];
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

@end

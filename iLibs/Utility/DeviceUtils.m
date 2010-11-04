//
//  DeviceUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "DeviceUtils.h"
#import "Config.h"


@implementation DeviceUtils


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

#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[[UIDevice currentDevice] model] hasPrefix:@"iPod touch"];
#endif
}


+ (BOOL)isIPhone {

#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[[UIDevice currentDevice] model] hasPrefix:@"iPhone"];
#endif
}


+ (BOOL)isSimulator {
    
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end

/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
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

@end

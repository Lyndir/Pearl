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
//  NSBundle_PearlMutableInfo.m
//  Pearl
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lyndir. All rights reserved.
//

#import "NSBundle_PearlMutableInfo.h"
#import "PearlLogger.h"
#import "JRSwizzle.h"

@implementation NSBundle (PearlMutableInfo)

static BOOL infoSwizzled = NO, localizedInfoSwizzled = NO;
+ (void)initialize {
    
//    if ([self instancesRespondToSelector:@selector(jr_swizzleMethod:withMethod:error:)]) {
        NSError *error = nil;
        if (!(infoSwizzled = [self jr_swizzleMethod:@selector(infoDictionary)
                                         withMethod:@selector(mutableInfoDictionary)
                                              error:&error]))
            dbg(@"Failed to swizzle -infoDictionary: %@", error);
        if (!(localizedInfoSwizzled = [self jr_swizzleMethod:@selector(localizedInfoDictionary)
                                                  withMethod:@selector(mutableLocalizedInfoDictionary)
                                                       error:&error]))
            dbg(@"Failed to swizzle -localizedInfoDictionary: %@", error);
//    }
}

- (NSMutableDictionary *)mutableInfoDictionary {
    
    static NSMutableDictionary *bundleInfos = nil;
    if (!bundleInfos)
        bundleInfos = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bundleInfo;
    NSValue *selfValue = [NSValue valueWithNonretainedObject:self];
    if (!(bundleInfo = NullToNil([bundleInfos objectForKey:selfValue]))) {
        NSDictionary *originalInfo = infoSwizzled? [self mutableInfoDictionary]: [self infoDictionary];
        [bundleInfos setObject:NilToNull(bundleInfo = [originalInfo mutableCopy]) forKey:selfValue];
    }
    
    return bundleInfo;
}

- (NSMutableDictionary *)mutableLocalizedInfoDictionary {
    
    static NSMutableDictionary *bundleInfos = nil;
    if (!bundleInfos)
        bundleInfos = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bundleInfo;
    NSValue *selfValue = [NSValue valueWithNonretainedObject:self];
    if (!(bundleInfo = NullToNil([bundleInfos objectForKey:selfValue]))) {
        NSDictionary *originalInfo = localizedInfoSwizzled? [self mutableLocalizedInfoDictionary]: [self localizedInfoDictionary];
        [bundleInfos setObject:NilToNull(bundleInfo = [originalInfo mutableCopy]) forKey:selfValue];
    }
    
    return bundleInfo;
}

@end

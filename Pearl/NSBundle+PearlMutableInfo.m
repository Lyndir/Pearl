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
//  NSBundle+PearlMutableInfo.m
//  Pearl
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lyndir. All rights reserved.
//

#import "JRSwizzle.h"

@implementation NSBundle(PearlMutableInfo)

static BOOL infoSwizzled = NO, localizedInfoSwizzled = NO;
static char mutableInfoDictionaryKey, mutableLocalizedInfoDictionaryKey;

+ (void)initialize {

    if ([self respondsToSelector:@selector(jr_swizzleMethod:withMethod:error:)]) {
        NSError *error = nil;
        if (!(infoSwizzled = [self jr_swizzleMethod:@selector(infoDictionary)
                                         withMethod:@selector(infoDictionary_PearlMutableInfo)
                                              error:&error]))
        wrn(@"Failed to swizzle -infoDictionary: %@", error);
        if (!(localizedInfoSwizzled = [self jr_swizzleMethod:@selector(localizedInfoDictionary)
                                                  withMethod:@selector(localizedInfoDictionary_PearlMutableInfo)
                                                       error:&error]))
        wrn(@"Failed to swizzle -localizedInfoDictionary: %@", error);
    }
    else
            wrn(@"Swizzling not supported.");
}

- (NSDictionary *)infoDictionary_PearlMutableInfo {

    return [PearlBlockObject facadeFor:(infoSwizzled? [self infoDictionary_PearlMutableInfo]: [self infoDictionary])
                            usingBlock:
                                    ^(SEL message, __autoreleasing id *result, id argument, NSInvocation *invocation) {
                                        NSDictionary *customInfoDictionary = [self mutableInfoDictionary];

                                        if (message == @selector(objectForKey:) || message == @selector(valueForKey:) || message == @selector(valueForKeyPath:)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                            // TODO: Try [invocation invokeWithTarget:customInfoDictionary];
                                            __autoreleasing id
                                                    customValue = [customInfoDictionary performSelector:message withObject:argument];
#pragma clang diagnostic pop
                                            if (NSNullToNil(customValue))
                                                *result = customValue;
                                        }
                                    }];
}

- (NSDictionary *)localizedInfoDictionary_PearlMutableInfo {

    return [PearlBlockObject facadeFor:(localizedInfoSwizzled? [self localizedInfoDictionary_PearlMutableInfo]: [self localizedInfoDictionary])
                            usingBlock:
                                    ^(SEL message, __autoreleasing id *result, id argument, NSInvocation *invocation) {
                                        NSDictionary *customLocalizedInfoDictionary = [self mutableLocalizedInfoDictionary];

                                        if (message == @selector(objectForKey:) || message == @selector(valueForKey:) || message == @selector(valueForKeyPath:)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                            // TODO: Try [invocation invokeWithTarget:customInfoDictionary];
                                            __autoreleasing id customValue = [customLocalizedInfoDictionary performSelector:message
                                                                                                                 withObject:argument];
#pragma clang diagnostic pop
                                            if (NSNullToNil(customValue))
                                                *result = customValue;
                                        }
                                    }];
}

- (NSMutableDictionary *)mutableInfoDictionary {

    if (!infoSwizzled) {
        err(@"The info dictionary hasn't been swizzled!");
        return nil;
    }

    NSMutableDictionary *mutableInfoDictionary = objc_getAssociatedObject( self, &mutableInfoDictionaryKey );
    if (!mutableInfoDictionary)
        objc_setAssociatedObject( self, &mutableInfoDictionaryKey,
                mutableInfoDictionary = [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN );

    return mutableInfoDictionary;
}

- (NSMutableDictionary *)mutableLocalizedInfoDictionary {

    if (!localizedInfoSwizzled) {
        err(@"The localized info dictionary hasn't been swizzled!");
        return nil;
    }

    NSMutableDictionary *mutableLocalizedInfoDictionary = objc_getAssociatedObject( self, &mutableLocalizedInfoDictionaryKey );
    if (!mutableLocalizedInfoDictionary)
        objc_setAssociatedObject( self, &mutableLocalizedInfoDictionaryKey,
                mutableLocalizedInfoDictionary = [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN );

    return mutableLocalizedInfoDictionary;
}

@end

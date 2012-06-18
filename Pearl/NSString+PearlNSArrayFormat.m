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
//  NSString+PearlNSArrayFormat.m
//  Pearl
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

@implementation NSString (PearlNSArrayFormat)

- (id)initWithFormat:(NSString *)format array:(NSArray *)arguments {

    __unsafe_unretained id *argList = (typeof(argList))calloc([arguments count], sizeof(id));
    @try {
        [arguments getObjects:argList];

#if TARGET_OS_IPHONE
        return [self initWithFormat:format arguments:(va_list)(void *)argList];
#else
        return [self initWithFormat:format arguments:(__va_list_tag *)(void *)argList];
#endif
    }
    @finally {
        free(argList);
    }
}

+ (NSString *)stringWithFormat:(NSString *)format array:(NSArray *)arguments {

    __unsafe_unretained id *argList = (typeof(argList))calloc([arguments count], sizeof(id));
    @try {
        [arguments getObjects:argList];

#if TARGET_OS_IPHONE
        return [[NSString alloc] initWithFormat:format arguments:(va_list)(void *)argList];
#else
        return [[NSString alloc] initWithFormat:format arguments:(__va_list_tag *)(void *)argList];
#endif
    }
    @finally {
        free(argList);
    }
}

@end

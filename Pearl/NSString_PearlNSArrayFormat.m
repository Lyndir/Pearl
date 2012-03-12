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
//  NSString_PearlNSArrayFormat.m
//  Pearl
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "NSString_PearlNSArrayFormat.h"

@implementation NSString (PearlNSArrayFormat)

- (id)initWithFormat:(NSString *)format array:(NSArray *)arguments {
    
    id *argList = (id *)malloc(sizeof(id) * [arguments count]);
    @try {
        [arguments getObjects:argList];

#ifdef MAC_OS_X_VERSION_MIN_REQUIRED
        return [self initWithFormat:format arguments:(__va_list_tag *)argList];
#else
        return [self initWithFormat:format arguments:(va_list)argList];
#endif
    }
    @finally {
        free(argList);
    }
}

+ (NSString *)stringWithFormat:(NSString *)format array:(NSArray *)arguments {

    id *argList = (id *)malloc(sizeof(id) * [arguments count]);
    @try {
        [arguments getObjects:argList];

#ifdef MAC_OS_X_VERSION_MIN_REQUIRED
        return [[[NSString alloc] initWithFormat:format arguments:(__va_list_tag *)argList] autorelease];
#else
        return [[[NSString alloc] initWithFormat:format arguments:(va_list)argList] autorelease];
#endif
    }
    @finally {
        free(argList);
    }
}

@end

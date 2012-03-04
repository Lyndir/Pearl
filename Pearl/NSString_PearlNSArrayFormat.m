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

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
typedef char __va_list_tag;
#endif

@implementation NSString (PearlNSArrayFormat)

+ (id)stringWithFormat:(NSString *)format array:(NSArray *) arguments {

    assert(sizeof(__va_list_tag) == sizeof(id));
    __va_list_tag *argList = (__va_list_tag *)malloc(sizeof(__va_list_tag) * [arguments count]);
    @try {
        [arguments getObjects:(id *)argList];

        return [[[NSString alloc] initWithFormat:format arguments:argList] autorelease];
    }
    @finally {
        free(argList);
    }
}

@end

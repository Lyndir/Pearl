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
//  ObjectUtils.h
//  RedButton
//
//  Created by Maarten Billemont on 08/11/10.
//  Copyright 2010 Lin.K. All rights reserved.
//

#import <Foundation/Foundation.h>

#define va_into(__array, __firstParameter)                                                  \
            va_list __list;                                                                 \
            va_start(__list, __firstParameter);                                             \
            for (id __object = __firstParameter; __object; __object = va_arg(__list, id))   \
                [__array addObject:__object];                                               \
            va_end(__list);

#define NilToNSNull(O)                                                                  \
            ({ __typeof__(O) __o = O; __o == nil? (id)[NSNull null]: __o; })

#define NSNullToNil(O)                                                                  \
            ({ __typeof__(O) __o = O; __o == (id)[NSNull null]? nil: __o; })

#define throw(__format, ...)                                                            \
            @throw [NSException                                                         \
                    exceptionWithName:NSInternalInconsistencyException                  \
                    reason:[NSString stringWithFormat:__format , ##__VA_ARGS__]         \
                    userInfo:nil]

@interface PearlObjectUtils : NSObject {

}

@end

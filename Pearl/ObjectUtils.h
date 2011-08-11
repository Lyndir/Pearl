//
//  ObjectUtils.h
//  RedButton
//
//  Created by Maarten Billemont on 08/11/10.
//  Copyright 2010 Lin.K. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ListInto(__array, __firstObject)                                                \
            va_list __list;                                                             \
            va_start(__list, __firstObject);                                            \
            for (id __object = __firstObject; __object; __object = va_arg(__list, id))  \
                [__array addObject:__object];                                           \
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

@interface ObjectUtils : NSObject {

}

@end

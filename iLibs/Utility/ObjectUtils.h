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
            va_start(__list, __firstObject);                                              \
            for (id __object = __firstObject; __object; __object = va_arg(__list, id))  \
                [__array addObject:__object];                                           \
            va_end(__list);


@interface ObjectUtils : NSObject {

}

@end

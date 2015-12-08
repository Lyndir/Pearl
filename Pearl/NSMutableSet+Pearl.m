//
// Created by Maarten Billemont on 2015-12-06.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

#import "NSMutableSet+Pearl.h"

@implementation NSMutableSet (Pearl)

- (BOOL)checkRemoveObject:(id)object {

    NSUInteger count = [self count];
    [self removeObject:object];
    return count != [self count];
}

@end

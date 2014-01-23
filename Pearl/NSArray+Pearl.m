//
// Created by Maarten Billemont on 1/23/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "NSArray+Pearl.h"


@implementation NSArray (Pearl)

- (id)firstObjectWhere:(BOOL (^)(id obj))predicate {

  __block id object = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ((*stop = predicate(obj)))
      object = obj;
  }];

  return object;
}

- (id)onlyObjectWhere:(BOOL (^)(id obj))predicate {

  __block id object = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if (predicate(obj)) {
      if (!object)
        object = obj;
      else
          Throw(@"Not the only object.\nFirst: %@\nSecond: %@", object, obj);
    }
  }];

  return object;
}

@end

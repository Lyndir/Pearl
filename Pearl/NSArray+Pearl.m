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
//  NSArray(Pearl)
//
//  Created by Maarten Billemont on 1/23/2014.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
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

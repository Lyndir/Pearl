//
// Created by Maarten Billemont on 1/23/2014.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Pearl)
- (id)firstObjectWhere:(BOOL (^)(id obj))predicate;
- (id)onlyObjectWhere:(BOOL (^)(id obj))predicate;
- (id)onlyObjectWhere:(BOOL (^)(id obj))predicate firstIfReleaseBuild:(BOOL)firstIfReleaseBuild;
@end

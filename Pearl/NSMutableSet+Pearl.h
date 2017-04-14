//
// Created by Maarten Billemont on 2015-12-06.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet<ObjectType> (Pearl)

/** @return YES if the object was successfully removed from the receiver.  NO if the object was not present and the receiver unchanged. */
- (BOOL)tryRemoveObject:(ObjectType)object;

@end

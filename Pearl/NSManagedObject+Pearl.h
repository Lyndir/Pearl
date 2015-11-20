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
//  NSManagedObject(Pearl).h
//  NSManagedObject(Pearl)
//
//  Created by lhunath on 2014-04-12.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(Pearl)

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context;
+ (instancetype)existingObjectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context;

@end

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

#import "NSManagedObject+Pearl.h"

@implementation NSManagedObject(Pearl)

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context {

    for (NSEntityDescription *entity in [[context.persistentStoreCoordinator.managedObjectModel entitiesByName] allValues])
        if ([entity.managedObjectClassName isEqualToString:NSStringFromClass( [self class] )])
            return [NSEntityDescription insertNewObjectForEntityForName:PearlNotNull(entity.name) inManagedObjectContext:context];

    return nil;
}

+ (instancetype)existingObjectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context {

    if (!objectID || !context)
        return nil;

    @try {
        NSError *error = nil;
        NSManagedObject *element = [context existingObjectWithID:objectID error:&error];
        if (!element)
            err( @"Failed to load %@: %@", self, [error fullDescription] );
        else if (element.isDeleted) {
            wrn( @"%@ was deleted: %@, returning nil instead.", self, element );
            return nil;
        }

        return element;
    }
    @catch (NSException *exception) {
        err( @"Exception while loading %@: %@", self, [exception fullDescription] );
        return nil;
    }
}

@end

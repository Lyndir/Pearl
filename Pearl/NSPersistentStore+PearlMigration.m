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
//  NSPersistentStore(PearlMigration).h
//  NSPersistentStore(PearlMigration)
//
//  Created by lhunath on 14-10-22.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "NSPersistentStore+PearlMigration.h"

@interface NSManagedObject(PearlMigration)

- (instancetype)copyMigrateToContext:(NSManagedObjectContext *)destinationContext
                 usingMigrationCache:(NSMutableDictionary *)migratedIDsBySourceID;

@end

@implementation NSPersistentStore(PearlMigration)

+ (BOOL)migrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions toStore:(NSURL *)targetStoreURL
         withOptions:(NSDictionary *)targetStoreOptions model:(NSManagedObjectModel *)model error:(__autoreleasing NSError **)error {

    if ([[NSFileManager defaultManager] fileExistsAtPath:PearlNotNull(targetStoreURL.path)])
        return [self copyMigrateStore:migratingStoreURL withOptions:migratingStoreOptions
                              toStore:targetStoreURL withOptions:targetStoreOptions
                                model:model error:error];

    return [self systemMigrateStore:migratingStoreURL withOptions:migratingStoreOptions
                            toStore:targetStoreURL withOptions:targetStoreOptions
                              model:model error:error];
}

+ (BOOL)systemMigrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions
                   toStore:(NSURL *)targetStoreURL withOptions:(NSDictionary *)targetStoreOptions
                     model:(NSManagedObjectModel *)model error:(__autoreleasing NSError **)error {

    if (!model)
        model = [NSManagedObjectModel mergedModelFromBundles:nil];

    NSPersistentStoreCoordinator *migratingCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *migratingStore = [migratingCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                                                                     URL:migratingStoreURL options:migratingStoreOptions
                                                                                   error:error];
    if (!migratingStore) {
        wrn( @"Migration failed, couldn't open migrating store: %@\n%@", migratingStoreURL, [*error fullDescription] );
        return NO;
    }

    if (![[NSFileManager defaultManager] createDirectoryAtURL:PearlNotNull([targetStoreURL URLByDeletingLastPathComponent])
                                  withIntermediateDirectories:YES attributes:nil error:error]) {
        wrn( @"Migration failed, couldn't create location for target store: %@\n%@",
                [targetStoreURL URLByDeletingLastPathComponent], [*error fullDescription] );
        return NO;
    }
    NSPersistentStore *targetStore = [migratingCoordinator migratePersistentStore:migratingStore
                                                                            toURL:targetStoreURL options:targetStoreOptions
                                                                         withType:NSSQLiteStoreType error:error];
    if (!targetStore) {
        wrn( @"Migration failed, couldn't migrate to target store: %@\n%@", targetStoreURL, [*error fullDescription] );
        [[NSFileManager defaultManager] removeItemAtURL:targetStoreURL error:nil];
        return NO;
    }
    if (![migratingCoordinator removePersistentStore:targetStore error:error])
        wrn( @"Couldn't remove migrated persistent store: %@\n%@", targetStore.URL, [*error fullDescription] );

    return YES;
}

+ (BOOL)copyMigrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions
                 toStore:(NSURL *)targetStoreURL withOptions:(NSDictionary *)targetStoreOptions
                   model:(NSManagedObjectModel *)model error:(__autoreleasing NSError **)error {

    if (!model)
        model = [NSManagedObjectModel mergedModelFromBundles:nil];

    // Open migrating store.
    NSPersistentStoreCoordinator *migratingCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *migratingStore = [migratingCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                                                                     URL:migratingStoreURL options:migratingStoreOptions
                                                                                   error:error];
    if (!migratingStore) {
        wrn( @"Migration failed, couldn't open migrating store: %@\n%@", migratingStoreURL, [*error fullDescription] );
        return NO;
    }

    // Open target store.
    if (![[NSFileManager defaultManager] createDirectoryAtURL:PearlNotNull([targetStoreURL URLByDeletingLastPathComponent])
                                  withIntermediateDirectories:YES attributes:nil error:error]) {
        wrn( @"Migration failed, couldn't create location for target store: %@\n%@",
                [targetStoreURL URLByDeletingLastPathComponent], [*error fullDescription] );
        return NO;
    }
    NSPersistentStoreCoordinator *targetCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *targetStore = [targetCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                                                               URL:targetStoreURL options:targetStoreOptions
                                                                             error:error];
    if (!targetStore) {
        wrn( @"Migration failed, couldn't open target store: %@\n%@", targetStoreURL, [*error fullDescription] );
        return NO;
    }

    // Set up contexts for them.
    NSManagedObjectContext *migratingContext = [NSManagedObjectContext new];
    NSManagedObjectContext *targetContext = [NSManagedObjectContext new];
    migratingContext.persistentStoreCoordinator = migratingCoordinator;
    targetContext.persistentStoreCoordinator = targetCoordinator;

    // Migrate metadata.
    NSMutableDictionary *metadata = [[migratingCoordinator metadataForPersistentStore:migratingStore] mutableCopy];
    for (NSString *key in [[metadata allKeys] copy])
        if ([key hasPrefix:@"com.apple.coredata.ubiquity"])
            // Don't migrate ubiquitous metadata.
            [metadata removeObjectForKey:key];
    [metadata addEntriesFromDictionary:[targetCoordinator metadataForPersistentStore:targetStore]];
    [targetCoordinator setMetadata:metadata forPersistentStore:targetStore];

    // Migrate entities.
    BOOL migratingFailure = NO;
    NSMutableDictionary *migratedIDsBySourceID = [[NSMutableDictionary alloc] initWithCapacity:500];
    for (NSEntityDescription *entity in model.entities) {
        NSFetchRequest *fetch = [NSFetchRequest new];
        fetch.entity = entity;
        fetch.fetchBatchSize = 500;
        fetch.relationshipKeyPathsForPrefetching = entity.relationshipsByName.allKeys;

        NSArray *localObjects = [migratingContext executeFetchRequest:fetch error:error];
        if (!localObjects) {
            wrn( @"Migration failed, fetch migrating objects:\n%@", [*error fullDescription] );
            migratingFailure = YES;
            break;
        }

        for (NSManagedObject *localObject in localObjects)
            [localObject copyMigrateToContext:targetContext usingMigrationCache:migratedIDsBySourceID];
    }

    // Save migrated entities and unload the stores.
    if (!migratingFailure && ![targetContext save:error])
        migratingFailure = YES;
    if (![migratingCoordinator removePersistentStore:migratingStore error:error])
        wrn( @"Couldn't remove migrating persistent store: %@\n%@", migratingStore.URL, [*error fullDescription] );
    if (![targetCoordinator removePersistentStore:targetStore error:error])
        wrn( @"Couldn't remove target persistent store: %@\n%@", targetStore.URL, [*error fullDescription] );
    return !migratingFailure;
}

@end

@implementation NSManagedObject(PearlMigration)

- (instancetype)copyMigrateToContext:(NSManagedObjectContext *)destinationContext
                 usingMigrationCache:(NSMutableDictionary *)migratedIDsBySourceID {

    NSManagedObjectID *destinationObjectID = migratedIDsBySourceID[self.objectID];
    if (destinationObjectID)
        return [destinationContext objectWithID:destinationObjectID];

    @autoreleasepool {
        // Create migrated object.
        NSEntityDescription *entity = self.entity;
        NSManagedObject *destinationObject = [NSEntityDescription insertNewObjectForEntityForName:PearlNotNull(entity.name)
                                                                           inManagedObjectContext:destinationContext];
        migratedIDsBySourceID[self.objectID] = destinationObject.objectID;

        // Set attributes
        for (NSString *key in entity.attributesByName.allKeys)
            [destinationObject setPrimitiveValue:[self primitiveValueForKey:key] forKey:key];

        // Set relationships recursively
        for (NSRelationshipDescription *relationDescription in entity.relationshipsByName.allValues) {
            NSString *key = relationDescription.name;
            id value = nil;

            if (relationDescription.isToMany) {
                value = [[destinationObject primitiveValueForKey:key] mutableCopy];

                for (NSManagedObject *element in [self primitiveValueForKey:key])
                    [value addObject:[element copyMigrateToContext:destinationContext usingMigrationCache:migratedIDsBySourceID]];
            }
            else
                value = [[self primitiveValueForKey:key] copyMigrateToContext:destinationContext usingMigrationCache:migratedIDsBySourceID];

            [destinationObject setPrimitiveValue:value forKey:key];
        }

        return destinationObject;
    }
}

@end

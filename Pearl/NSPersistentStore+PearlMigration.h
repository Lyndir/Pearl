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

#import <Foundation/Foundation.h>

@interface NSPersistentStore(PearlMigration)

/** Migrate using system migration if the target store doesn't exist yet, and copy migration if it does. */
+ (BOOL)migrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions
             toStore:(NSURL *)targetStoreURL withOptions:(NSDictionary *)targetStoreOptions error:(__autoreleasing NSError **)error;

/** Migrate using NSPersistentStoreCoordinator's -migratePersistentStore:toURL:options:withType:error: */
+ (BOOL)systemMigrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions
                   toStore:(NSURL *)targetStoreURL withOptions:(NSDictionary *)targetStoreOptions error:(__autoreleasing NSError **)error;

/** Migrate by manually copying all the entities from the migrating store to the target store. */
+ (BOOL)copyMigrateStore:(NSURL *)migratingStoreURL withOptions:(NSDictionary *)migratingStoreOptions
                 toStore:(NSURL *)targetStoreURL withOptions:(NSDictionary *)targetStoreOptions error:(__autoreleasing NSError **)error;
@end

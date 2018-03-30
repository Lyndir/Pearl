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
//  UICollectionView(PearlReloadFromArray).h
//  UICollectionView(PearlReloadFromArray)
//
//  Created by lhunath on 2014-08-21.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "UICollectionView+PearlReloadItems.h"

@implementation UICollectionView(PearlReloadItems)

- (void)updateDataSource:(NSMutableOrderedSetOrArrayType)dataSource toSections:(NSOrderedSetOrArrayType)newSections
             reloadItems:(NSSetOrArrayType)reloadItems completion:(void ( ^ )(BOOL finished))completion {

    if (!newSections || [dataSource isEqual:newSections]) {
        if ([reloadItems count])
            [self performBatchUpdates:^{
                if ([[reloadItems anyObject] isKindOfClass:[NSIndexPath class]])
                    [self reloadItemsAtIndexPaths:[reloadItems array]];
                else
                    for (NSUInteger section = 0; section < [dataSource count]; ++section) {
                        NSArray *sectionItems = dataSource[section];
                        for (NSUInteger index = 0; index < [sectionItems count]; ++index)
                            if (reloadItems == dataSource ||
                                [reloadItems containsObject:sectionItems[index]] ||
                                [reloadItems containsObject:sectionItems]) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                                trc( @"reload item %@", indexPath );
                                [self reloadItemsAtIndexPaths:@[ indexPath ]];
                            }
                    }
            }              completion:completion];
        else if (completion)
            completion( YES );
        return;
    }

    @try {
        [self performBatchUpdates:^{

            // Figure out how the section items have changed.
            NSMutableSet *oldItems = [NSMutableSet set];
            NSMutableArray *deletePaths = [NSMutableArray array];
            NSMutableDictionary *movedPaths = [NSMutableDictionary dictionary];
            for (NSUInteger section = 0; section < [dataSource count]; ++section) {
                NSArray *sectionItems = dataSource[section];
                for (NSUInteger index = 0; index < [sectionItems count]; ++index) {
                    id item = sectionItems[index];
                    [oldItems addObject:item];

                    NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:index inSection:section];
                    NSIndexPath *toIndexPath = [self indexPathForItem:item inSections:newSections];

                    if (!toIndexPath && section < [newSections count])
                        [deletePaths addObject:fromIndexPath];

                    else if (![fromIndexPath isEqual:toIndexPath])
                        movedPaths[fromIndexPath] = toIndexPath;

                    else if ([reloadItems containsObject:item]) {
                        trc( @"reload item %@", toIndexPath );
                        [self reloadItemsAtIndexPaths:@[ toIndexPath ]];
                    }
                }
            }

            // Figure out what sections were added and removed.
            NSMutableIndexSet *insertSet = [NSMutableIndexSet new], *deleteSet = [NSMutableIndexSet new];
            for (NSUInteger section = 0; section < MAX( [dataSource count], [newSections count] ); ++section) {
                if (section >= [dataSource count]) {
                    trc( @"insert section %d", (int)section );
                    [dataSource addObject:newSections[section]];
                    [insertSet addIndex:section];
                }
                else if (section >= [newSections count]) {
                    trc( @"delete section %d", (int)section );
                    [dataSource removeObjectAtIndex:[dataSource count] - 1];
                    [deleteSet addIndex:section];
                }
                else
                    [dataSource setObject:newSections[section] atIndexedSubscript:section];
            }

            // Prepare by ensuring all sections are present.
            [self insertSections:insertSet];

            // First remove deleted rows.
            for (NSIndexPath *path in deletePaths)
                trc( @"delete item %@", path );
            [self deleteItemsAtIndexPaths:deletePaths];

            // Then add inserted rows.
            for (NSUInteger section = 0; section < [newSections count]; ++section) {
                NSArray *newSectionItems = newSections[section];
                for (NSUInteger index = 0; index < [newSectionItems count]; ++index)
                    if (![oldItems tryRemoveObject:newSectionItems[index]]) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                        trc( @"insert item %@", indexPath );
                        [self insertItemsAtIndexPaths:@[ indexPath ]];
                    }
            }

            // Then shuffle around moved rows.
            [movedPaths enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath, BOOL *stop) {
                trc( @"move item %@ -> %@", fromIndexPath, toIndexPath );
                [self moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            }];

            // Clean up sections that were removed.
            [self deleteSections:deleteSet];
        }              completion:completion];
    }
    @catch (NSException *e) {
        wrn( @"Exception while reloading sections for table.  Falling back to a full reload.\n%@", [e fullDescription] );
        @try {
            [self reloadData];
        }
        @catch (NSException *e) {
            err( @"Exception during fallback reload.\n%@", [e fullDescription] );
        }
    }
}

- (NSIndexPath *)indexPathForItem:(id)item inSections:(id<NSOrderedSetOrArray>)sections {

    NSUInteger section = 0;
    for (id sectionItems in sections) {
        NSUInteger index = [sectionItems indexOfObject:item];

        if (index != NSNotFound)
            return [NSIndexPath indexPathForItem:index inSection:section];

        ++section;
    }

    return nil;
}

@end

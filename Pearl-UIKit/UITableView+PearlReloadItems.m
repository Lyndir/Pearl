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
//  UITableView(PearlReloadItems)
//
//  Created by Maarten Billemont on 2014-05-21.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import "UITableView+PearlReloadItems.h"

@implementation UITableView(PearlReloadItems)

- (void)updateDataSource:(NSMutableOrderedSetOrArrayType)dataSource toSections:(NSOrderedSetOrArrayType)newSections
             reloadItems:(NSSetOrArrayType)reloadItems withRowAnimation:(UITableViewRowAnimation)animation {

    @try {
        if (!newSections || [dataSource isEqual:newSections]) {
            if ([reloadItems count]) {
                [self beginUpdates];
                if ([[reloadItems anyObject] isKindOfClass:[NSIndexPath class]])
                    [self reloadRowsAtIndexPaths:[reloadItems array] withRowAnimation:animation];

                else {
                    NSMutableArray *reloadPaths = [NSMutableArray array];
                    for (NSUInteger section = 0; section < [dataSource count]; ++section) {
                        NSArray *sectionItems = (newSections?: dataSource)[section];
                        for (NSUInteger index = 0; index < [sectionItems count]; ++index)
                            if (reloadItems == dataSource ||
                                [reloadItems containsObject:sectionItems[index]] ||
                                [reloadItems containsObject:sectionItems]) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
                                trc( @"reload item: %lu - %lu", (unsigned long)indexPath.section, (unsigned long)indexPath.item );
                                [reloadPaths addObject:indexPath];
                            }
                        [dataSource replaceObjectAtIndex:section withObject:sectionItems];
                    }
                    [self reloadRowsAtIndexPaths:reloadPaths withRowAnimation:animation];
                }
                [self endUpdates];
            }
            else if (newSections)
                [dataSource replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange( 0, dataSource.count )]
                                        withObjects:newSections];

            return;
        }

        [self beginUpdates];

        // Figure out how the section items have changed.
        NSMutableSet *oldItems = [NSMutableSet set];
        NSMutableArray *deletePaths = [NSMutableArray array];
        NSMutableDictionary *movedPaths = [NSMutableDictionary dictionary];
        NSMutableArray *reloadPaths = [NSMutableArray array];
        for (NSUInteger section = 0; section < [dataSource count]; ++section) {
            NSArray *sectionItems = dataSource[section];
            for (NSUInteger index = 0; index < [sectionItems count]; ++index) {
                id item = sectionItems[index];
                [oldItems addObject:item];

                NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:index inSection:section];
                NSIndexPath *toIndexPath = [self findInDataSource:newSections item:item];

                if (!toIndexPath && section < [newSections count])
                    [deletePaths addObject:fromIndexPath];

                else {
                    if (![fromIndexPath isEqual:toIndexPath])
                        movedPaths[fromIndexPath] = toIndexPath;

                    if (toIndexPath && (reloadItems == dataSource || [reloadItems containsObject:item]))
                        [reloadPaths addObject:toIndexPath];
                }
            }
        }

        // Figure out what sections were added and removed.
        NSMutableIndexSet *insertSet = [NSMutableIndexSet new], *deleteSet = [NSMutableIndexSet new];
        for (NSUInteger section = 0; section < MAX( [dataSource count], [newSections count] ); ++section) {
            if (section >= [dataSource count]) {
                [dataSource addObject:newSections[section]];
                [insertSet addIndex:section];
            }
            else if (section >= [newSections count]) {
                [dataSource removeObjectAtIndex:[dataSource count] - 1];
                [deleteSet addIndex:section];
            }
            else
                [dataSource setObject:newSections[section] atIndexedSubscript:section];
        }

        // Add new sections.
        [insertSet enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            trc( @"insert section: %lu (%lu items)", (unsigned long)section, (unsigned long)[newSections[section] count] );
        }];
        [self insertSections:insertSet withRowAnimation:animation];

        // Remove deleted rows.
        [deletePaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            trc( @"delete item: %lu - %lu", (unsigned long)indexPath.section, (unsigned long)indexPath.item );
        }];
        [self deleteRowsAtIndexPaths:deletePaths withRowAnimation:animation];

        // Add inserted rows.
        for (NSUInteger section = 0; section < [newSections count]; ++section) {
            NSArray *newSectionItems = newSections[section];
            for (NSUInteger index = 0; index < [newSectionItems count]; ++index)
                if (![oldItems tryRemoveObject:newSectionItems[index]]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
                    trc( @"insert item: %lu - %lu", (unsigned long)indexPath.section, (unsigned long)indexPath.item );
                    [self insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
                }
        }

        // Shuffle around moved rows.
        [movedPaths enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath, BOOL *stop) {
            trc( @"move item: %lu - %lu -> %lu - %lu ",
                    (unsigned long)fromIndexPath.section, (unsigned long)fromIndexPath.item,
                    (unsigned long)toIndexPath.section, (unsigned long)toIndexPath.item );
            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }];

        // Delete removed sections.
        [deleteSet enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            trc( @"delete section: %lu", (unsigned long)section );
        }];
        [self deleteSections:deleteSet withRowAnimation:animation];

        [self endUpdates];

        // Reload items.
        [reloadPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            trc( @"reload item: %lu - %lu", (unsigned long)indexPath.section, (unsigned long)indexPath.item );
        }];
        [self reloadRowsAtIndexPaths:reloadPaths withRowAnimation:animation];
    }
    @catch (NSException *e) {
        wrn( @"Exception while reloading sections for table.  Falling back to a full reload.\n%@", [e fullDescription] );
        @try {
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:newSections.array];
            [self reloadData];
        }
        @catch (NSException *e) {
            err( @"Exception during fallback reload.\n%@", [e fullDescription] );
        }
    }
}

- (NSIndexPath *)findInDataSource:(NSOrderedSetOrArrayType)dataSource item:(id)item {

    if (!item)
        return nil;

    NSUInteger section = 0;
    for (id sectionItems in dataSource) {
        NSUInteger index = [sectionItems indexOfObject:item];

        if (index != NSNotFound)
            return [NSIndexPath indexPathForRow:index inSection:section];

        ++section;
    }

    return nil;
}

@end

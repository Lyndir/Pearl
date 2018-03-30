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

    if (!newSections || [dataSource isEqual:newSections]) {
        if ([reloadItems count]) {
            [self beginUpdates];
            if ([[reloadItems anyObject] isKindOfClass:[NSIndexPath class]])
                [self reloadRowsAtIndexPaths:[reloadItems array] withRowAnimation:animation];
            else
                for (NSUInteger section = 0; section < [dataSource count]; ++section) {
                    NSArray *sectionItems = dataSource[section];
                    for (NSUInteger index = 0; index < [sectionItems count]; ++index)
                        if (reloadItems == dataSource ||
                            [reloadItems containsObject:sectionItems[index]] ||
                            [reloadItems containsObject:sectionItems]) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
                            trc( @"reload item %@", indexPath );
                            [self reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
                        }
                }
            [self endUpdates];
        }
        return;
    }

    @try {
        [self beginUpdates];

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
                    [self reloadRowsAtIndexPaths:@[ toIndexPath ] withRowAnimation:animation];
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
        [self insertSections:insertSet withRowAnimation:animation];

        // First remove deleted rows.
        for (NSIndexPath *path in deletePaths)
            trc( @"delete item %@", path );
        [self deleteRowsAtIndexPaths:deletePaths withRowAnimation:animation];

        // Then add inserted rows.
        for (NSUInteger section = 0; section < [newSections count]; ++section) {
            NSArray *newSectionItems = newSections[section];
            for (NSUInteger index = 0; index < [newSectionItems count]; ++index)
                if (![oldItems tryRemoveObject:newSectionItems[index]]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
                    trc( @"insert item %@", indexPath );
                    [self insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
                }
        }

        // Then shuffle around moved rows.
        [movedPaths enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath, BOOL *stop) {
            trc( @"move item %@ -> %@", fromIndexPath, toIndexPath );
            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }];

        // Clean up sections that were removed.
        [self deleteSections:deleteSet withRowAnimation:animation];
        [self endUpdates];
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
            return [NSIndexPath indexPathForRow:index inSection:section];

        ++section;
    }

    return nil;
}

@end

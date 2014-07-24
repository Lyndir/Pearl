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
//  UITableView(PearlReloadFromArray)
//
//  Created by Maarten Billemont on 2014-05-21.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import "UITableView+PearlReloadFromArray.h"


@implementation UITableView(PearlReloadFromArray)

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section {

  [self reloadRowsFromArray:fromArray toArray:toArray inSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section
           withRowAnimation:(UITableViewRowAnimation)animation {

  NSMutableArray *workArray = [fromArray mutableCopy];

  [self beginUpdates];

  // First remove deleted rows.
  for (NSInteger index = (NSInteger)[workArray count] - 1; index >= 0; --index) {
    id row = workArray[(NSUInteger)index];
    if (![toArray containsObject:row]) {
      [self deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:section] ]
                  withRowAnimation:animation];
      [workArray removeObjectAtIndex:(NSUInteger)index];
    }
  }

  // Then add inserted rows.
  for (NSUInteger index = 0; index < [toArray count]; ++index) {
    id row = toArray[index];
    if (![workArray containsObject:row]) {
      [self insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(NSInteger)index inSection:section] ]
                  withRowAnimation:animation];
      [workArray insertObject:row atIndex:MIN( [workArray count], index )];
    }
  }

  // Then shuffle around moved rows.
  for (NSUInteger index = 0; index < [workArray count]; ++index) {
    id row = workArray[index];
    NSUInteger toIndex = [toArray indexOfObject:row];
    if (toIndex != index)
      [self moveRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)[fromArray indexOfObject:row] inSection:section]
                   toIndexPath:[NSIndexPath indexPathForRow:(NSInteger)toIndex inSection:section]];
  }

  [self endUpdates];
}

@end
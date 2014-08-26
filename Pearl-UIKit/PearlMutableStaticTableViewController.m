//
// Created by Maarten Billemont on 2014-08-21.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import "PearlMutableStaticTableViewController.h"
#import "PearlProfiler.h"


@implementation PearlMutableStaticTableViewController {
  NSMutableArray *_allCells;
  NSMutableArray *_activeCells;
}

#pragma mark - Life

- (void)viewDidLoad {

  [super viewDidLoad];

  NSUInteger sections = (NSUInteger)[super numberOfSectionsInTableView:self.tableView];
  _allCells = [NSMutableArray arrayWithCapacity:sections];
  _activeCells = [NSMutableArray arrayWithCapacity:sections];
  for (NSUInteger section = 0; section < sections; ++section) {
    NSUInteger rows = (NSUInteger)[super tableView:self.tableView numberOfRowsInSection:section];
    NSMutableArray *allSectionCells = [NSMutableArray arrayWithCapacity:rows];
    NSMutableArray *activeSectionCells = [NSMutableArray arrayWithCapacity:rows];
    [_allCells addObject:allSectionCells];
    [_activeCells addObject:activeSectionCells];

    for (NSUInteger row = 0; row < rows; ++row) {
      UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
      [allSectionCells addObject:cell];
      [activeSectionCells addObject:cell];
    }
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_activeCells[(NSUInteger)section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  return _activeCells[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [_activeCells count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

  switch (editingStyle) {
    case UITableViewCellEditingStyleNone:
      break;
    case UITableViewCellEditingStyleDelete:
      [_activeCells[(NSUInteger)indexPath.section] removeObjectAtIndex:(NSUInteger)indexPath.row];
      [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case UITableViewCellEditingStyleInsert:
      break;
  }
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {

  UITableViewCell *cell = _activeCells[(NSUInteger)sourceIndexPath.section][(NSUInteger)sourceIndexPath.row];
  [_activeCells[(NSUInteger)sourceIndexPath.section] removeObjectAtIndex:(NSUInteger)sourceIndexPath.row];
  [_activeCells[(NSUInteger)destinationIndexPath.section] insertObject:cell atIndex:(NSUInteger)sourceIndexPath.row];
  [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - State

- (NSArray *)allCells {

  return _allCells;
}

#pragma mark - Behavior

- (void)reloadCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells {

  [self updateCellsHiding:hideCells showing:showCells animation:UITableViewRowAnimationNone reloadData:YES];
}

- (void)updateCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells animation:(UITableViewRowAnimation)animation {

  [self updateCellsHiding:hideCells showing:showCells animation:animation reloadData:NO];
}

- (void)updateCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells animation:(UITableViewRowAnimation)animation
               reloadData:(BOOL)reloadData {

  for (NSUInteger section = 0; section < [_activeCells count]; ++section) {
    NSMutableArray *activeSectionCells = _activeCells[section];
    NSArray *oldSectionCells = [activeSectionCells copy];

    // Remove all the features in _activeSectionCells that need to be hidden.
    [activeSectionCells removeObjectsInArray:hideCells];

    // Figure out where in the _activeSectionCells to insert the feature based on the original order of cells in _allSectionCells.
    for (UITableViewCell *cell in showCells) {
      NSUInteger allFeaturesRow = [_allCells[section] indexOfObject:cell];
      if (allFeaturesRow == NSNotFound)
        continue;
      if ([activeSectionCells containsObject:cell])
        continue;

      NSUInteger cellInsertionRow = 0;
      NSUInteger previousAllCellRow = MAX( 0, allFeaturesRow - 1 );
      while (previousAllCellRow > 0) {
        NSUInteger previousActiveCellRow = [activeSectionCells indexOfObject:_allCells[section][previousAllCellRow]];
        if (previousActiveCellRow == NSNotFound)
          --previousAllCellRow;
        else {
          cellInsertionRow = previousActiveCellRow + 1;
          break;
        }
      }
      [activeSectionCells insertObject:cell atIndex:cellInsertionRow];
    }

    if (!reloadData)
      [self.tableView reloadRowsFromArray:oldSectionCells toArray:activeSectionCells inSection:section withRowAnimation:animation];
  }

  if (reloadData)
    [self.tableView reloadData];
}

#pragma mark - Private

- (NSIndexPath *)originalIndexPathForIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = _activeCells[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
  for (NSUInteger section = 0; section < [_allCells count]; ++section)
    for (NSUInteger row = 0; row < [_allCells[section] count]; ++row)
      if (_allCells[section][row] == cell)
        return [NSIndexPath indexPathForRow:row inSection:section];

  return nil;
}

@end

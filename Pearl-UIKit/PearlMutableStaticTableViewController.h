//
// Created by Maarten Billemont on 2014-08-21.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PearlMutableStaticTableViewController : UITableViewController

@property(nonatomic, readonly) NSArray *allCellsBySection;

- (void)reloadCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells;
- (void)updateCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells
                animation:(UITableViewRowAnimation)animation;
- (void)updateCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells
                animation:(UITableViewRowAnimation)animation reloadData:(BOOL)reloadData;

@end

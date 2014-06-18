//
// Created by Maarten Billemont on 2014-05-21.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableView(ReloadFromArray)

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section;
- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section
           withRowAnimation:(UITableViewRowAnimation)animation;

@end

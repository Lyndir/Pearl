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

#import <Foundation/Foundation.h>


@interface UITableView(PearlReloadFromArray)

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section;
- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section
           withRowAnimation:(UITableViewRowAnimation)animation;

@end

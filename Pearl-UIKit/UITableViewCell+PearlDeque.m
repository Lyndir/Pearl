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
//  UITableViewCell(PearlDequeue)
//
//  Created by Maarten Billemont on 2014-05-26.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import "UITableViewCell+PearlDeque.h"

@interface PearlTemplateTableViewDataSource : NSObject<UITableViewDataSource>

@property(nonatomic, copy) NSString *identifier;

+ (instancetype)templateSourceForIdentifier:(NSString *)identifier;

@end

@implementation UITableViewHeaderFooterView(PearlDeque)

+ (instancetype)dequeueFromTableView:(UITableView *)tableView {
    
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass( self )];
}

+ (instancetype)dequeueFromTableView:(UITableView *)tableView init:(void ( ^ )(__kindof UITableViewHeaderFooterView *view))initBlock {

    __kindof UITableViewHeaderFooterView *view = [self dequeueFromTableView:tableView];
    [UIView setAnimationsEnabled:NO];
    initBlock( view );
    [UIView setAnimationsEnabled:YES];

    return view;
}

@end

@implementation UITableViewCell(PearlDeque)

+ (instancetype)templateFromTableView:(UITableView *)tableView {

    id<UITableViewDelegate> originalDelegate = tableView.delegate;
    id<UITableViewDataSource> originalDataSource = tableView.dataSource;
    tableView.delegate = nil;
    tableView.dataSource = [PearlTemplateTableViewDataSource templateSourceForIdentifier:NSStringFromClass( self )];
    id template = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( self )
                                                  forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    tableView.delegate = originalDelegate;
    tableView.dataSource = originalDataSource;
    [tableView reloadData];

    return template;
}

+ (instancetype)dequeueFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {

    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( self ) forIndexPath:indexPath];
}

+ (instancetype)dequeueFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
                                init:(void(^)(__kindof UITableViewCell *cell))initBlock {

    __kindof UITableViewCell *cell = [self dequeueFromTableView:tableView indexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    initBlock( cell );
    [UIView setAnimationsEnabled:YES];

    return cell;
}

@end

@implementation PearlTemplateTableViewDataSource

+ (instancetype)templateSourceForIdentifier:(NSString *)identifier {

    PearlTemplateTableViewDataSource *dataSource = [self new];
    dataSource.identifier = identifier;

    return dataSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
}

@end

@implementation UITableView(PearlDeque)

- (void)registerCell:(Class)cell {

    assert( [cell isSubclassOfClass:[UITableViewCell class]] );
    [self registerClass:cell forCellReuseIdentifier:NSStringFromClass( cell )];
}

- (void)registerNibCell:(Class)cell {

    assert( [cell isSubclassOfClass:[UITableViewCell class]] );
    [self registerCell:cell usingNib:[UINib nibWithNibName:NSStringFromClass( cell ) bundle:[NSBundle mainBundle]]];
}

- (void)registerCell:(Class)cell usingNib:(UINib *)nib {

    assert( [cell isSubclassOfClass:[UITableViewCell class]] );
    [self registerNib:nib forCellReuseIdentifier:NSStringFromClass( cell )];
}

- (void)registerHeaderFooter:(Class)headerFooterView {

    assert( [headerFooterView isSubclassOfClass:[UITableViewHeaderFooterView class]] );
    [self registerClass:headerFooterView forHeaderFooterViewReuseIdentifier:NSStringFromClass( headerFooterView )];
}

- (void)registerHeaderFooter:(Class)headerFooterView usingNib:(UINib *)nib {

    assert( [headerFooterView isSubclassOfClass:[UITableViewHeaderFooterView class]] );
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass( headerFooterView )];
}

@end

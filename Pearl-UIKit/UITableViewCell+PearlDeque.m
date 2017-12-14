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

+ (instancetype)dequeueHeaderFooterFromTableView:(UITableView *)tableView {
    
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass( self )];
}

+ (instancetype)dequeueHeaderFooterFromTableView:(UITableView *)tableView init:(void ( ^ )(UITableViewHeaderFooterView *view))initBlock {

    __kindof UITableViewHeaderFooterView *view = [self dequeueHeaderFooterFromTableView:tableView];
    [UIView setAnimationsEnabled:NO];
    initBlock( view );
    [UIView setAnimationsEnabled:YES];

    return view;
}

+ (void)registerHeaderFooterWithTableView:(UITableView *)tableView {
    
    [tableView registerClass:self forHeaderFooterViewReuseIdentifier:NSStringFromClass( self )];
}

+ (void)registerHeaderFooterWithTableView:(UITableView *)tableView usingNib:(UINib *)nib {
    
    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass( self )];
}

@end

@implementation UITableViewCell(PearlDeque)

+ (instancetype)templateCellFromTableView:(UITableView *)tableView {

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

+ (instancetype)dequeueCellFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {

    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( self ) forIndexPath:indexPath];
}

+ (instancetype)dequeueCellFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
                                    init:(void(^)(__kindof UITableViewCell *cell))initBlock {

    __kindof UITableViewCell *cell = [self dequeueCellFromTableView:tableView indexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    initBlock( cell );
    [UIView setAnimationsEnabled:YES];

    return cell;
}

+ (void)registerCellWithTableView:(UITableView *)tableView {

    [tableView registerClass:self forCellReuseIdentifier:NSStringFromClass( self )];
}

+ (void)registerNibCellWithTableView:(UITableView *)tableView {

    [self registerCellWithTableView:tableView usingNib:[UINib nibWithNibName:NSStringFromClass( self ) bundle:[NSBundle mainBundle]]];
}

+ (void)registerCellWithTableView:(UITableView *)tableView usingNib:(UINib *)nib {

    [tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass( self )];
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

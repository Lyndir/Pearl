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
//  UICollectionReusableView(PearlDequeue)
//
//  Created by Maarten Billemont on 2014-05-26.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import "UICollectionReusableView+PearlDequeue.h"

@interface PearlTemplateCollectionViewDataSource : NSObject<UICollectionViewDataSource>

@property(nonatomic, copy) NSString *identifier;

+ (instancetype)templateSourceForIdentifier:(NSString *)identifier;

@end

@implementation UICollectionReusableView(PearlDequeue)

+ (instancetype)templateSupplementaryFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {

    id<UICollectionViewDataSource> originalDataSource = collectionView.dataSource;
    collectionView.dataSource = [PearlTemplateCollectionViewDataSource templateSourceForIdentifier:NSStringFromClass( self )];
    id template = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )
                                                            forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    collectionView.dataSource = originalDataSource;
    [collectionView reloadData];

    return template;
}

+ (instancetype)dequeueSupplementaryFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                             indexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )
                                                     forIndexPath:indexPath];
}

+ (instancetype)dequeueSupplementaryFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                             indexPath:(NSIndexPath *)indexPath
                                                  init:(void ( ^ )(UICollectionReusableView *cell))initBlock {

    __kindof UICollectionReusableView *view = [self dequeueSupplementaryFromCollectionView:collectionView kind:kind indexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    initBlock( view );
    [UIView setAnimationsEnabled:YES];

    return view;
}

+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {

    [collectionView registerClass:self forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )];
}

+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib {

    [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )];
}

+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {

    [collectionView.collectionViewLayout registerClass:self forDecorationViewOfKind:kind];
}

+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib {

    [collectionView.collectionViewLayout registerNib:nib forDecorationViewOfKind:kind];
}

@end

@implementation UICollectionViewCell(PearlDequeue)

+ (instancetype)templateCellFromCollectionView:(UICollectionView *)collectionView {

    UICollectionViewLayout *originalLayout = collectionView.collectionViewLayout;
    id<UICollectionViewDelegate> originalDelegate = collectionView.delegate;
    id<UICollectionViewDataSource> originalDataSource = collectionView.dataSource;
    collectionView.collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionView.delegate = nil;
    collectionView.dataSource = [PearlTemplateCollectionViewDataSource templateSourceForIdentifier:NSStringFromClass( self )];
    id template = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass( self )
                                                            forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    collectionView.collectionViewLayout = originalLayout;
    collectionView.delegate = originalDelegate;
    collectionView.dataSource = originalDataSource;
    [collectionView reloadData];

    return template;
}

+ (instancetype)dequeueCellFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass( self ) forIndexPath:indexPath];
}

+ (instancetype)dequeueCellFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
                                         init:(void ( ^ )(UICollectionViewCell *cell))initBlock {

    __kindof UICollectionViewCell *view = [self dequeueCellFromCollectionView:collectionView indexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    initBlock( view );
    [UIView setAnimationsEnabled:YES];

    return view;
}

+ (void)registerCellWithCollectionView:(UICollectionView *)collectionView {

    [collectionView registerClass:self forCellWithReuseIdentifier:NSStringFromClass( self )];
}

+ (void)registerCellWithCollectionView:(UICollectionView *)collectionView usingNib:(UINib *)nib {

    [collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass( self )];
}

@end

@implementation PearlTemplateCollectionViewDataSource

+ (instancetype)templateSourceForIdentifier:(NSString *)identifier {

    PearlTemplateCollectionViewDataSource *dataSource = [self new];
    dataSource.identifier = identifier;

    return dataSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.identifier forIndexPath:indexPath];
}

@end

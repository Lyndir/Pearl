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

+ (instancetype)templateFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {

    id<UICollectionViewDataSource> originalDataSource = collectionView.dataSource;
    collectionView.dataSource = [PearlTemplateCollectionViewDataSource templateSourceForIdentifier:NSStringFromClass( self )];
    id template = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )
                                                            forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    collectionView.dataSource = originalDataSource;
    [collectionView reloadData];

    return template;
}

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                indexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( self )
                                                     forIndexPath:indexPath];
}

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                indexPath:(NSIndexPath *)indexPath
                                     init:(void ( ^ )(__kindof UICollectionReusableView *cell))initBlock {

    __block __kindof UICollectionReusableView *view;
    [UIView performWithoutAnimation:^{
        view = [self dequeueFromCollectionView:collectionView kind:kind indexPath:indexPath];
        initBlock( view );
    }];

    return view;
}

+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {


}

+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib {


}

+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {


}

+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib {


}

@end

@implementation UICollectionViewCell(PearlDequeue)

+ (instancetype)templateFromCollectionView:(UICollectionView *)collectionView {

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

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {

    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass( self ) forIndexPath:indexPath];
}

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
                                     init:(void ( ^ )(__kindof UICollectionViewCell *cell))initBlock {

    __block __kindof UICollectionViewCell *view;
    [UIView performWithoutAnimation:^{
        view = [self dequeueFromCollectionView:collectionView indexPath:indexPath];
        initBlock( view );
    }];

    return view;
}

@end

@implementation UICollectionView(PearlDequeue)

- (void)registerSupplementaryView:(Class)supplementaryView kind:(NSString *)kind {

    assert( [supplementaryView isSubclassOfClass:[UICollectionReusableView class]] );
    [self registerClass:supplementaryView forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( supplementaryView )];
}

- (void)registerSupplementaryView:(Class)supplementaryView kind:(NSString *)kind usingNib:(UINib *)nib {

    assert( [supplementaryView isSubclassOfClass:[UICollectionReusableView class]] );
    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass( supplementaryView )];
}


- (void)registerDecorationView:(Class)decorationView kind:(NSString *)kind {

    assert( [decorationView isSubclassOfClass:[UICollectionReusableView class]] );
    [self.collectionViewLayout registerClass:decorationView forDecorationViewOfKind:kind];
}

- (void)registerDecorationView:(Class)decorationView kind:(NSString *)kind usingNib:(UINib *)nib {

    assert( [decorationView isSubclassOfClass:[UICollectionReusableView class]] );
    [self.collectionViewLayout registerNib:nib forDecorationViewOfKind:kind];
}

- (void)registerCell:(Class)cell {

    assert( [cell isSubclassOfClass:[UICollectionViewCell class]] );
    [self registerClass:cell forCellWithReuseIdentifier:NSStringFromClass( cell )];
}

- (void)registerCell:(Class)cell usingNib:(UINib *)nib {

    assert( [cell isSubclassOfClass:[UICollectionViewCell class]] );
    [self registerNib:nib forCellWithReuseIdentifier:NSStringFromClass( cell )];
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

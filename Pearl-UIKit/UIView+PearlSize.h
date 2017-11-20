//
// Created by Maarten Billemont on 2017-11-17.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(PearlSize)

/** A minimum bound for the view's intrinsic size and fitting size. */
@property(nonatomic) IBInspectable CGSize minimumIntrinsicSize;

/** Fixed edge padding grows its fitting size and offsets its content. */
@property(nonatomic) IBInspectable UIEdgeInsets paddingInsets;

@end

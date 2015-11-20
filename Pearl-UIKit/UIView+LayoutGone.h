//
// Created by Maarten Billemont on 2014-07-15.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView(LayoutGone)

/** This view automatically becomes gone if all its goneParents become gone. */
@property(nonatomic) IBOutletCollection( UIView ) NSArray *goneParents;

/** Whether this view wants to be gone.
 *  Set to true to make it gone, false to make it gone only if it has visibility parents and they're all gone. */
@property(nonatomic) BOOL gone;

@end

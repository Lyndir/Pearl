//
// Created by Maarten Billemont on 14-12-29.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSView(Traversing)

/** Return the view or the first parent of it that is of the receiver's type. */
+ (instancetype)findAsSuperviewOf:(NSView *)view;
- (BOOL)isOrHasSuperviewOfKind:(Class)kind;
- (BOOL)enumerateViews:(void ( ^ )(NSView *subview, BOOL *stop, BOOL *recurse))block recurse:(BOOL)recurseDefault;
- (void)printSuperHierarchy;
- (void)printChildHierarchy;

@end

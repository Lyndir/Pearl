//
// Created by Maarten Billemont on 14-12-29.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import "NSView+Traversing.h"

@implementation NSView(Traversing)

+ (instancetype)findAsSuperviewOf:(NSView *)view {

    for (NSView *candidate = view; candidate; candidate = [candidate superview])
        if ([candidate isKindOfClass:self])
            return candidate;

    return nil;
}

- (BOOL)isOrHasSuperviewOfKind:(Class)kind {

    for (NSView *view = self; view; view = [view superview])
        if ([view isKindOfClass:kind])
            return YES;

    return NO;
}

- (BOOL)enumerateViews:(void ( ^ )(NSView *subview, BOOL *stop, BOOL *recurse))block recurse:(BOOL)recurseDefault {

    BOOL stop = NO, recurse = recurseDefault;
    block( self, &stop, &recurse );
    if (stop)
        return NO;

    if (recurse)
        for (NSView *subview in self.subviews)
            if (![subview enumerateViews:block recurse:recurseDefault])
                return NO;

    return YES;
}

- (void)printSuperHierarchy {

    NSUInteger indent = 0;
    for (NSView *view = self; view; view = view.superview) {
        dbg( strf( @"%%%lds %%@", (long)indent ), "", [view infoDescription] );
        indent += 4;
    }
}

- (void)printChildHierarchy {

    [self printChildHierarchyWithIndent:0];
}

- (void)printChildHierarchyWithIndent:(NSUInteger)indent {

    dbg( strf( @"%%%lds %%@", (long)indent ), "", [self infoDescription] );

    for (NSView *child in self.subviews)
        [child printChildHierarchyWithIndent:indent + 4];
}

- (NSString *)infoDescription {

    // Find the view controller
    NSResponder *nextResponder = [self nextResponder];
    while ([nextResponder isKindOfClass:[NSView class]])
        nextResponder = [nextResponder nextResponder];
    NSViewController *viewController = nil;
    if ([nextResponder isKindOfClass:[NSViewController class]]) if ((viewController = (NSViewController *)nextResponder).view != self)
        viewController = nil;

    return strf( strf( @"%@ t:%%d, h:%%@, f:%%@, %%@", viewController? @"+ %@(%@)": @"- %@%@" ),
            NSStringFromClass( [viewController class] )?: @"", [self class], self.tag, @(self.hidden),
            NSStringFromRect( self.frame ), [self debugDescription] );
}

@end

//
// Created by Maarten Billemont on 2014-07-15.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+LayoutGone.h"

@implementation UIView(LayoutGone)

static char GoneParentsKey;
static char GoneChildrenKey;
static char GoneKey;
static char GoneConstraints;
static char GoneSuperview;
//static char GoneAlpha;
//static char GoneTemporaryConstraints;

- (NSArray *)goneParents {

    return objc_getAssociatedObject( self, &GoneParentsKey );
}

- (void)setGoneParents:(NSArray *)goneParents {

    // Remove ourselves as children from former parents.
    for (UIView *goneParent in self.goneParents)
        if (![goneParents containsObject:goneParent])
            [goneParent.goneChildren removeObject:self];

    // Add ourselves as children to new parents.
    for (UIView *goneParent in goneParents)
        [goneParent.goneChildren addObject:self];

    objc_setAssociatedObject( self, &GoneParentsKey, goneParents, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSMutableSet *)goneChildren {

    // Get our children or make a new set if we don't have any yet.
    NSMutableSet *children = objc_getAssociatedObject( self, &GoneChildrenKey );
    if (!children)
        objc_setAssociatedObject( self, &GoneChildrenKey, children = [NSMutableSet set], OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    return children;
}

- (BOOL)gone {

    return [objc_getAssociatedObject( self, &GoneKey ) boolValue];
}

- (void)setGone:(BOOL)gone {

    if (gone == self.gone)
        return;

    objc_setAssociatedObject( self, &GoneKey, @(gone), OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    [self updateGone];
}

- (BOOL)effectiveGone {

    // We are gone.
    if (self.gone)
        return YES;

    if ([self.goneParents count]) {
        for (UIView *goneParent in self.goneParents)
            if (!goneParent.effectiveGone)
                return NO;

        // All our parents are gone.
        return YES;
    }

    return NO;
}

- (void)updateGone {

    BOOL gone = self.effectiveGone;
    BOOL wasGone = objc_getAssociatedObject( self, &GoneConstraints ) != nil;

    // If we just became visible, we need to add all our dependant children to the hierarchy before we start reinstalling constraints.
    if (!gone)
        [self addIfVisible];

    if (gone && !wasGone) {
        NSArray *constraints = [self applicableConstraints];
//        [self.window?: self.superview?: self layoutIfNeeded];

        // Save and remove our constraints.
        objc_setAssociatedObject( self, &GoneConstraints, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//        [constraints makeObjectsPerformSelector:@selector( removeFromHolder )];

        // Lock our position with temporary constraints and fade out.
//        objc_setAssociatedObject( self, &GoneAlpha, @(self.alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//        NSArray *temporaryConstraints = [self.superview addConstraintsWithVisualFormats:@[ @"H:|-(x)-[view(w)]", @"V:|-(y)-[view(h)]" ]
//                                                                                options:0 metrics:@{
//                @"x" : @(self.frame.origin.x), @"y" : @(self.frame.origin.y),
//                @"w" : @(self.frame.size.width), @"h" : @(self.frame.size.height)
//            }                                                                     views:@{ @"view" : self }];
//        objc_setAssociatedObject( self, &GoneTemporaryConstraints, temporaryConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC );

        // Inherit any existing animation, fade out in it and only after its completion remove ourselves from the hierarchy.
//        [UIView animateWithDuration:0 animations:^{
//            self.alpha = 0;
//        } completion:^(BOOL finished) {
//            if (finished && self.gone) {
                objc_setAssociatedObject( self, &GoneSuperview, self.superview, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
                [self removeFromSuperview];
//            }
//        }];
    }

    if (!gone && wasGone) {
        // Remove our temporary constraints.
//        NSArray *temporaryConstraints = objc_getAssociatedObject( self, &GoneTemporaryConstraints );
//        [temporaryConstraints makeObjectsPerformSelector:@selector( removeFromHolder )];
//        objc_setAssociatedObject( self, &GoneTemporaryConstraints, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );

        // Restore our saved constraints and fade back in.
        NSArray *goneConstraints = objc_getAssociatedObject( self, &GoneConstraints );
        for (NSLayoutConstraint *constraint in goneConstraints) {
            // Find constraint holder for constraint: first common container for both items.
            for (UIView *constraintHolder = constraint.firstItem; constraintHolder; constraintHolder = [constraintHolder superview])
                if (!constraint.secondItem || [constraint.secondItem isDescendantOfView:constraintHolder]) {
                    [constraintHolder addConstraint:constraint];
                    break;
                }
        }
        objc_setAssociatedObject( self, &GoneConstraints, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//        self.alpha = [objc_getAssociatedObject( self, &GoneAlpha ) floatValue];
//        objc_setAssociatedObject( self, &GoneAlpha, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }

    // Update the children who depend on us.
    for (UIView *goneChild in self.goneChildren)
        [goneChild updateGone];
}

- (void)addIfVisible {

    if (!self.superview && !self.effectiveGone) {
        // Add ourselves back to the hierarchy.
        [objc_getAssociatedObject( self, &GoneSuperview ) addSubview:self];
        objc_setAssociatedObject( self, &GoneSuperview, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }

    // Update the children who depend on us.
    for (UIView *goneChild in self.goneChildren)
        [goneChild addIfVisible];
}

@end

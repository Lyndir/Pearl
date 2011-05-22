//
//  RootViewController.m
//  Gorillas
//
//  Created by Maarten Billemont on 12/11/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "RootViewController.h"
#import "AbstractAppDelegate.h"


@implementation RootViewController
@synthesize supportedIterfaceOrientations = _supportedIterfaceOrientations;

- (id)init {
    
    if (!(self = [super init]))
        return self;
    
    self.supportedIterfaceOrientations = [NSMutableArray array];
    
    return self;
}

- (id)initWithView:(UIView *)aView {
    
    if (!(self = [super init]))
        return self;

    self.view = aView;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return self;
    
    self.supportedIterfaceOrientations = [NSMutableArray array];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return self;
    
    self.supportedIterfaceOrientations = [NSMutableArray array];
    
    return self;
}

- (BOOL)isInterfaceOrientationSupported:(UIInterfaceOrientation)interfaceOrientation {
    
    for (NSNumber *supportedInterfaceOrientation in self.supportedIterfaceOrientations)
        if ([supportedInterfaceOrientation unsignedIntValue] == interfaceOrientation)
            return YES;
    
    return NO;
}

- (void)supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (![self isInterfaceOrientationSupported:interfaceOrientation])
        [self.supportedIterfaceOrientations addObject:[NSNumber numberWithUnsignedInt:interfaceOrientation]];
}

- (void)rejectInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    for (NSNumber *supportedInterfaceOrientation in self.supportedIterfaceOrientations)
        if ([supportedInterfaceOrientation unsignedIntValue] == interfaceOrientation) {
            [self.supportedIterfaceOrientations removeObject:supportedInterfaceOrientation];
            return;
        }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return [self isInterfaceOrientationSupported:interfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [[AbstractAppDelegate get] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end

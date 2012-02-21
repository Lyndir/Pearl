/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  ConfirmationViewController.m
//  Pearl
//
//  Created by Maarten Billemont on 22/12/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "PearlAppDelegate.h"
#import "ConfirmationViewController.h"
#import "Layout.h"


@interface ConfirmationViewController ()

- (void)popAll:(BOOL)agreed;

@end


@implementation ConfirmationViewController


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title logo:(UIImage *)l button:(UIBarButtonItem *)b back:(BOOL)back message:(NSString *)msg {
    
    if (!(self = [super init]))
        return self;
    
    [self setTitle:title];
    
    allowBack   = back;
    logo        = [l retain];
    button      = [b retain];
    message     = [msg retain];
    
    if (!button)
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:nil action:nil];
    
    if (![button target] || ![button action])
        [self setButtonCallback:self :@selector(popAll:)];
    
    return self;
}


- (void)loadView {
    
    Layout *layout = [[Layout alloc] init];
    [layout addLogo:logo];
    
    
    // Confirmation Text.
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    messageLabel.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    messageLabel.font               = [messageLabel.font fontWithSize:24.0f];
    messageLabel.shadowOffset       = CGSizeMake(1, 1);
    messageLabel.backgroundColor    = [UIColor clearColor];
    messageLabel.lineBreakMode      = UILineBreakModeWordWrap;
    messageLabel.textAlignment      = UITextAlignmentCenter;
    messageLabel.numberOfLines      = 0;
    messageLabel.text               = message;
    
    [layout add:messageLabel];
    [messageLabel release];
    messageLabel = nil;

    [[self navigationItem] setHidesBackButton:!allowBack];
    [[self navigationItem] setRightBarButtonItem:button];
    
    // Add hierarcy to the controller.
    [self setView:[layout scrollView]];
    [layout release];
}


- (void)dealloc {
    
    [button release];
    button = nil;
    
    [message release];
    message = nil;
    
    [super dealloc];
}


#pragma mark ###############################
#pragma mark Behaviors

-(void)setButtonCallback:(id)target :(SEL)selector {
 
    [button setTarget:target];
    [button setAction:selector];
}

- (void)popAll:(BOOL)agreed {
    
    [[PearlAppDelegate get] restart];
}


@end

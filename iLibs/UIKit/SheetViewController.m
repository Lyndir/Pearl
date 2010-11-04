//
//  SheetViewController.m
//  iLibs
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "AbstractAppDelegate.h"
#import "SheetViewController.h"
#import "Layout.h"
#import "StringUtils.h"


@interface SheetViewController ()

- (void)popAll:(NSNumber *)buttonIndex;

@end


@implementation SheetViewController


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)aTitle {
    
    return self = [self initWithTitle:aTitle backString:nil acceptString:nil callback:nil :nil];
}


- (id)initWithTitle:(NSString *)aTitle backString:(NSString *)backString {
    
    return self = [self initWithTitle:aTitle backString:backString acceptString:nil callback:nil :nil];
}


- (id)initWithTitle:(NSString *)aTitle
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector {
    
    if (!(self = [super init]))
        return self;
    
    [self setTitle:aTitle];
    
    if (acceptString || target)
        [self setTarget:target selector:selector];
    
    sheetView = [[UIActionSheet alloc] initWithTitle:aTitle delegate:self
                                   cancelButtonTitle:backString destructiveButtonTitle:nil
                                   otherButtonTitles:acceptString, nil];
    
    // We retain ourselves until the sheet is dismissed.
    // See -actionSheet:didDismissWithButtonIndex: for the release.
    return [self retain];
}


+ (SheetViewController *)showMessage:(NSString *)message {
    
    return [self showMessage:message backButton:YES];
}


+ (SheetViewController *)showMessage:(NSString *)message backButton:(BOOL)backButton {
    
    return [self showMessage:message
                  backString:backButton? l(@"global.button.back"): nil
                acceptString:l(@"global.button.abort")];
}


+ (SheetViewController *)showMessage:(NSString *)message
         backString:(NSString *)backString acceptString:(NSString *)acceptString {
    
    return [[[[SheetViewController alloc] initWithTitle:message
                                             backString:backString acceptString:acceptString
                                               callback:nil :nil] showSheet] autorelease];
}


- (void)dealloc {
    
    [sheetView release];
    sheetView = nil;
    
    [[invocation target] release];
    [invocation release];
    invocation = nil;
    
    [super dealloc];
}


#pragma mark ###############################
#pragma mark Behaviors

- (void)setTarget:(id)t selector:(SEL)s {
    
    if (t == nil || s == nil) {
        t = self;
        s = @selector(popAll:);
    }
    
    [[invocation target] release];
    [invocation release];
    invocation = nil;
    
    NSMethodSignature *sig = [[t class] instanceMethodSignatureForSelector:s];
    invocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
    [invocation setTarget:[t retain]];
    [invocation setSelector:s];
}


- (SheetViewController *)showSheet {
    
    [sheetView showInView:[AbstractAppDelegate get].window];
    
    return self;
}


- (SheetViewController *)dismissSheet {
    
    [sheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (actionSheet.numberOfButtons == 1 || buttonIndex != 0) {
        if ([[invocation methodSignature] numberOfArguments] > 2)
            [invocation setArgument:[NSNumber numberWithInteger:buttonIndex] atIndex:2];
        [invocation invoke];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    [self release];
}


- (void)popAll:(NSNumber *)buttonIndex {
    
    [[AbstractAppDelegate get] restart];
}


@end

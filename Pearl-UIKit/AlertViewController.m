//
//  AlertViewController.m
//  Pearl
//
//  Created by Maarten Billemont on 22/12/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "AlertViewController.h"
#import "Layout.h"
#import "AbstractAppDelegate.h"
#import "StringUtils.h"


@interface AlertViewController ()

- (void)popAll:(NSNumber *)buttonIndex;

@end


@implementation AlertViewController

static AlertViewController *currentAlert = nil;

+ (AlertViewController*)currentAlert {
    
    return currentAlert;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title message:(NSString *)msg backString:(NSString *)backString {

    return [self initWithTitle:title message:msg backString:backString acceptString:nil callback:nil :nil];
}


- (id)initWithTitle:(NSString *)title message:(NSString *)msg
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector {
    
    if (!(self = [super init]))
        return self;
    
    [self setTitle:title];
    
    if (acceptString || target)
        [self setTarget:target selector:selector];
    
    alertView   = [[UIAlertView alloc] initWithTitle:title message:msg
                                            delegate:self cancelButtonTitle:backString otherButtonTitles:acceptString, nil];
    
    return self;
}


+ (void)showConnectionErrorWithBackButton:(BOOL)backButton {
    
    [AlertViewController showError:l(@"error.connection")
                        backButton:backButton];
}


+ (void)showError:(NSString *)message backButton:(BOOL)backButton {
    
    [self showError:message backButton:backButton abortButton:YES];
}

+ (void)showError:(NSString *)message backButton:(BOOL)backButton abortButton:(BOOL)abortButton {
    
    [AlertViewController showMessage:message withTitle:[PearlStrings get].commonTitleError backButton:backButton abortButton:abortButton];
}


+ (void)showNotice:(NSString *)message {
    
    [self showNotice:message backButton:YES abortButton:NO];
}


+ (void)showNotice:(NSString *)message backButton:(BOOL)backButton abortButton:(BOOL)abortButton {
    
    [AlertViewController showMessage:message withTitle:[PearlStrings get].commonTitleNotice backButton:backButton abortButton:abortButton];
}


+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {

    [self showMessage:message withTitle:title backButton:YES abortButton:NO];
}


+ (void)showMessage:(NSString *)message withTitle:(NSString *)title backButton:(BOOL)backButton abortButton:(BOOL)abortButton {
    
    [self showMessage:message withTitle:title
           backString:backButton? [PearlStrings get].commonButtonBack: nil
         acceptString:abortButton? (backButton? [PearlStrings get].commonButtonAbort: [PearlStrings get].commonButtonRetry): nil];
}


+ (void)showMessage:(NSString *)message withTitle:(NSString *)title
         backString:(NSString *)backString acceptString:(NSString *)acceptString {

    [self showMessage:message withTitle:title backString:backString acceptString:acceptString callback:nil :nil];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector {
    
    AlertViewController *alert = [[AlertViewController alloc] initWithTitle:title message:message
                                                                 backString:backString acceptString:acceptString
                                                                   callback:target :selector];
    [alert showAlert];
    [alert release];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    
    [alertView release];
    alertView = nil;
    
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


- (AlertViewController *)showAlert {
    
    [alertView show];

    [currentAlert release];
    currentAlert = [self retain];
    
    return self;
}


- (AlertViewController *)dismissAlert {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (anAlertView.numberOfButtons == 1 || buttonIndex != 0) {
        if ([[invocation methodSignature] numberOfArguments] > 2)
            [invocation setArgument:[NSNumber numberWithInteger:buttonIndex] atIndex:2];
        [invocation invoke];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (currentAlert == self) {
        [currentAlert release];
        currentAlert = nil;
    }
}


- (void)popAll:(NSNumber *)buttonIndex {
    
    [[AbstractAppDelegate get] restart];
}


@end

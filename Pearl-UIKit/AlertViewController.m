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


@implementation AlertViewController
@synthesize alertView;

static NSMutableArray *activeAlerts = nil;

+ (NSMutableArray *)activeAlerts {
    
    if (!activeAlerts)
        activeAlerts = [[NSMutableArray alloc] initWithCapacity:3];
    
    return activeAlerts;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title message:(NSString *)msg cancelTitle:(NSString *)cancelTitle {
    
    return [self initWithTitle:title message:msg tappedButtonBlock:nil cancelTitle:cancelTitle otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message
  tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self initWithTitle:title message:message tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)msg
  tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    if (!(self = [super init]))
        return self;
    
    [self setTitle:title];
    
    tappedButtonBlock   = [aTappedButtonBlock copy];
    alertView           = [[UIAlertView alloc] initWithTitle:title message:msg delegate:[self retain]
                                           cancelButtonTitle:cancelTitle otherButtonTitles:firstOtherTitle, nil];
    
    if (firstOtherTitle && otherTitlesList) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [alertView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }
    
    return self;
}

+ (AlertViewController *)showError:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitles:nil];
}

+ (AlertViewController *)showError:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                       otherTitles:(NSString *)otherTitles, ...  {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitle:otherTitles :otherTitlesList];
}

+ (AlertViewController *)showNotice:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitles:nil];
}

+ (AlertViewController *)showNotice:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                        otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitle:otherTitles :otherTitlesList];
}

+ (AlertViewController *)showQuestionWithTitle:(NSString *)title message:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex, NSString *answer))aTappedButtonBlock
                                   cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)];
    alertLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.shadowColor = [UIColor blackColor];
    alertLabel.shadowOffset = CGSizeMake(0, -1);
    alertLabel.textAlignment = UITextAlignmentCenter;
    alertLabel.text = message;
    
    UITextField *alertField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
    alertField.keyboardAppearance = UIKeyboardAppearanceAlert;
    alertField.borderStyle = UITextBorderStyleRoundedRect;
    
    AlertViewController *alertVC = [[[self alloc] initWithTitle:title message:@"\n\n\n" tappedButtonBlock:^(NSInteger buttonIndex) {
        aTappedButtonBlock(buttonIndex, alertField.text);
    } cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList] autorelease];
    
    [alertVC.alertView addSubview:alertLabel];
    [alertVC.alertView addSubview:alertField];
    [alertField becomeFirstResponder];
    [alertField release];
    [alertLabel release];
    [alertVC showAlert];

    return alertVC;
}


+ (AlertViewController *)showAlertWithTitle:(NSString *)title message:(NSString *)message
                          tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    return [[[[AlertViewController alloc] initWithTitle:title message:message
                                      tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:firstOtherTitle :otherTitlesList] autorelease] showAlert];
}

+ (AlertViewController *)showAlertWithTitle:(NSString *)title message:(NSString *)message
                          tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:title message:message tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    
    [alertView release];
    alertView = nil;
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
    
    [super dealloc];
}


#pragma mark ###############################
#pragma mark Behaviors

- (AlertViewController *)showAlert {
    
    [alertView show];
    [((NSMutableArray *) [AlertViewController activeAlerts]) addObject:self];
    
    return self;
}


- (AlertViewController *)dismissAlert {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (tappedButtonBlock)
        tappedButtonBlock(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [((NSMutableArray *) [AlertViewController activeAlerts]) removeObject:self];
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
}


@end

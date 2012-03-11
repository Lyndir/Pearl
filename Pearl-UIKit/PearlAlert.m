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
//  PearlAlert.m
//  Pearl
//
//  Created by Maarten Billemont on 22/12/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "PearlAlert.h"
#import "PearlLayout.h"
#import "PearlAppDelegate.h"
#import "PearlStringUtils.h"


@interface PearlAlert (Private)

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle :(va_list)otherTitlesList;
+ (PearlAlert *)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList;

@end

@implementation PearlAlert
@synthesize alertView, alertField;

+ (NSMutableArray *)activeAlerts {
    
    static NSMutableArray *activeAlerts = nil;
    if (!activeAlerts)
        activeAlerts = [[NSMutableArray alloc] initWithCapacity:3];
    
    return activeAlerts;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {
    
    return [self initWithTitle:title message:message viewStyle:UIAlertViewStyleDefault tappedButtonBlock:nil cancelTitle:cancelTitle otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self initWithTitle:title message:message viewStyle:viewStyle tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    if (!(self = [super init]))
        return self;
    
    tappedButtonBlock               = [aTappedButtonBlock copy];
    alertView                       = [[UIAlertView alloc] initWithTitle:title message:message delegate:[self retain]
                                                       cancelButtonTitle:cancelTitle otherButtonTitles:firstOtherTitle, nil];
    
    if ([self.alertView respondsToSelector:@selector(setAlertViewStyle:)]) {
        // iOS 5+
        alertView.alertViewStyle    = viewStyle;
        if (viewStyle != UIAlertViewStyleDefault)
            self.alertField         = [self.alertView textFieldAtIndex:0];
    } else if (viewStyle != UIAlertViewStyleDefault) {
        // iOS <5
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 260, 25)];
        alertLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.shadowColor = [UIColor blackColor];
        alertLabel.shadowOffset = CGSizeMake(0, -1);
        alertLabel.textAlignment = UITextAlignmentCenter;
        alertLabel.text = message;
        self.alertView.message = @"\n\n\n";
        
        self.alertField = [[[UITextField alloc] initWithFrame:CGRectMake(16, 83, 252, 25)] autorelease];
        alertField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertField.borderStyle = UITextBorderStyleRoundedRect;
        if (viewStyle == UIAlertViewStyleSecureTextInput)
            alertField.secureTextEntry = YES;
        
        [self.alertView addSubview:alertLabel];
        [self.alertView addSubview:self.alertField];
        [alertField becomeFirstResponder];
        [alertLabel release];
    }
    
    if (firstOtherTitle && otherTitlesList) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [alertView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }
    
    return self;
}

+ (PearlAlert *)showError:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitles:nil];
}

+ (PearlAlert *)showError:(NSString *)message
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                       otherTitles:(NSString *)otherTitles, ...  {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitle:otherTitles :otherTitlesList];
}

+ (PearlAlert *)showNotice:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitles:nil];
}

+ (PearlAlert *)showNotice:(NSString *)message
                  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                        otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitle:otherTitles :otherTitlesList];
}

+ (PearlAlert *)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    return [[[[PearlAlert alloc] initWithTitle:title message:message viewStyle:viewStyle
                                      tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:firstOtherTitle :otherTitlesList] autorelease] showAlert];
}

+ (PearlAlert *)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:title message:message viewStyle:viewStyle tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
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

- (PearlAlert *)showAlert {
    
    [alertView show];
    [((NSMutableArray *) [PearlAlert activeAlerts]) addObject:self];
    
    return self;
}


- (PearlAlert *)dismissAlert {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (tappedButtonBlock)
        tappedButtonBlock(self.alertView, buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [((NSMutableArray *) [PearlAlert activeAlerts]) removeObject:self];
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
}


@end

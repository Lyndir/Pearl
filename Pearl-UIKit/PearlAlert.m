/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
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
          initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle :(va_list)otherTitlesList;

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
    
    return [self initWithTitle:title message:message viewStyle:UIAlertViewStyleDefault
                     initAlert:nil tappedButtonBlock:nil cancelTitle:cancelTitle otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
          initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self initWithTitle:title message:message viewStyle:viewStyle initAlert:initBlock tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
          initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    if (!(self = [super init]))
        return self;
    
    tappedButtonBlock               = [aTappedButtonBlock copy];
    alertView                       = [[UIAlertView alloc] initWithTitle:title message:message delegate:self
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
        
        self.alertField = [[UITextField alloc] initWithFrame:CGRectMake(16, 83, 252, 25)];
        alertField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertField.borderStyle = UITextBorderStyleRoundedRect;
        if (viewStyle == UIAlertViewStyleSecureTextInput)
            alertField.secureTextEntry = YES;
        
        [self.alertView addSubview:alertLabel];
        [self.alertView addSubview:self.alertField];
        [alertField becomeFirstResponder];
    }
    
    if (firstOtherTitle && otherTitlesList) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [alertView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }
    
    if (initBlock)
        initBlock(alertView, alertField);
    
    return self;
}

+ (PearlAlert *)showError:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitles:nil];
}

+ (PearlAlert *)showError:(NSString *)message
        tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
              otherTitles:(NSString *)otherTitles, ...  {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitle:otherTitles :otherTitlesList];
}

+ (PearlAlert *)showNotice:(NSString *)message {
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitles:nil];
}

+ (PearlAlert *)showNotice:(NSString *)message
         tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
               otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks otherTitle:otherTitles :otherTitlesList];
}

+ (PearlAlert *)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                         initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    return [[[PearlAlert alloc] initWithTitle:title message:message viewStyle:viewStyle
                                    initAlert:initBlock tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:firstOtherTitle :otherTitlesList] showAlert];
}

+ (PearlAlert *)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                         initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showAlertWithTitle:title message:message viewStyle:viewStyle initAlert:initBlock tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
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
}


@end

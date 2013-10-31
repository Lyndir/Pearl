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

@interface PearlAlert()
@property(nonatomic) BOOL handlingClick;
@end

@implementation PearlAlert

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

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self initWithTitle:title message:message viewStyle:viewStyle initAlert:initBlock tappedButtonBlock:aTappedButtonBlock
                   cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
          initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {

    if (!(self = [super init]))
        return self;

    self.tappedButtonBlock = aTappedButtonBlock;
    _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self
                                  cancelButtonTitle:cancelTitle otherButtonTitles:firstOtherTitle, nil];

    if (firstOtherTitle) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [_alertView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }

    PearlMainThreadStart{
        if ([self.alertView respondsToSelector:@selector(setAlertViewStyle:)]) {
            // iOS 5+
            _alertView.alertViewStyle = viewStyle;
            if (viewStyle != UIAlertViewStyleDefault)
                _alertField = [self.alertView textFieldAtIndex:0];
        }
        else if (viewStyle != UIAlertViewStyleDefault) {
            // iOS <5
            UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake( 12, 40, 260, 25 )];
            alertLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            alertLabel.textColor = [UIColor whiteColor];
            alertLabel.backgroundColor = [UIColor clearColor];
            alertLabel.shadowColor = [UIColor blackColor];
            alertLabel.shadowOffset = CGSizeMake( 0, -1 );
            alertLabel.textAlignment = NSTextAlignmentCenter;
            alertLabel.text = message;
            _alertView.message = @"\n\n\n";

            _alertField = [[UITextField alloc] initWithFrame:CGRectMake( 16, 83, 252, 25 )];
            _alertField.keyboardAppearance = UIKeyboardAppearanceAlert;
            _alertField.borderStyle = UITextBorderStyleRoundedRect;
            if (viewStyle == UIAlertViewStyleSecureTextInput)
                _alertField.secureTextEntry = YES;

            [_alertView addSubview:alertLabel];
            [_alertView addSubview:self.alertField];
        }

        if (initBlock)
            initBlock( _alertView, _alertField );

        [_alertField becomeFirstResponder];
    } PearlMainThreadEnd

    return self;
}

+ (instancetype)showError:(NSString *)message {

    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:nil cancelTitle:[PearlStrings get].commonButtonOkay otherTitles:nil];
}

+ (instancetype)showError:(NSString *)message
        tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
              otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self showAlertWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay otherTitle:otherTitles
            :otherTitlesList];
}

+ (instancetype)showNotice:(NSString *)message {

    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:nil cancelTitle:[PearlStrings get].commonButtonThanks otherTitles:nil];
}

+ (instancetype)showNotice:(NSString *)message
         tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
               otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self showAlertWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIAlertViewStyleDefault
                          initAlert:nil tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks
                         otherTitle:otherTitles :otherTitlesList];
}

+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                         initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {

    return [[[self alloc] initWithTitle:title message:message viewStyle:viewStyle
                              initAlert:initBlock tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle
                             otherTitle:firstOtherTitle :otherTitlesList] showAlert];
}

+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                         initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self showAlertWithTitle:title message:message viewStyle:viewStyle initAlert:initBlock tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:cancelTitle otherTitle:otherTitles :otherTitlesList];
}

#pragma mark ###############################
#pragma mark Behaviors

- (PearlAlert *)showAlert {

    __weak UIAlertView *alertView = self.alertView;
    PearlMainThread(^{
        if (!alertView)
            return;

        [alertView show];
        [((NSMutableArray *)[PearlAlert activeAlerts]) addObject:self];
    });

    return self;
}

- (BOOL)isVisible {

    return [self.alertView isVisible];
}

- (PearlAlert *)cancelAlertAnimated:(BOOL)animated {

    __weak PearlAlert *wSelf = self;
    __weak UIAlertView *alertView = self.alertView;
    PearlMainThread(^{
        if (wSelf && !wSelf.handlingClick)
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:animated];
    });

    return self;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (self.tappedButtonBlock) {
        self.handlingClick = YES;
        self.tappedButtonBlock( self.alertView, buttonIndex );
        self.handlingClick = NO;
    }
}

- (void)alertView:(UIAlertView *)anAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    [((NSMutableArray *)[PearlAlert activeAlerts]) removeObject:self];
}

@end

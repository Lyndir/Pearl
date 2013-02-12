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
//  PearlAlert.h
//  Pearl
//
//  Created by Maarten Billemont on 22/12/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * The alert view controller manages a view that displays an alert to the user.
 *
 * The user is presented with a message in an alert dialog and (a) configurable button(s).
 */
@interface PearlAlert : NSObject<UIAlertViewDelegate> {

@private
    UIAlertView *alertView;
    UITextField *alertField;

    void (^tappedButtonBlock)(UIAlertView *alert, NSInteger buttonIndex);
}

@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UITextField *alertField;


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * A list of all alerts in order of appearance.  The last object is the one currently showing.
 */
+ (NSArray *)activeAlerts;

/**
 * Create an alert view controller that controls an alert message.
 *
 * @param title             The title of the alert.
 * @param message           The message string to display in the view.
 * @param viewStyle         The type of alert to show.  This is used to indicate whether text fields need to be added to the alert.
 * @param tappedButtonBlock A block that gets invoked when the user taps a button of the alert.  The tapped alert view is given along with the index of the button that was tapped.
 * @param cancelTitle       The text on the cancel button or nil to not show this button.
 * @param otherTitles       The text on action buttons or nil to not show any such buttons.
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
          initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
  tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))tappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)showError:(NSString *)message;
+ (instancetype)showError:(NSString *)message
        tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))tappedButtonBlock
              otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)showNotice:(NSString *)message;
+ (instancetype)showNotice:(NSString *)message
         tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))tappedButtonBlock
               otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
* Show an alert that contains only an activity indicator (no message and no buttons).
*/
+ (instancetype)showActivityWithTitle:(NSString *)title;
+ (instancetype)showActivityWithTitle:(NSString *)title initAlert:(void (^)(UIAlertView *alert))initBlock;

/**
 * Initializes and shows an alert.  See -initWithTitle:message:viewStyle:tappedButtonBlock:cancelTitle:otherTitles:
 */
+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIAlertViewStyle)viewStyle
                         initAlert:(void (^)(UIAlertView *alert, UITextField *firstField))initBlock
                 tappedButtonBlock:(void (^)(UIAlertView *alert, NSInteger buttonIndex))tappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark ###############################
#pragma mark Behaviors

/**
 * Show the alert managed by this view controller.
 *
 * @return  self, for chaining.
 */
- (PearlAlert *)showAlert;

/**
 * Dismiss the alert managed by this view controller as though the back button had been tapped.
 */
- (PearlAlert *)dismissAlert;

@end

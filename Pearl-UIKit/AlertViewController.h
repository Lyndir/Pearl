//
//  AlertViewController.h
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
@interface AlertViewController : UIViewController <UIAlertViewDelegate> {
    
@private
    UIAlertView     *alertView;
    
    void (^tappedButtonBlock)(NSInteger buttonIndex);
}

@property (nonatomic, retain) UIAlertView *alertView;


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * A list of all alerts in order of appearance.  The last object is the one currently showing.
 */
+ (NSArray *)activeAlerts;

/**
 * Create an alert view controller which conveys the specified information.
 * The cancel/back button causes this view controller to get dismissed (returning to the previous state).
 * The ok/accept button can be used for custom action.
 *
 * @param title         The title of the alert.
 * @param message       The message string to display in the view.
 * @param backString    The text on the cancel/back button or nil to not show such a button.
 * @param acceptString  The text on the ok/accept button or nil to not show such a button.
 * @param callback      The target and selector to invoke when the accept button gets tapped.
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message
  tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)title message:(NSString *)msg
  tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle :(va_list)otherTitlesList;


+ (AlertViewController *)showError:(NSString *)message;
+ (AlertViewController *)showError:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                       otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (AlertViewController *)showNotice:(NSString *)message;
+ (AlertViewController *)showNotice:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                        otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (AlertViewController *)showQuestionWithTitle:(NSString *)title message:(NSString *)message tappedButtonBlock:(void (^)(NSInteger buttonIndex, NSString *answer))aTappedButtonBlock
                                   cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (AlertViewController *)showAlertWithTitle:(NSString *)title message:(NSString *)message
                          tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList;
+ (AlertViewController *)showAlertWithTitle:(NSString *)title message:(NSString *)message
                          tappedButtonBlock:(void (^)(NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark ###############################
#pragma mark Behaviors

/**
 * Show the alert managed by this view controller.
 *
 * @return  self, for chaining.
 */
- (AlertViewController *)showAlert;

/**
 * Dismiss the alert managed by this view controller as though the back button had been tapped.
 */
- (AlertViewController *)dismissAlert;

@end

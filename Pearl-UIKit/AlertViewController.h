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
    
    NSInvocation    *invocation;
}


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * A reference to the alert that's currently showing on screen.
 *
 * @return nil if no alert is showing.
 */
+ (AlertViewController*)currentAlert;

/**
 * Create an alert view controller which conveys the specified information.
 * The cancel/back button causes this view controller to get dismissed (returning to the previous state).
 *
 * @param title         The title of the alert.
 * @param message       The message string to display in the view.
 * @param backString    The text on the cancel/back button or nil to not show such a button.
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)msg backString:(NSString *)backString;

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
- (id)initWithTitle:(NSString *)title message:(NSString *)msg
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector;

/**
 * Create an alert view controller which shows a given error message.
 */
+ (void)showError:(NSString *)message backButton:(BOOL)backButton;

/**
 * Create an alert view controller which shows a given error message.
 */
+ (void)showError:(NSString *)message backButton:(BOOL)backButton abortButton:(BOOL)abortButton;

/**
 * Create an alert view controller which shows a given notice message.
 */
+ (void)showNotice:(NSString *)message;

/**
 * Create an alert view controller which shows a given notice message.
 */
+ (void)showNotice:(NSString *)message backButton:(BOOL)backButton abortButton:(BOOL)abortButton;

/**
 * Create an alert view controller which shows a given message using a give dialog title.
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;

/**
 * Create an alert view controller which shows a given message with two buttons.
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title backButton:(BOOL)backButton abortButton:(BOOL)abortButton;

/**
 * Create an alert view controller which shows a given message with two buttons and a callback for the second.
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector;
    
/**
 * Create an alert view controller which shows a given error message using a give dialog title
 * and allows you to specify the text to use on the back and accept buttons.
 *
 * Use nil for either to hide it.
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title
         backString:(NSString *)backString acceptString:(NSString *)acceptString;
    

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

/**
 * Change the callback to invoke when the alert's ok/accept button is tapped.
 *
 * @param target        The target object upon which the callback selector will be invoked.
 * @param selector      The callback selector to invoke on the target object as soon as the ok/accept button is tapped.
 *                      The selector should take (at least) one argument (NSNumber*).
 *                      That argument will be set to the index of the button that was used to dismiss the alert (base 1).
 */
- (void)setTarget:(id)t selector:(SEL)s;

@end
